package utils;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.stream.Stream;

public class Parser {
    public static String[] parameters = new String[]{"TableDelimeter", "AttributeTypeDelimeter", "ConnectionDenomination",
            "0.1Denomination", "0.NDenomination", "1.1Denomination", "1.NDenomination"};
    private static final List<String> parametersList = Arrays.asList(parameters);
    public static String[] defaultDenominators = new String[]{",", ":", "CONNECTION", "0.1", "0.N", "1.1", "1.N"};
    private static final List<String> defaultDenominatorsList = Arrays.asList(defaultDenominators);
    public static String[] nonParametherizedConstantStuff = new String[]{"{", "}", "ID", ",",
            "int", "float", "money", "datetime", "char", "String"};
    private static final List<String> nonParamsList = Arrays.asList(nonParametherizedConstantStuff);
    private static final List<String> cardinalityDenominations = new ArrayList<>();

    public static HashMap<String, String> ParseParameterizedTokens(String syntaxStr) {
        HashMap<String, String> ParameterizedTokens = new HashMap<>();
        if (syntaxStr.replaceAll("\\s", "").isEmpty()) {
            System.out.println("Syntax input file is empty; using default values");
            for (String para : parametersList) {
                ParameterizedTokens.put(defaultDenominatorsList.get(parametersList.indexOf(para)), para);
            }
        } else if (syntaxStr.equals("""
                TableDelimeter = , ~
                AttributeTypeDelimeter = , ~
                ConnectionDenomination = CONNECTION ~
                0.1Denomination = 0.1 ~
                0.NDenomination = 0.N ~
                1.1Denomination = 1.1 ~
                1.NDenomination = 1.N""")) {
            for (String para : parametersList) {
                ParameterizedTokens.put(defaultDenominatorsList.get(parametersList.indexOf(para)), para);
            }
        } else {
            String[] syntax = syntaxStr.replaceAll("\\s", "").split("~");
            for (String s : syntax) {
                String[] str = s.split("=");
                if (str.length != 2) {
                    System.out.println("Incorrect syntax definition: amount of = in one expression is not 1 in expression: " + s);
                    System.exit(4);
                } else {
                    String parameterName = str[0];
                    String parameterDenomination = str[1];
                    if (parametersList.contains(str[0]) && !parameterDenomination.isEmpty())
                        ParameterizedTokens.put(parameterDenomination, parameterName);
                }
            }
            // добиваем не вошедшие в пользовательский синтаксис параметры дефолтными значениями
            for (String para : parametersList) {
                if (!ParameterizedTokens.containsValue(para))
                    ParameterizedTokens.put(defaultDenominatorsList.get(parametersList.indexOf(para)), para);
            }
        }
        for (String para : parameters) {
            if (para.equals("0.1Denomination") || para.equals("0.NDenomination") ||
                    para.equals("1.1Denomination") || para.equals("1.NDenomination")) {
                for (String key : ParameterizedTokens.keySet()) {
                    if (ParameterizedTokens.get(key).equals("0.1Denomination") ||
                            ParameterizedTokens.get(key).equals("0.NDenomination") ||
                            ParameterizedTokens.get(key).equals("1.1Denomination") ||
                            ParameterizedTokens.get(key).equals("1.NDenomination")) {
                        cardinalityDenominations.add(key);
                    }
                }
            }
        }
        System.out.println("Cardinality denominations: [" + cardinalityDenominations.get(0) + " " +
                cardinalityDenominations.get(1) + " " + cardinalityDenominations.get(2) + " " +
                cardinalityDenominations.get(3) + "]");
        System.out.println("Resulting Map of Parameterized tokens:");
        for (String paraDen : ParameterizedTokens.keySet()) {
            System.out.println(paraDen + " -- " + ParameterizedTokens.get(paraDen));
        }
        return ParameterizedTokens;
    }


    private static ArrayList<String> Tokenize(String text, HashMap<String, String> parameterMap) {
        ArrayList<String> tokens = new ArrayList<>();
        StringBuilder buf = new StringBuilder();
        String[] nonParametherizedConstantStuff = new String[]{"{", "}", "ID", ",",
                "int", "float", "money", "datetime", "char", "String"};
        String[] parameterNames = parameterMap.keySet().toArray(new String[0]);
        String[] parasAndNonParas = Stream.concat(Arrays.stream(nonParametherizedConstantStuff),
                Arrays.stream(parameterNames)).toArray(String[]::new);
        boolean checkParasAgain;
        while (!text.isEmpty()) {
            checkParasAgain = false;
            for (String para : parasAndNonParas) {
                if (text.startsWith(para)) {
                    checkParasAgain = true;
                    if (!buf.isEmpty()) {
                        tokens.add(buf.toString());
                        buf = new StringBuilder();
                    }
                    tokens.add(para);
                    text = text.substring(para.length());
                }
            }
            if (!checkParasAgain) {
                if (!text.isEmpty()) {
                    buf.append(text.charAt(0));
                    text = text.substring(1);
                } else {
                    if (!buf.isEmpty()) {
                        tokens.add(buf.toString());
                    }
                }
            }
        }
        System.out.println("Tokens:");
        for (String token : tokens) {
            System.out.print(token + " ");
        }
        System.out.println();
        return tokens;
    }

    public static ArrayList<Table> ParseTables(String testInput, HashMap<String, String> parameterMap) {
        String text = testInput.replaceAll("\\s", "");
        if (text.isEmpty()) {
            System.out.println("Table data is empty");
            System.exit(5);
        }
        System.out.println("Parsing table data:\n" + text);
        ArrayList<Table> tables = new ArrayList<>();
        ArrayList<String> tokens = Tokenize(text, parameterMap);
        boolean first_time = true;
        while (!tokens.isEmpty()) {
            if (!first_time) {      // между таблицами должен стоять разделитель, но если она первая то не надо
                String token = tokens.get(0);
                if (!isTableDelimeter(token, parameterMap)) {
                    System.out.println("Missing Table Delimeter Between Tables: got " + token + " instead");
                    System.exit(7);
                } else {
                    tokens.remove(0);
                }
            }
            first_time = false;
            if (!tokens.isEmpty()) tables.add(ParseTable(tokens, parameterMap));
        }
        return tables;
    }

    private static Table ParseTable(ArrayList<String> tokens, HashMap<String, String> parameterMap) {
        String token = tokens.get(0);
        if (!isName(token, parameterMap)) {
            System.out.println("Error: token " + token + " should be a NAME, but it isn't");
            System.exit(6);
        }
        Table table = new Table(token);
        tokens.remove(0);
        token = tokens.get(0);
        if (!isLeftParenthesis(token)) {
            System.out.println("Error: token " + token + " should be a LEFT PARENTHESIS, but it isn't");
            System.exit(6);
        }
        tokens.remove(0);
        table.ID = ParseID(tokens, parameterMap);
        table.Attributes = ParseAttributes(tokens, parameterMap, 0);
        table.Connections = ParseConnections(tokens, parameterMap);
        token = tokens.get(0);
        System.out.println("Table parsing ended on token " + token);
        if (isRightParenthesis(token)) {
            System.out.println("\nTable parsed successfully:");
            table.print();
            tokens.remove(0);
        } else {
            System.out.println("Error: token " + token + " should be a RIGHT PARENTHESIS, but it isn't");
            System.exit(6);
        }
        return table;
    }

    private static ArrayList<Table.Attribute> ParseID(ArrayList<String> tokens, HashMap<String, String> parameterMap) {
        ArrayList<Table.Attribute> ID;
        String token = tokens.get(0);
        if (!isID(token)) {
            System.out.println("Error: token " + token + " should be an \"ID\", but it isn't");
            System.exit(6);
        }
        tokens.remove(0);
        token = tokens.get(0);
        if (!isLeftParenthesis(token)) {
            System.out.println("Error: token " + token + " should be an ID's LEFT PARENTHESIS, but it isn't");
            System.exit(6);
        }
        tokens.remove(0);
        ID = ParseAttributes(tokens, parameterMap, 1);
        System.out.println("Parsing attributes in ID ended");
        token = tokens.get(0);
        if (!isRightParenthesis(token)) {
            System.out.println("Error: token " + token + " should be an ID's RIGHT PARENTHESIS, but it isn't");
            System.exit(6);
        } else {
            tokens.remove(0);
        }
        return ID;
    }

    private static ArrayList<Table.Attribute> ParseAttributes(ArrayList<String> tokens, HashMap<String, String> parameterMap, int AttrID) {
        String token = tokens.get(0);
        ArrayList<Table.Attribute> Attributes = new ArrayList<>();
        while (isName(token, parameterMap)) {
            Table.Attribute attribute = ParseAttribute(tokens, parameterMap, AttrID);
            token = tokens.get(0);
            if (AttrID > 0) AttrID += 1;
            Attributes.add(attribute);
        }
        token = tokens.get(0);
        System.out.println("Attribute parsing ended on token " + token + " which is not a name for a new attribute");
        if ((AttrID > 0) && (!isRightParenthesis(token))) {
            System.out.println("ID ending on not \"}\" with: " + token);
            System.exit(10);
        }
        return Attributes;
    }

    private static Table.Attribute ParseAttribute(ArrayList<String> tokens, HashMap<String, String> parameterMap, int AttrID) {
        Table.Attribute res = new Table.Attribute();
        String token = tokens.get(0);
        res.name = token;
        res.KeyStatus = AttrID;
        tokens.remove(0);
        token = tokens.get(0);
        if (!isAttributeTypeDelimeter(token, parameterMap)) {
            System.out.println("Error: token " + token + " should be an ATTRIBUTE TYPE DELIMETER, but it isn't");
            System.exit(7);
        }
        tokens.remove(0);
        token = tokens.get(0);
        if (!isType(token)) {
            System.out.println("Error: token " + token + " should be a TYPE, but it isn't");
            System.exit(7);
        }
        res.type = token;
        tokens.remove(0);
        token = tokens.get(0);
        if (!isAttributeDelimeter(token)) {
            System.out.println("Attribute parsing ended on token " + token + " which is not an ATTR DELIMETER (,) to a new attribute");
        } else {
            tokens.remove(0);
        }
        System.out.format("Parsed attribute: name - %s, type - %s\n", res.name, res.type);
        return res;
    }

    private static ArrayList<Table.Connection> ParseConnections(ArrayList<String> tokens, HashMap<String, String> parameterMap) {
        String token = tokens.get(0);
        ArrayList<Table.Connection> connections = new ArrayList<>();
        while (isConnectionDenomination(token, parameterMap)) {
            Table.Connection connection = ParseConnection(tokens, parameterMap);
            connections.add(connection);
            token = tokens.get(0);
        }
        System.out.println("Connections parsing ended on token " + token + " which is not a CONN DENOMINATION for a new conection");
        return connections;
    }

    private static Table.Connection ParseConnection(ArrayList<String> tokens, HashMap<String, String> parameterMap) {
        Table.Connection connection = new Table.Connection();
        tokens.remove(0);
        String token = tokens.get(0);
        if (!isName(token, parameterMap)) {
            System.out.println("Error: token " + token + " should be a NAME (of another table), but it isn't");
            System.exit(8);
        }
        connection.destination = token;
        tokens.remove(0);
        token = tokens.get(0);
        if (!isCardinalityDenomination(token)) {
            System.out.println("Error: token " + token + " should be a CARDINALITY DENOMINATION, but it isn't");
            System.exit(8);
        }
        connection.connType = parameterMap.get(token);
        tokens.remove(0);
        System.out.format("Connection parsed: destintion - %s, type - %s\n", connection.destination, connection.connType);
        token = tokens.get(0);
        if (!isConnectionDelimeter(token)) {
            System.out.println("Connection parsing ended on token " + token + " which is not an CONN DELIMETER (,) to a new connection");
        } else {
            tokens.remove(0);
        }
        return connection;
    }

    private static boolean isCardinalityDenomination(String token) {
        return Parser.cardinalityDenominations.contains(token);
    }

    private static boolean isName(String token, HashMap<String, String> params) {
        return !(params.containsKey(token)) && !(nonParamsList.contains(token));
    }

    private static boolean isID(String token) {
        return token.equals("ID");
    }

    private static boolean isTableDelimeter(String token, HashMap<String, String> params) {
        return params.get(token) != null && params.get(token).equals("TableDelimeter");
    }

    private static boolean isAttributeDelimeter(String token) {
        return token.equals(",");
    }

    private static boolean isConnectionDelimeter(String token) {
        return token.equals(",");
    }

    private static boolean isAttributeTypeDelimeter(String token, HashMap<String, String> params) {
        return params.get(token) != null && params.get(token).equals("AttributeTypeDelimeter");
    }

    private static boolean isConnectionDenomination(String token, HashMap<String, String> params) {
        return params.get(token) != null && params.get(token).equals("ConnectionDenomination");
    }

    private static boolean isType(String token) {
        String[] types = {"int", "float", "money", "datetime", "char", "String"};
        List<String> typesList = Arrays.asList(types);
        return typesList.contains(token);
    }

    private static boolean isLeftParenthesis(String token) {
        return token.equals("{");
    }

    private static boolean isRightParenthesis(String token) {
        return token.equals("}");
    }
}
