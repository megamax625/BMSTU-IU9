import java.util.Arrays;

public class Test {
    public static void main(String[] args){
        DigitNumber[] array = new DigitNumber[11];
        array[0] = new DigitNumber(0);
        array[1] = new DigitNumber(1);
        array[2] = new DigitNumber(11);
        array[3] = new DigitNumber(12);
        array[4] = new DigitNumber(123);
        array[5] = new DigitNumber(97543);
        array[6] = new DigitNumber(1234567890);
        array[7] = new DigitNumber(-1);
        array[8] = new DigitNumber(-12);
        array[9] = new DigitNumber(123401234);
        array[10] = new DigitNumber((int)(Math.random() * 10000));
        Arrays.sort(array);
        System.out.println("Sorted array:");
        for (int i = 0; i < 11; i++){
            System.out.println(i + ") " +  array[i] + " with " + array[i].differentDigitCalc() + " different digits");;
        }
    }
}