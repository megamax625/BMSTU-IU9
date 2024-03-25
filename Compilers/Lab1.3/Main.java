import java.io.File;
import java.io.FileNotFoundException;
import java.util.*;

public class Main {
    static class Position implements Comparable<Position> {
        private int line, pos, index;
        private String text;
        Position(String text) {
            this.text = text;
            line = 1;
            pos = 1;
            index = 0;
        }
        Position(Position copy) {
            this.text = copy.text;
            line = copy.line;
            pos = copy.pos;
            index = copy.index;
        }
        @Override
        public int compareTo(Main.Position other) {
            return index > other.index ? 1 : other.index > index ? -1 : 0;
        }
        @Override
        public String toString() {
            return "(" + Integer.toString(line) + "," + Integer.toString(pos) + ")";
        }

        public int getCp() {
            return (index == text.length()) ? -1 : Character.codePointAt(text.toCharArray(), index);
        }

        public boolean isWhitespace() {
            return (index != text.length()) && Character.isWhitespace(getCp());
        }
        public boolean isUppercaseLetter() {
            return (index != text.length()) && Character.isUpperCase(getCp());
        }
        public boolean isLetter() {
            return (index != text.length()) && Character.isLetter(getCp());
        }
        public boolean isDigit() {
            return (index != text.length()) && (text.charAt(index) >= '0') && (text.charAt(index) <= '9');
        }
        public boolean isCurrency() {
            return (index != text.length()) && ("$¢£¥₠₡₣₤₨₩₪€₮₱₸₺₽₿".indexOf(text.charAt(index)) != -1);
        }
        public boolean isNewline() {
            return (index == text.length()) ? true : 
            ((text.charAt(index) == '\r' && (index + 1 < text.length())) ? (text.charAt(index + 1) == '\n') : 
            (text.charAt(index) == '\n'));
        }
        public boolean isDash() {
            return (index != text.length()) && (getCp() == Character.codePointAt(String.valueOf('-').toCharArray(), 0));
        }

        public Position next() {
            if (index < text.length()) {
                if (this.isNewline()) {
                    if (this.text.charAt(this.index) == '\r') this.index += 1;
                    this.line += 1;
                    this.pos = 1;
                } else {
                    if (Character.isHighSurrogate(this.text.charAt(this.index))) this.index += 1;
                    this.pos += 1;
                }
                this.index += 1;
            }
            return this;
        }
    }

    static class Fragment {
        Position starting;
        Position following;
        public Fragment(Position start, Position follow) {
            starting = start;
            following = follow;
        }
        @Override
        public String toString() {
            return starting.toString() + " - " + following.toString();
        }
    }

    static class Message {
        boolean isError;
        String text;
        public Message(boolean isError, String text) {
            this.isError = isError;
            this.text = text;
        }
    }

    enum DomainTag {
        // Идентификаторы: последовательности буквенных символов Unicode, цифр и дефисов, начинающиеся с заглавной буквы.
        // Директивы: любой знак валюты, после которого следует непустая последовательность заглавных букв.
        IDENT,          // Ident ::= UpperLetterUni (LetterUni | DigitUni | Dash)*
                        // UpperLetterUni ::= все заглавные буквы
                        // LetterUni ::= все буквенные литеры
                        // DigitUni = '0' | '1' | ... | '9'
                        // Dash = '-'
        DIRECTIVE,      // Directive ::= Currency UpperLetterUni UpperLetterUni*
                        // Currency ::= [$¢£¥₠₡₣₤₨₩₪€₮₱₸₺₽₿]
        END_OF_PROGRAM,
    }

    static abstract class Token {
        DomainTag Tag;
        Fragment Coords;
        protected Token(DomainTag tag, Position starting, Position following) {
            Tag = tag;
            Coords = new Fragment(starting, following);
        }
        @Override
        public String toString() {
            return Tag.toString() + " " + Coords.toString();
        }
    }

    static class IdentToken extends Token {
        int Code;
        public IdentToken(int code, Position starting, Position following) {
            super(DomainTag.IDENT, starting, following);
            Code = code;
        }
        @Override
        public String toString() {
            return super.toString() + ": " + Code;
        }
    }

    static class DirectiveToken extends Token {
        String value;
        public DirectiveToken(String value, Position starting, Position following) {
            super(DomainTag.DIRECTIVE, starting, following);
            this.value = value;
        }
        @Override
        public String toString() {
            return super.toString() + ": " + value;
        }
    }

    static class EOFToken extends Token {
        public EOFToken() {
            super(DomainTag.END_OF_PROGRAM, new Position(""), new Position(""));
        }
    }

    static class LabScanner {
        String program;
        Compiler compiler;
        Position cur;
        ArrayList<Fragment> comments;

        public LabScanner(String program, Compiler compiler) {
            this.compiler = compiler;
            this.program = program;
            cur = new Position(program);
            comments = new ArrayList<Fragment>();
        }

        public Token nextToken() {
            while (cur.getCp() != -1) {
                while ((cur.isWhitespace() || cur.isNewline()) && (cur.getCp() != -1)) cur = cur.next();
                if (cur.getCp() == -1) return new EOFToken();
                Position start = new Position(cur);
                if (cur.isCurrency()) {
                    StringBuilder currency = new StringBuilder();
                    currency.append(Character.toChars(cur.getCp()));
                    cur = cur.next();
                    while (cur.isUppercaseLetter()) {
                        currency.append(Character.toChars(cur.getCp()));
                        cur = cur.next();
                    }
                    if (currency.length() > 1) {
                        return new DirectiveToken(currency.toString(), start, cur);
                    }
                    else compiler.AddMessage(true, cur, "One or more uppercase letters required for directive");
                }
                else if (cur.isUppercaseLetter()) {
                    StringBuilder ident = new StringBuilder();
                    ident.append(Character.toChars(cur.getCp()));
                    cur = cur.next();
                    while (cur.isLetter() || cur.isDigit() || cur.isDash()) {
                        ident.append(Character.toChars(cur.getCp()));
                        cur = cur.next();
                    }
                    return new IdentToken(compiler.AddName(ident.toString()), start, cur);
                }
                else if (cur.getCp() != -1) {
                    Position posi = new Position(cur.next());
                    posi.pos -= 1;
                    compiler.AddMessage(true, posi, "unexpected character " + cur.text.charAt(cur.index - 1));
                }
            }
            return null;
        }
    }

    static class Compiler {
        SortedMap<Position, Message> messages;
        HashMap<String, Integer> nameCodes;
        ArrayList<String> names;

        public Compiler() {
            messages = new TreeMap<>();
            nameCodes = new HashMap<>();
            names = new ArrayList<>();
        }

        public int AddName(String name) {
            if (nameCodes.containsKey(name)) return nameCodes.get(name);
            else {
                int code = names.size();
                names.add(name);
                nameCodes.put(name, code);
                return code;
            }
        }
        public void OutputNames() {
            System.out.println("\nOutputting identifier names:");
            int i = 0;
            for (String name : names) {
                System.out.println(i + " - " + name.toString());
                i++;
            }
        }

        public void AddMessage(boolean isErr, Position c, String text) {
            messages.put(new Position(c), new Message(isErr, text));
        }
        public void OutputMessages() {
            Map<Position, Message> entries = new HashMap<>(messages);
            for (Map.Entry<Position, Message> entry : entries.entrySet()) {
                Position k = entry.getKey();
                Message v = entry.getValue();
                System.out.print(v.isError ? "Error" : "Warning");
                System.out.println(" " + k + ": " + v.text);
            }
        }

        public LabScanner getScanner(String program) {
            return new LabScanner(program, this);
        }
    }

    public static void main(String[] args) throws FileNotFoundException {
        Scanner scanner = new Scanner(new File("test.txt"));
        StringBuilder data = new StringBuilder();
        int lineNum = 1;
        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            System.out.println("Line №" + lineNum + ": \"" + line.toString() + "\"");
            data.append(line).append("\n");
            lineNum += 1;
        }

        Compiler compiler = new Compiler();
        LabScanner newScanner = compiler.getScanner(data.toString());

        System.out.println("\nTokens:");
        Token tok = newScanner.nextToken();
        while (tok.Tag != DomainTag.END_OF_PROGRAM){
            System.out.println(tok.toString());
            tok = newScanner.nextToken();
        }
        System.out.println();
        compiler.OutputMessages();
        compiler.OutputNames();
    }
}