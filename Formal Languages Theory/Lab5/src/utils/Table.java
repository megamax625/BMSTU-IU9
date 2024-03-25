package utils;

import java.util.ArrayList;

public class Table {
    public String name;
    ArrayList<Attribute> ID;
    ArrayList<Attribute> Attributes;
    public ArrayList<Connection> Connections;

    public Table(String name) {
        this.name = name;
        this.ID = new ArrayList<>();
        this.Attributes = new ArrayList<>();
        this.Connections = new ArrayList<>();
    }

    public void print() {
        System.out.println("Outputting table " + this.name);
        System.out.println("ID: {");
        for (Attribute IDAttr : ID) {
            System.out.format("%s -- %s\n", IDAttr.name, IDAttr.type);
        }
        System.out.println("}\nAttributes:");
        if (Attributes.isEmpty()) {
            System.out.println("None");
        } else {
            for (Attribute attr : Attributes) {
                System.out.format("%s -- %s\n", attr.name, attr.type);
            }
        }
        System.out.println("Connections:");
        if (Connections.isEmpty()) {
            System.out.println("None");
        } else {
            for (Connection conn : Connections) {
                System.out.format("to %s with cardinality of %s\n", conn.destination, conn.connType);
            }
        }
        System.out.println();
    }

    public static class Attribute {
        String name;
        String type;
        int KeyStatus; // n = -1 => FK, n = -2 => (FK, AK1), n = 0 => NO, n >= 1 => AK1.

        public Attribute(String name, String type, int KeyStatus) {
            this.name = name;
            this.type = type;
            this.KeyStatus = KeyStatus;
        }

        public Attribute(String name, String type) {
            this.name = name;
            this.type = type;
            this.KeyStatus = 0;
        }

        public Attribute() {
            this.name = "";
            this.type = "";
            this.KeyStatus = 0;
        }
    }


    public static class Connection {
        public String destination;
        public String connType;

        public Connection() {
            this.destination = "";
            this.connType = "";
        }

        public Connection(String dest, String type) {
            this.destination = dest;
            this.connType = type;
        }
    }
}
