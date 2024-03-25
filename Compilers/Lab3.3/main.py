from collections import Counter
import re
import traceback
import parser_edsl as pe
import abc
from dataclasses import dataclass
from pprint import pprint

class SemanticError(pe.Error):
    def __init__(self, pos, message):
        self.pos = pos
        self.__message = message
    @property
    def message(self):
        return self.__message
    
class RepeatedFunctionName(SemanticError):
    def __init__(self, pos, funcname):
        self.pos = pos
        self.funcname = funcname
    @property
    def message(self):
        return f'Одноимённая функция {self.funcname}'
    
class RepeatedVariable(SemanticError):
    def __init__(self, pos, funcname, varname):
        self.pos = pos
        self.funcname = funcname
        self.varname = varname
    @property
    def message(self):
        return f'Одноимённые параметры функции {self.funcname} - {self.varname}'
    
class ArgumentCountMismatch(SemanticError):
    def __init__(self, call_coord, paras_count, args_count):
        self.pos = call_coord
        self.paras_count = paras_count
        self.args_count = args_count
    @property
    def message(self):
        return f'Не совпадает количество формальных и фактических аргументов функции: ожидалось {self.paras_count}, получено {self.args_count}'
    
class ArgumentTypeMismatch(SemanticError):
    def __init__(self, call_coord, expected_type, received_type, index):
        self.pos = call_coord
        self.expected_type = expected_type
        self.received_type = received_type
        self.index = index
    @property
    def message(self):
        return f'Не совпадает тип формального и фактического аргумента функции: аргумент №{self.index}, ожидался тип {self.expected_type}, получен {self.received_type}'
    
class UndefinedFunction(SemanticError):
    def __init__(self, call_coord, name):
        self.pos = call_coord
        self.name = name
    @property
    def message(self):
        return f'Найдена неопределённая функция {self.name}'
    
class UndefinedVariable(SemanticError):
    def __init__(self, name_coord, name):
        self.pos = name_coord
        self.name = name
    @property
    def message(self):
        return f'Найдена неопределённая переменная {self.name}'
    
class carArgumentMismatch(SemanticError):
    def __init__(self, call_coord):
        self.pos = call_coord
    @property
    def message(self):
        return f'Функция car должна принимать аргумент типа [T] и возвращать значение типа T'
    
class cdrArgumentMismatch(SemanticError):
    def __init__(self, call_coord):
        self.pos = call_coord
    @property
    def message(self):
        return f'Функция cdr должна принимать аргумент типа [T] и возвращать значение типа [T]'
    
class nullArgumentMismatch(SemanticError):
    def __init__(self, call_coord):
        self.pos = call_coord
    @property
    def message(self):
        return f'Функция null должна принимать аргумент типа [T] и возвращать значение типа bool'
    
class IfExprCondTypeMismatch(SemanticError):
    def __init__(self, cond_coord, received_type):
        self.pos = cond_coord
        self.received_type = received_type
    @property
    def message(self):
        return f'В условной операции типом условия может быть только bool, но получен {self.received_type}'
    
class IfExprBranchTypeMismatch(SemanticError):
    def __init__(self, res_coord, then_branch_type, else_branch_type):
        self.pos = res_coord
        self.then_type = then_branch_type
        self.else_type = else_branch_type
    @property
    def message(self):
        return f'В условной операции типы выражений в обеих ветвях должны совпадать, но получены: {self.then_type} и {self.else_type}'
    
class BinaryOperationTypeMismatch(SemanticError):
    def __init__(self, bop_coord, mismatch_type, op, received_types):
        self.pos = bop_coord
        self.mismatch_type = mismatch_type
        self.op = op
        self.received_types = received_types
    @property
    def message(self):
        expected_type = ""
        if self.op in ["+", "-", "*", "/"]:
            expected_type = "int"
        if self.op in ["and", "or"]:
            expected_type = "bool"
        # mismatch_type - отвечает за тип ошибки:
        # 1 - значит левый операнд не подошёл под операцию op
        # 2 - значит правый операнд не подошёл под операцию op
        # 3 - значит типы двух ветвей не совпали
        # В received_types один тип если mismatch_type 1 или 2, если 3 - кортеж двух типов
        if self.mismatch_type == 1:
            return f'Левый операнд бинарной операции {self.op} должен быть {expected_type}, а получен {self.received_types}'
        if self.mismatch_type == 2:
            return f'Правый операнд бинарной операции {self.op} должен быть {expected_type}, а получен {self.received_types}'
        if self.mismatch_type == 3:
            return f'Типы операндов бинарой операции {self.op} не совпадают: левый - {self.received_types[0]}, правый - {self.received_types[1]}'
        return f'Некорректный mismatch_type для ошибки'
    
class ListLiteralTypeMismatch(SemanticError):
    def __init__(self, list_coords):
        self.pos = list_coords
    @property
    def message(self):
        return f'Различающиеся типы элементов в литерале списка'
    
class Type(abc.ABC):
    pass

@dataclass
class UnsetType(Type):
    def __repr__(self):
        return ""
    def __eq__(self, other):
        return True
    
@dataclass
class IntType(Type):
    def __repr__(self):
        return 'int'
    def __eq__(self, other):
        return type(self) == type(other) or type(other) == type(UnsetType())
    
@dataclass
class BoolType(Type):
    def __repr__(self):
        return 'bool'
    def __eq__(self, other):
        return type(self) == type(other) or type(other) == type(UnsetType())
    
@dataclass
class ListType(Type):
    type: Type
    def __eq__(self, other):
        return type(self) == type(other) and self.type == other.type or type(other) == type(UnsetType())

@dataclass
class TupleType(Type):
    types: list[Type]
    def __eq__(self, other):
        return type(self) == type(other) and all(map(lambda t: t[0] == t[1], zip(self.types, other.types))) or type(other) == type(UnsetType())
    
@dataclass
class FormalPara:
    name: str
    name_coord: pe.Position
    type: Type
    @pe.ExAction
    def create(attrs, coodrs, res_coord):
        name, type_ = attrs
        cname, ccolon, ctype = coodrs
        return FormalPara(name, coodrs, type_)
    def __eq__(self, other):
        return type(self) == type(other) and self.name == other.name
    
@dataclass
class Expr(abc.ABC):
    type: Type
    def check(self, defs, vars):
        pass

@dataclass()
class IfExpr(Expr):
    condition: Expr
    then_branch: Expr
    else_branch: Expr
    cond_coord: pe.Fragment
    res_coord: pe.Fragment
    @pe.ExAction
    def create(attrs, coords, res_coord):
        cond, then_, else_ = attrs
        cif, ccond, cthen, cthen_, celse, celse_ = coords
        return IfExpr(None, cond, then_, else_, ccond, res_coord)
    def check(self, defs, vars):
        self.condition.check(defs, vars)
        if self.condition.type != BoolType():
            raise IfExprCondTypeMismatch(self.cond_coord, str(self.condition.type))
        self.then_branch.check(defs, vars)
        self.else_branch.check(defs, vars)
        if self.then_branch.type != self.else_branch.type:
            raise IfExprBranchTypeMismatch(self.res_coord, str(self.then_branch.type), str(self.else_branch.type))
        self.type = self.then_branch.type

@dataclass
class Name(Expr):
    name: str
    name_coord: pe.Fragment
    @pe.ExAction
    def create(attrs, coords, res_coord):
        name = attrs[0]
        return Name(None, name, coords)
    def check(self, defs, vars):
        if self.name not in vars:
            raise UndefinedVariable(self.name_coord, self.name)
        self.type = vars[self.name]

@dataclass
class FunctionCall(Expr):
    function_name: str
    function_args: list[Expr]
    call_coord: pe.Fragment
    @pe.ExAction
    def create(attrs, coords, res_coord):
        function_name, function_args = attrs
        return FunctionCall(None, function_name, function_args, res_coord)
    def check(self, defs, vars):
        for arg in self.function_args:
            arg.check(defs, vars)
        if self.function_name not in defs:
            raise UndefinedFunction(self.call_coord, self.function_name)
        if self.function_name == "car":
            if len(self.function_args) != 1 or self.function_args[0].type != ListType(UnsetType()):
                raise carArgumentMismatch(self.call_coord)
            self.type = self.function_args[0].type.type
            return
        if self.function_name == "cdr":
            if len(self.function_args) != 1 or self.function_args[0].type != ListType(UnsetType()):
                raise cdrArgumentMismatch(self.call_coord)
            self.type = self.function_args[0].type
            return
        if self.function_name == "null":
            if len(self.function_args) != 1 or self.function_args[0].type != ListType(UnsetType()):
                raise nullArgumentMismatch(self.call_coord)
            self.type = BoolType()
            return
        func = defs[self.function_name]
        self.type = func.return_type
        # print(self.type)
        if len(self.function_args) != len(func.paras):
            raise ArgumentCountMismatch(self.call_coord, len(func.paras), len(self.function_args))
        for i in range(len(self.function_args)):
            if self.function_args[i].type != func.paras[i].type:
                raise ArgumentTypeMismatch(self.call_coord, str(self.function_args[i].type), str(func.paras[i].type), str(i))

@dataclass
class IntConst(Expr):
    value: int
    type: Type
    @pe.ExAction
    def create(attrs, coords, res_coord):
        value = attrs
        type = IntType()
        return IntConst(type, value)
    
@dataclass
class BooleanConst(Expr):
    value: bool
    type: Type
    @pe.ExAction
    def create(attrs, coords, res_coord):
        value = attrs
        type = BoolType()
        return BooleanConst(type, value)
    
@dataclass
class BinOp(Expr):
    left: Expr
    op: str
    right: Expr
    bop_coord: pe.Fragment
    @pe.ExAction
    def create(attrs, coords, res_coord):
        lhs, bop, rhs = attrs
        return BinOp(None, lhs, bop, rhs, res_coord)
    def check(self, defs, vars):
        self.left.check(defs, vars)
        self.right.check(defs, vars)
        self.type = self.left.type
        if self.op in ["+", "-", "*", "/"]:
            if self.left.type != IntType():
                raise BinaryOperationTypeMismatch(self.bop_coord, 1, self.op, str(self.left.type))
            if self.right.type != IntType():
                raise BinaryOperationTypeMismatch(self.bop_coord, 2, self.op, str(self.right.type))
        if self.op in ["and", "or"]:
            if self.left.type != BoolType():
                raise BinaryOperationTypeMismatch(self.bop_coord, 1, self.op, str(self.left.type))
            if self.right.type != BoolType():
                raise BinaryOperationTypeMismatch(self.bop_coord, 2, self.op, str(self.right.type))
        if self.left.type != self.right.type:
            raise BinaryOperationTypeMismatch(self.bop_coord, 3, self.op, (str(self.left.type), str(self.right.type)))

@dataclass
class ListLiteral(Expr):
    elements: list[Expr]
    list_coords: pe.Fragment
    @pe.ExAction
    def create(attrs, coords, res_coord):
        elements = attrs[0]
        return ListLiteral(None, elements, res_coord)
    def check(self, defs, vars):
        for v in self.elements:
            v.check(defs, vars)
        if len(self.elements) != 0:
            for i in range(len(self.elements)):
                if self.elements[0].type != self.elements[i].type:
                    raise ListLiteralTypeMismatch(self.list_coords)
                self.type = ListType(self.elements[0].type)
        else:
            self.type = ListType(UnsetType())

@dataclass
class TupleLiteral(Expr):
    elements: list[Expr]
    def check(self, defs, vars):
        types = []
        for v in self.elements:
            v.check(defs, vars)
            if v.type == IntType():
                types = types + [IntType()]
            if v.type == BoolType():
                types = types + [BoolType()]
        self.type = TupleType(types)

@dataclass
class Function:
    name: str
    paras: list[FormalPara]
    return_type: Type
    body: Expr
    func_coord: pe.Fragment
    @pe.ExAction
    def create(attrs, coords, res_coord):
        name, paras, return_type, body = attrs
        cname, clparen, cparas, crparen, ccolon, ctype, ceq, cexpr, csemicolon = coords
        return Function(name, paras, return_type, body, res_coord)
    def check(self, defs):
        for i in range(len(self.paras)):
            for j in range(i + 1, len(self.paras)):
                if self.paras[i] == self.paras[j]:
                    raise RepeatedVariable(self.func_coord, self.name, self.paras[i].name)
        vars = dict([var.name, var.type] for var in self.paras)
        # print(vars)
        self.body.check(defs, vars)


@dataclass
class Start:
    defs: list[Function]
    def check(self):
        defined = {"car": None,
                   "cdr": None,
                   "null": None}
        for f in self.defs:
            if f.name in defined:
                raise RepeatedFunctionName(f.func_coord, f.name)
            defined[f.name] = f
        for f in self.defs:
            f.check(defined)

NAME = pe.Terminal("NAME", '[A-Za-z][A-Za-z0-9_]*', str)
INTEGER = pe.Terminal("INTEGER", '[0-9]+', int, priority=7)

def make_keyword(image):
    return pe.Terminal(image, image, lambda name: None,
                       re_flags=re.IGNORECASE, priority=10)

KW_INT, KW_BOOL, KW_TRUE, KW_FALSE = \
    map(make_keyword, 'int bool true false'.split())
KW_IF, KW_THEN, KW_ELSE, KW_AND, KW_OR = \
    map(make_keyword, 'if then else and or'.split())

NStart, NProgram, NFunction, NFormalParas, NFormalParasTail, NFormalPara = \
    map(pe.NonTerminal, 'Start Program Function FormalParas FormalParasTail FormalPara'.split())
NType, NTupleType, NTupleTypeTail = \
    map(pe.NonTerminal, 'Type TupleType TupleTypeTail'.split())
NExpr, NCond, NCondTailOr, NCondTail, NArithExpr, NTerm, NFactor, NFunctionCall = \
    map(pe.NonTerminal, 'Expr Cond CondTailOr CondTail ArithExpr Term Factor FunctionCall'.split())
NBooleanConst, NAddOp, NMulOp, = map(pe.NonTerminal, 'BooleanConst AddOp MulOp'.split())
NListLiteral, NListLiteralInside, NListLiteralInsideTail = \
    map(pe.NonTerminal, 'ListLiteral, ListLiteralInside, ListLiteralInsideTail'.split())
NTupleLiteral, NTupleLiteralTail = \
    map(pe.NonTerminal, 'TupleLiteral TupleLiteralTail'.split())
NOrOp, NAndOp, NBooleanConst, NAddOp, NMulOp = \
    map(pe.NonTerminal, 'OrOp AndOp BooleanConst AddOp MulOp'.split())

NStart |= NProgram, Start
NProgram |= NFunction, NProgram, lambda x, y: [x] + y
NProgram |= lambda: []

NFunction |= NAME, "(", NFormalParas, ")", ":", NType, "=", NExpr, ";", Function.create
NFormalParas |= NFormalPara, NFormalParasTail, lambda x, y: [x] + y
NFormalParasTail |= ",", NFormalPara, NFormalParasTail, lambda x, y: [x] + y
NFormalParasTail |= lambda: []
NFormalPara |= NAME, ":", NType, FormalPara.create

NType |= KW_INT, IntType
NType |= KW_BOOL, BoolType
NType |= "[", NType, "]", ListType
NType |= NTupleType
NTupleType |= "(", NType, ",", NType, NTupleTypeTail, ")", lambda x, y, z: TupleType([x, y] + z)
NTupleTypeTail |= ",", NType, NTupleTypeTail, lambda x, y: [x] + y
NTupleTypeTail |= lambda: []

NExpr |= KW_IF, NCond, KW_THEN, NExpr, KW_ELSE, NExpr, IfExpr.create
NExpr |= NArithExpr
NExpr |= NListLiteral
NExpr |= NTupleLiteral

NCond |= NCond, NOrOp, NCondTailOr, BinOp.create
NCond |= NCondTailOr
NOrOp |= KW_OR, lambda: "or"
NCondTailOr |= NCondTailOr, NAndOp, NCondTail, BinOp.create
NCondTailOr |= NCondTail
NAndOp |= KW_AND, lambda: "and"
NCondTail |= NAME, Name.create
NCondTail |= NFunctionCall
NCondTail |= "(", NCond, ")"
NCondTail |= NBooleanConst
NBooleanConst |= KW_TRUE, lambda x: BooleanConst(True)
NBooleanConst |= KW_FALSE, lambda x: BooleanConst(False)

NArithExpr |= NArithExpr, NAddOp, NTerm, BinOp.create
NArithExpr |= NTerm
NAddOp |= "+", lambda: "+"
NAddOp |= "-", lambda: "-"
NTerm |= NTerm, NMulOp, NFactor, BinOp.create
NTerm |= NFactor
NMulOp |= "*", lambda: "*"
NMulOp |= "/", lambda: "/"
NFactor |= INTEGER, IntConst.create
NFactor |= NAME, Name.create
NFactor |= NFunctionCall

NFunctionCall |= NAME, "(", NListLiteralInside, ")", FunctionCall.create
NListLiteral |= "[", NListLiteralInside, "]", ListLiteral.create
NListLiteralInside |= NExpr, NListLiteralInsideTail, lambda x, y: [x] + y
NListLiteralInside |= lambda: []
NListLiteralInsideTail |= ",", NExpr, NListLiteralInsideTail, lambda x, y: [x] + y
NListLiteralInsideTail |= lambda: []
NTupleLiteral |= "(", NExpr, ",", NExpr, NTupleLiteralTail, ")", lambda x, y, z:  TupleLiteral(None, [x, y] + z)
NTupleLiteralTail |= ",", NExpr, NTupleLiteralTail, lambda x, y: [x] + y
NTupleLiteralTail |= lambda: []

if __name__ == "__main__":
    p = pe.Parser(NStart)
    assert p.is_lalr_one()
    p.add_skipped_domain('\\s')
    p.add_skipped_domain('--[^\n]*\n')
    tests = ["test.txt", "testSameNamedFunctions.txt", "testSameNamedParas.txt",
            "testCorrectParas.txt", "testCar.txt", "testCdr.txt",
            "testNull.txt", "testIfTypes.txt", "testNoImplicitTypeConv.txt"]
    for filename in tests:
        try:
            with open(filename) as f:
                tree = p.parse(f.read())
                # pprint(tree)
                tree.check()
                print("Семантических ошибок в тесте " + filename + " не найдено")
                if filename == "test.txt":
                    pprint(tree)
        except pe.Error as e:
            print(f'Ошибка {e.pos}: {e.message} в тесте {filename}')
        except Exception as e:
            print(str(type(e)) + ": " + str(e))
            print(traceback.format_exc())
