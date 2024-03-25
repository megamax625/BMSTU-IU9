package utils;

import java.io.*;
import java.util.ArrayList;

public class YMLConverter {
    static public void makeERdiagram(ArrayList<Table> ERtables, ArrayList<Relation> relations) {
        String tablesInYML = "";
        String relationsInYML = "";
        for (Table table : ERtables) {
            tablesInYML += "[" + table.name + "]\n";
            for (Table.Attribute id : table.ID) {
                tablesInYML += "    *" + id.name + "\n";
            }
            for (Table.Attribute attribute : table.Attributes) {
                tablesInYML += "    " + attribute.name + "\n";
            }
        }
        for (Relation relation : relations) {
            relationsInYML += relation.from + " " + relation.getConnType() + " " + relation.to + "\n";
        }
        File outputDir = new File("output");
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }
        try {
            File myObj = new File("./output/er_diagram.er");
            if (myObj.createNewFile()) {
                System.out.println("File created: " + myObj.getName());
            } else {
                System.out.println("File already exists.");
            }
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        try {
            FileWriter myWriter = new FileWriter("./output/er_diagram.er");
            myWriter.write(tablesInYML);
            myWriter.write(relationsInYML);
            myWriter.close();
            System.out.println("Successfully wrote to the file.");
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }

    static public void makeRelationalDiagram(ArrayList<RelationalTable> relationalTables, ArrayList<AssociationTable> associationTables, ArrayList<Relation> relations) {
        String tablesInYML = "";
        String relationsInYML = "";
        for (RelationalTable relationalTable : relationalTables) {
            tablesInYML += relationalTable.printToYML();
        }
        for (AssociationTable associationTable : associationTables) {
            tablesInYML += associationTable.printToYML();
        }
        for (Relation relation : relations) {
            relationsInYML += relation.from + " " + relation.getConnType() + " " + relation.to + "\n";
        }
        File outputDir = new File("output");
        if (!outputDir.exists()) {
            outputDir.mkdirs();
        }
        try {
            File myObj = new File("./output/relational_diagram.er");
            if (myObj.createNewFile()) {
                System.out.println("File created: " + myObj.getName());
            } else {
                System.out.println("File already exists.");
            }
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
        try {
            FileWriter myWriter = new FileWriter("./output/relational_diagram.er");
            myWriter.write(tablesInYML);
            myWriter.write(relationsInYML);
            myWriter.close();
            System.out.println("Successfully wrote to the file.");
        } catch (IOException e) {
            System.out.println("An error occurred.");
            e.printStackTrace();
        }
    }

    static public void generatePDFS() {
        ProcessBuilder processBuilder = new ProcessBuilder();
        String generate_er = "eralchemy -i ./output/er_diagram.er -o ./output/er_diagram.pdf";
        String generate_relational = "eralchemy -i ./output/relational_diagram.er -o ./output/relational_diagram.pdf";
        processBuilder.command("bash", "-c", generate_er + "\n" + generate_relational);

        try {

            Process process = processBuilder.start();

            StringBuilder output = new StringBuilder();

            BufferedReader reader = new BufferedReader(
                    new InputStreamReader(process.getInputStream()));

            String line;
            while ((line = reader.readLine()) != null) {
                output.append(line + "\n");
            }

            int exitVal = process.waitFor();
            if (exitVal == 0) {
                System.out.println("Success!");
                System.out.println(output);
                System.exit(0);
            }

        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
