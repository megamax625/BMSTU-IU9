package utils;

import java.util.Objects;

public class Relation {
    public String from;
    public String to;
    public String connType1;
    public String connType2;

    public Relation(String from, String to, String connType1, String connType2) {
        this.from = from;
        this.to = to;
        this.connType1 = connType1;
        this.connType2 = connType2;
    }

    public String getConnType() {
        return connType1 + "--" + connType2;
    }

    @Override
    public String toString() {
        return "From:" + from + "\n" + "To: " + to + "\n" + getConnType();
    }

    @Override
    public boolean equals(Object obj) {
        if (obj == this)
            return true;
        if (!(obj instanceof Relation))
            return false;
        Relation r = (Relation) obj;
        if (Objects.equals(from, r.from) && Objects.equals(to, r.to)) {
            return Objects.equals(connType1, r.connType1) && Objects.equals(connType2, r.connType2);
        } else if (Objects.equals(from, r.to) && Objects.equals(to, r.from)) {
            return Objects.equals(connType1, r.connType2) && Objects.equals(connType2, r.connType1);
        }
        return false;
    }
}
