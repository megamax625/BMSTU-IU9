import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Scanner;
import java.util.Stack;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Main {
    static class Token {
        final Tag tag;
        final int line;
        final int pos;
        final String data;

        public Token(Tag tag, int line, int pos, String data) {
            this.tag = tag;
            this.line = line;
            this.pos = pos;
            this.data = data;
        }

        @Override
        public String toString() {
            if (tag.name() != "SYNTAX_ERROR") {
                return tag.name() + " (" + line + ", " + pos + "): " + data;
            } else {
                return tag.name() + " (" + line + ", " + pos + ")";
            }
        }
    }

    enum Tag {
        AXIOM,
        TERM,
        NONTERM,
        LEFT_PAREN,
        RIGHT_PAREN,
        ALTERNATIVE,
        DOT,
        COMMENT,
        EQUAL_SIGN,
        eof,
        SYNTAX_ERROR;
    }

    static class MyScanner {
        public static ArrayList<Token> readFile(String name, boolean debug) throws FileNotFoundException {
            StringBuilder dataStrB = new StringBuilder();
            Scanner scanner = new Scanner(new File(name));
            ArrayList<Token> res = new ArrayList<>();
            int lineNum = 1;

            while (scanner.hasNextLine()) {
                String line = scanner.nextLine();
                dataStrB.append(line).append("\n");
                if (debug) System.out.println("line №" + lineNum + ": \"" + line + "\"");
                lineNum++;
            }
            System.out.println();
            dataStrB.append("✔");
            String data = dataStrB.toString();
            int line = 1;
            int pos = 1;
            
            String AXIOM_EXPR = "axiom";
            String TERM_EXPR = "([a-z+*]|\\\\[()])";
            String NONTERM_EXPR = "[A-Z]([A-Z0-9])*";

            String LEFT_PAREN = "(\\()";
            String RIGHT_PAREN = "(\\))";
            String ALTERNATIVE = "(\\|)";
            String DOT = "(\\.)";
            String COMMENT = "(;.*\n)";
            String EQUAL_SIGN_EXPR = "=";
            String WHITESPACE = "([ \t\r])";
            String NEWLINE = "\n";

            // Компиляция регулярного выражения
            String pattern = "(?<axiom>^" + AXIOM_EXPR + ")|(?<term>^" + TERM_EXPR + ")|(?<nonterm>^" + NONTERM_EXPR + ")|(?<leftParen>^"
            + LEFT_PAREN + ")|(?<rightParen>^" + RIGHT_PAREN + ")|(?<alternative>^" + ALTERNATIVE + ")|(?<equal>^" + EQUAL_SIGN_EXPR +
            ")|(?<dot>^" + DOT + ")|(?<comment>^" + COMMENT + ")|(?<whitespace>^" + WHITESPACE + ")|(?<newline>^" + NEWLINE + ")";
            Pattern p = Pattern.compile(pattern);
            if (debug) System.out.println(pattern);

            boolean error_encountered = false;
            while (!data.toString().equals("✔")) {
                // System.out.println(data);
                Matcher m = p.matcher(data.toString());
                if (m.find(0)) {
                    error_encountered = false;
                    if (m.group("axiom") != null) {
                        String text = m.group("axiom");
                        res.add(new Token(Tag.AXIOM, line, pos, text));
                        // System.out.println("got axiom: " + text);
                        pos += text.length();
                    }
                    else if (m.group("term") != null) {
                        String text = m.group("term");
                        res.add(new Token(Tag.TERM, line, pos, text));
                        // System.out.println("got term: " + text);
                        pos += text.length();
                    }
                    else if (m.group("nonterm") != null) {
                        String text = m.group("nonterm");
                        res.add(new Token(Tag.NONTERM, line, pos, text));
                        // System.out.println("got nonterm: " + text);
                        pos += text.length();
                    }
                    else if (m.group("leftParen") != null) {
                        String text = m.group("leftParen");
                        res.add(new Token(Tag.LEFT_PAREN, line, pos, text));
                        // System.out.println("got (: " + text);
                        pos += text.length();
                    }
                    else if (m.group("rightParen") != null) {
                        String text = m.group("rightParen");
                        res.add(new Token(Tag.RIGHT_PAREN, line, pos, text));
                        // System.out.println("got ): " + text);
                        pos += text.length();
                    }
                    else if (m.group("alternative") != null) {
                        String text = m.group("alternative");
                        res.add(new Token(Tag.ALTERNATIVE, line, pos, text));
                        // System.out.println("got |: " + text);
                        pos += text.length();
                    }
                    else if (m.group("dot") != null) {
                        String text = m.group("dot");
                        res.add(new Token(Tag.DOT, line, pos, text));
                        // System.out.println("got .: " + text);
                        pos += text.length();
                    }
                    else if (m.group("equal") != null) {
                        String text = m.group("equal");
                        res.add(new Token(Tag.EQUAL_SIGN, line, pos, text));
                        // System.out.println("got .: " + text);
                        pos += text.length();
                    }
                    else if (m.group("comment") != null) {
                        String text = m.group("comment");
                        res.add(new Token(Tag.COMMENT, line, pos, text));
                        // System.out.println("got comment: " + text);
                        line++;
                        pos += 1;
                    }
                    else if (m.group("whitespace") != null) {
                        // System.out.println("\ngot whitespace\n");
                        pos++;
                    }
                    else if (m.group("newline") != null) {
                        // System.out.println("Finished with line " + line);
                        line++;
                        pos = 1;
                    }
                    // System.out.println("Slicing first " + m.end() + " chars\n");
                    data = data.substring(m.end());
                } else {
                    // System.out.println("Got syntax error with error_encountered = " + error_encountered);
                    if (!error_encountered) {
                        res.add(new Token(Tag.SYNTAX_ERROR, line, pos, ""));
                        error_encountered = true;
                    }
                    pos++;
                    data = data.substring(1);
                }
            }
            return res;
        }
    }

    abstract static class Node {
        abstract void print(String indent);
    }

    static class Term extends Node {
        Token token;
        void print(String indent) {
            print(indent + token.toString());
        }
    }

    static class Nonterm extends Node {
        String name;
        ArrayList<Node> children = new ArrayList<>();
        public Nonterm() {
            name = "";
            children = new ArrayList<>();
        }
        public Nonterm(String n) {
            name = n;
            children = new ArrayList<>();
        }
        void print(String indent) {
            System.out.println(indent + name + ':');
            for (Node child : children) {
                child.print(indent + " ");
            }
        }
    }

    static class ChildNode extends Node {
        Token token;
        public ChildNode(Token tok) {
            token = tok;
        }
        void print(String indent) {
            String[] tagNames = new String[]{"TERM", "NONTERM", "LEFT_PAREN", "RIGHT_PAREN", "EQUAL_SIGN", "DOT", "ALTERNATIVE", "AXIOM"};
            if (Arrays.stream(tagNames).anyMatch((t) -> (t.equals(token.tag.name())))) {
                System.out.printf("%sChild: %s -- %s\n", indent, token.tag, token.data);
            } else {
                System.out.printf("%sChild: %s\n", indent, token.tag);
            };
        }
    }

    static class StackItem {
        String symbol;
        Nonterm parent;
        public StackItem(String sym, Main.Nonterm nt) {
            symbol = sym;
            parent = nt;    
        }
        @Override
        public String toString() {
            return '(' + symbol + ',' + parent.name + ')';
        }
    }


    static class topDownParser {
        static HashMap<String, String[]> getTable() {
            HashMap<String, String[]> table = new HashMap<>();

            table.put("RULES;LEFT_PAREN", new String[]{"RULE", "RULES"});
            table.put("RULES;eof", new String[]{});
            table.put("RULE;LEFT_PAREN", new String[]{"LHS", "EQUAL_SIGN", "RHS"});
            table.put("RULE;eof", new String[]{});
            table.put("LHS;LEFT_PAREN", new String[]{"LEFT_PAREN", "Nterm", "RIGHT_PAREN"});
            table.put("Nterm;AXIOM", new String[]{"AXIOM", "NONTERM"});
            table.put("Nterm;NONTERM", new String[]{"NONTERM"});
            table.put("RHS;TERM", new String[]{"TERM","RHS_tail"});
            table.put("RHS;LEFT_PAREN", new String[]{"LEFT_PAREN", "NONTERM", "RIGHT_PAREN", "RHS_tail"});
            table.put("RHS_tail;TERM", new String[]{"TERM", "RHS_tail"});
            table.put("RHS_tail;LEFT_PAREN", new String[]{"LEFT_PAREN", "NONTERM", "RIGHT_PAREN", "RHS_tail"});
            table.put("RHS_tail;ALTERNATIVE", new String[]{"ALTERNATIVE", "RHS_tail"});
            table.put("RHS_tail;DOT", new String[]{"DOT"});

            return table;
        }

        static boolean isTerminal(StackItem s) {
            return s.symbol.equals("TERM") || s.symbol.equals("LEFT_PAREN") || s.symbol.equals("RIGHT_PAREN") ||
            s.symbol.equals("EQUAL_SIGN") || s.symbol.equals("AXIOM") || s.symbol.equals("ALTERNATIVE")
            || s.symbol.equals("DOT") || s.symbol.equals("NONTERM");
        }
        
        static Node top_down(ArrayList<Token> tokens, boolean debug) throws Exception {
            HashMap<String, String[]> table = getTable();
            Nonterm Start = new Nonterm();
            Stack<StackItem> stack = new Stack<>();
            stack.push(new StackItem("RULES", Start));
            int i = 0;
            Token a = tokens.get(i);
            i++;

            while (i < tokens.size()) {
                if (debug) System.out.println(stack.toString() + " " + a);
                StackItem X = stack.pop();
                if (isTerminal(X)) {
                    if (X.symbol.equals(a.tag.name())) {
                        if (debug) System.out.println(X.symbol + ":t " + a.tag.name());
                        X.parent.children.add(new ChildNode(a));
                        a = tokens.get(i);
                        i++;
                    } else {
                        throw new Exception("Unexpected token1: " + a.tag.name() + " with " + X.symbol);
                    }
                } else if (table.containsKey(X.symbol + ";" + a.tag.name())) {
                    Nonterm n = new Nonterm(X.symbol);
                    X.parent.children.add(n);
                    String[] symbols = table.get(X.symbol + ";" + a.tag.name());
                    if (debug) System.out.println(X.symbol + ": " + a.tag.name());
                    List<String> list = Arrays.asList(symbols);
                    ArrayList<String> syms = new ArrayList<String>(list);
                    Collections.reverse(syms);
                    for (String sym : syms) {
                        stack.push(new StackItem(sym, n));
                    }
                } else {
                    throw new Exception("Unexpected token2: " + a.tag.name() + " with " + X.symbol);
                }
            }
            return Start.children.get(0);
        }
    }

    public static void main(String[] args) throws Exception {
        final boolean debug = false;
        ArrayList<Token> tokens = MyScanner.readFile("./test.txt", debug);
        ArrayList<Token> comments = new ArrayList<>();
        for (Token tok : new ArrayList<>(tokens)) {
            if (tok.tag.equals(Tag.COMMENT)) {
                tokens.remove(tok);
                comments.add(tok);
            }
        }
        if (debug) tokens.forEach(System.out::println);
        Token dol = new Token(Tag.eof, 0, 0, "$");
        tokens.add(dol);
        Node res = topDownParser.top_down(tokens, debug);
        res.print("");
    }
}