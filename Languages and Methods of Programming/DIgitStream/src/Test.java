public class Test {
    public static void main(String[] args) {
        DigitSeq a = new DigitSeq(new int[]{10, 0, 123, 5});
        DigitSeq random = new DigitSeq(new int[]{(int)(Math.random() * 1000), (int)(Math.random() * 1000), (int)(Math.random() * 1000)});
        DigitSeq empty = new DigitSeq(new int[]{});
        DigitSeq neg = new DigitSeq(new int[]{-12, -23});
        System.out.println("Sequence a with separated digits:");
        a.separateDigits().forEach(System.out::println);
        System.out.print("Max sum of digits in sequence a:");
        a.getMaxSum().ifPresent(System.out::println);
        System.out.println("Count of digits in a:" + a.countDigits());
        System.out.println("Sequence random with separated digits:");
        random.separateDigits().forEach(System.out::println);
        System.out.print("Max sum of digits in sequence random:");
        random.getMaxSum().ifPresent(System.out::println);
        System.out.println("Count of digits in random:" + random.countDigits());
        System.out.println("Sequence empty with separated (none) digits:");
        empty.separateDigits().forEach(System.out::println);
        System.out.println("Max sum of digits in sequence empty:");
        empty.getMaxSum().ifPresent(System.out::println);
        System.out.println("Count of digits in empty:" + empty.countDigits());
        System.out.println("Sequence neg with separated digits:");
        neg.separateDigits().forEach(System.out::println);
        System.out.print("Max sum of digits in sequence neg:");
        neg.getMaxSum().ifPresent(System.out::println);
        System.out.println("Count of digits in neg:" + neg.countDigits());
    }
}