import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class DigitSeq {
    private final int[] seq;
    private IntStream digitStream;
    public DigitSeq(int[] arr) {
        seq = arr.clone();
        digitStream = Arrays.stream(seq);
    }
    public IntStream getStream(){
        return digitStream;
    }
    public IntStream separateDigits(){
        return digitStream.flatMap(this::numberSeparate);
    }
    private IntStream numberSeparate(int x) {
        //int[] newStreamArr = IntStream.iterate(x, i -> Math.abs(i) > 0, i -> i / 10).map(i -> Math.abs(i % 10)).toArray();
        //int[] reverseStreamArr = IntStream.iterate(newStreamArr.length - 1, i -> i >= 0, i -> i - 1).map(i -> newStreamArr[i]).toArray(); // этот способ не считывает число 0
        int[] reverseStreamArr = String.valueOf(x).chars().map(Character::getNumericValue).toArray();
        return IntStream.of(reverseStreamArr).filter(i -> i >= 0); // у отрицательного числа в начале потока -1
    }
    public OptionalInt getMaxSum(){
        IntStream sumStream = IntStream.empty();
        digitStream = Arrays.stream(seq);
        if (digitStream.count() > 0) {
            digitStream = Arrays.stream(seq);
            sumStream = digitStream.map(i -> numberSeparate(i).reduce(0, (left, right) -> (left + right)));
        }
        return sumStream.reduce(Integer::max);
    }
    public Map<Integer, Long> countDigits(){
        digitStream = Arrays.stream(seq);
        IntStream digitsCountStream = separateDigits();
        Map<Integer , Long> digitsMap = digitsCountStream.boxed().collect(Collectors.groupingBy(i -> i, Collectors.counting()));
        return digitsMap;
    }
}