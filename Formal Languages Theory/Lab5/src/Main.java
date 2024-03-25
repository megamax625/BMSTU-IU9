import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;
import utils.*;

public class Main {
    public static void main(String[] args) throws IOException {
        String testInput = null, syntaxInput = null;

        try {
            System.err.format("path to syntax: %s\n", args[1]);
            System.err.format("path to testInput: %s\n", args[0]);
            File file0 = new File(args[0]);
            File file1 = new File(args[1]);
            if (file0.exists() && file0.isFile() && file1.exists() && file1.isFile()) {
                String[] res = ReadInputsFromFiles(file0, file1);
                testInput = res[0];
                syntaxInput = res[1];
            } else if (file0.exists() && file0.isFile()) {
                System.out.println("Incorrect path to the second of the two command line argument; using default syntax values");
                testInput = ReadInputsFromFile(file0);
                syntaxInput = GetDefaultSyntax();
            } else {
                System.out.println("Incorrect path to the first of the two command line arguments");
                System.exit(1);
            }
        } catch (ArrayIndexOutOfBoundsException e) {
            try {
                System.out.println("One argument received: " + args[0]);
                File file = new File(args[0]);
                if (file.exists()) {
                    if (file.isDirectory()) {
                        String[] res = ReadInputsFromDirectory(args[0]);
                        testInput = res[0];
                        syntaxInput = res[1];
                    } else if (file.isFile()) {
                        testInput = ReadInputsFromFile(file);
                        System.out.println("Syntax file not specified; using default values");
                        syntaxInput = GetDefaultSyntax();
                    }
                } else {
                    System.out.println("Command line argument single path does not exist");
                    System.exit(2);
                }
            } catch (ArrayIndexOutOfBoundsException ee) {
                System.out.println("No command line arguments specified: can't get inputs");
                System.exit(3);
            } catch (IOException io) {
                System.out.println("IOException gottem");
            }
        } catch (IOException io) {
            System.out.println("IOException gottem");
        }
        assert testInput != null;
        assert syntaxInput != null;
        System.out.println("Success: \n" + testInput.trim());
        System.out.println("Success: \n" + syntaxInput.trim());

        HashMap<String, String> parameters = Parser.ParseParameterizedTokens(syntaxInput);
        ArrayList<Table> tables = Parser.ParseTables(testInput, parameters);
        ArrayList<RelationalTable> relationalTables = RelationalTable.RelationalTableFromArrayList(tables);
        ArrayList<AssociationTable> associationTables = RelationalTable.GetForeignKeys(relationalTables);
        System.out.println("Outputting result of relational conversion\nRelational tables:");
        for (RelationalTable RT : relationalTables) {
            RT.print();
        }
        if (!associationTables.isEmpty()) System.out.println("Association tables:");
        for (AssociationTable AT : associationTables) {
            AT.print();
        }
        ArrayList<Relation> relationsER = new ArrayList<>();
        for (Table table1: tables) {
            for (Table.Connection connection: table1.Connections) {
                for (Table table2: tables) {
                    if (table1 != table2 && Objects.equals(connection.destination, table2.name)) {
                        String connType2 = connection.connType;
                        String connType1 = "";
                        for (Table.Connection conn : table2.Connections) {
                            if (Objects.equals(conn.destination, table1.name))
                                 connType1 = conn.connType;
                        }
                        if (!relationsER.contains(new Relation(table1.name, table2.name,connTypeToYML(connType1), connTypeToYML(connType2))) || !relationsER.contains(new Relation(table2.name, table1.name,connTypeToYML(connType2),connTypeToYML(connType1)))){// не содержит связь table1.name-table2.name или наоборот
                            relationsER.add(new Relation(table1.name, table2.name,connTypeToYML(connType1),connTypeToYML(connType2)));
                        }
                    }
                }
            }
        }
        ArrayList<Relation> relationsRelational = new ArrayList<>();
        for (RelationalTable table1: relationalTables) {
            for (Table.Connection connection: table1.Connections) {
                for (RelationalTable table2: relationalTables) {
                    if (table1 != table2 && Objects.equals(connection.destination, table2.name)) {
                        String connType2 = connection.connType;
                        String connType1 = "";
                        for (Table.Connection conn : table2.Connections) {
                            if (Objects.equals(conn.destination, table1.name))
                                connType1 = conn.connType;
                        }
                        if (!relationsRelational.contains(new Relation(table1.name, table2.name,connTypeToYML(connType1), connTypeToYML(connType2))) || !relationsRelational.contains(new Relation(table2.name, table1.name,connTypeToYML(connType2),connTypeToYML(connType1)))){
                            relationsRelational.add(new Relation(table1.name, table2.name,connTypeToYML(connType1),connTypeToYML(connType2)));
                        }
                    }
                }
            }
        }
        for (AssociationTable table1: associationTables) {
            for (Table.Connection connection: table1.Connections) {
                for (RelationalTable table2: relationalTables) {
                    if (Objects.equals(connection.destination, table2.name)) {
                        String connType2 = connection.connType;
                        String connType1 = "";
                        for (Table.Connection conn : table2.Connections) {
                            System.out.println(conn.destination + " !!! " + table1.name);
                            if (Objects.equals(conn.destination, table1.name)) {
                                connType1 = conn.connType;
                            }
                        }
                        if (!relationsRelational.contains(new Relation(table1.name, table2.name,connTypeToYML(connType1), connTypeToYML(connType2))) || !relationsRelational.contains(new Relation(table2.name, table1.name,connTypeToYML(connType2),connTypeToYML(connType1)))){
                            relationsRelational.add(new Relation(table1.name, table2.name,connTypeToYML(connType1),connTypeToYML(connType2)));
                        }
                    }
                }
            }
        }

        YMLConverter.makeERdiagram(tables, relationsER);
        YMLConverter.makeRelationalDiagram(relationalTables, associationTables, relationsRelational);
        YMLConverter.generatePDFS();

    }

    private static String connTypeToYML(String connType) {
        if (Objects.equals(connType, "0.1Denomination")) {
            return "?";
        } else if (Objects.equals(connType, "0.NDenomination")) {
            return "*";
        } else if (Objects.equals(connType, "1.1Denomination")) {
            return "1";
        } else if (Objects.equals(connType, "1.NDenomination")) {
            return "+";
        }
        return "ERROR";
    }

    private static String GetDefaultSyntax() {
        return """
                TableDelimeter = , ~
                AttributeTypeDelimeter = : ~
                ConnectionDenomination = CONNECTION ~
                0.1Denomination = 0.1 ~
                0.NDenomination = 0.N ~
                1.1Denomination = 1.1 ~
                1.NDenomination = 1.N""";
    }

    private static String ReadInputsFromFile(File file) throws IOException {
        return new String(Files.readAllBytes(Paths.get(String.valueOf(file))));
    }

    private static String[] ReadInputsFromFiles(File file0, File file1) throws IOException {
        String[] res = new String[2];
        res[0] = new String(Files.readAllBytes(Paths.get(String.valueOf(file0))));
        res[1] = new String(Files.readAllBytes(Paths.get(String.valueOf(file1))));
        return res;
    }

    private static String[] ReadInputsFromDirectory(String path) throws IOException {
        String testPath = path + "test.txt", syntaxPath = path + "syntax.txt";
        File file0 = new File(testPath);
        File file1 = new File(syntaxPath);
        if (file0.exists() && file0.isFile() && file1.exists() && file1.isFile()) {
            return ReadInputsFromFiles(file0, file1);
        } else if (file0.exists() && file0.isFile()) {
            System.out.println("Syntax file not found in path directory; using default values");
            String[] res = new String[2];
            res[0] = ReadInputsFromFile(file0);
            res[1] = GetDefaultSyntax();
            return res;
        } else {
            System.out.println("Couldn't find test file in path directory");
            System.exit(1);
        }
        return null;
    }
}
