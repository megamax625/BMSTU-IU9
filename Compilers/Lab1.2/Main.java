import java.io.File;
import java.io.FileNotFoundException;
import java.util.ArrayList;
import java.util.Scanner;
import java.util.regex.Pattern;
import java.util.regex.Matcher;

public class Main {
    static class Lexem {
        final Tag tag;
        final int line;
        final int pos;
        final String data;

        public Lexem(Tag tag, int line, int pos, String data) {
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
        // Идентификаторы: последовательности буквенных символов Unicode и цифр, начинающиеся с буквы, не чувствительны к регистру.
        // Целочисленные константы: десятичные — последовательности десятичных цифр,
        // шестнадцатеричные — последовательности шестнадцатиричных цифр, начинающиеся на «&H», тоже не чувствительны к регистру.
        // Ключевые слова — «PRINT», «GOTO», «GOSUB» без учёта регистра.
        IDENTIFIER,
        INTEGER_CONSTANT,
        HEXADECIMAL_CONSTANT,
        KEYWORD,
        SYNTAX_ERROR;
    }

    public static ArrayList<Lexem> readFile(String name) throws FileNotFoundException {
        StringBuilder dataStrB = new StringBuilder();
        Scanner scanner = new Scanner(new File(name));
        ArrayList<Lexem> res = new ArrayList<>();
        int lineNum = 1;

        while (scanner.hasNextLine()) {
            String line = scanner.nextLine();
            dataStrB.append(line).append("\n");
            System.out.println("line №" + lineNum + ": \"" + line + "\"");
            lineNum++;
        }
        System.out.println();
        dataStrB.append("✔");
        String data = dataStrB.toString();
        int line = 1;
        int pos = 1;
        
        // Регулярные выражения
        // Идентификаторы: последовательности буквенных символов Unicode и цифр, начинающиеся с буквы, не чувствительны к регистру.
        // Целочисленные константы: десятичные — последовательности десятичных цифр,
        // шестнадцатеричные — последовательности шестнадцатиричных цифр, начинающиеся на «&H», тоже не чувствительны к регистру.
        // Ключевые слова — «PRINT», «GOTO», «GOSUB» без учёта регистра.
        String IDENTIFIER_EXPR = "\\p{L}[\\p{L}0-9]*";
        String INTEGER_CONSTANT_EXPR = "[0-9]+";                 // можно ещё "\\p{Digit}+"
        String HEXADECIMAL_CONSTANT_EXPR = "&H[0-9A-Fa-f]+";     // можно ещё "&H\\p{XDigit}+""
        String KEYWORD_EXPR = "((?i)(print)|(?i)(goto)|(?i)(gosub))";
        String WHITESPACE = "([ \t\r])";
        String NEWLINE = "\n";
        
        // Компиляция регулярного выражения
        String pattern = "(?<int>^" + INTEGER_CONSTANT_EXPR + ")|(?<hex>^" + HEXADECIMAL_CONSTANT_EXPR + ")|(?<keyword>^" + KEYWORD_EXPR 
        + ")|(?<ident>^" + IDENTIFIER_EXPR + ")|(?<whitespace>^" + WHITESPACE + ")|(?<newline>^" + NEWLINE + ")";
        Pattern p = Pattern.compile(pattern);
        
        boolean error_encountered = false;
        while (!data.toString().equals("✔")) {
            // System.out.println(data);
            Matcher m = p.matcher(data.toString());
            if (m.find(0)) {
                error_encountered = false;
                if (m.group("int") != null) {
                    String text = m.group("int");
                    // System.out.println("\ngot int\n");
                    res.add(new Lexem(Tag.INTEGER_CONSTANT, line, pos, text));
                    pos += text.length();
                }
                else if (m.group("hex") != null) {
                    String text = m.group("hex");
                    // System.out.println("\ngot hex\n");
                    res.add(new Lexem(Tag.HEXADECIMAL_CONSTANT, line, pos, text));
                    pos += text.length();
                }
                else if (m.group("keyword") != null) {
                    String text = m.group("keyword");
                    // System.out.println("\ngot keyword\n");
                    res.add(new Lexem(Tag.KEYWORD, line, pos, text));
                    pos += text.length();
                }
                else if (m.group("ident") != null) {
                    String text = m.group("ident");
                    // System.out.println("\ngot ident\n");
                    res.add(new Lexem(Tag.IDENTIFIER, line, pos, text));
                    pos += text.length();
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
                    res.add(new Lexem(Tag.SYNTAX_ERROR, line, pos, ""));
                    error_encountered = true;
                }
                pos++;
                data = data.substring(1);
            }
        }
        return res;
    }

    public static void main(String[] args) throws FileNotFoundException {
        ArrayList<Lexem> lexems = readFile("./test.txt");
        lexems.forEach(System.out::println);
    }
}
