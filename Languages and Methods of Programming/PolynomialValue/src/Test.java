import java.util.Arrays;

public class Test {
    public static void main(String[] args){
        int[] a1 = {1, 1};
        int[] a2 = {2, 1};
        int[][] a = {a1, a2};
        int[] b1 = {1, 0};
        int[] b2 = {2, 4};
        int[][] b = {b1, b2};
        int[] c1 = {5, -1};
        int[] c2 = {0, 5};
        int[][] c = {c1, c2};
        int[] d1 = {7, 1};
        int[] d2 = {(int)(Math.random() * 10), (int)(Math.random() * 10)};
        int[][] d = {d1, d2};
        Polynomial[] arr = new Polynomial[]{
                new Polynomial(1, a),
                new Polynomial(2, b),
                new Polynomial(1, c),
                new Polynomial((int) (Math.random() * 10), d)};
        Arrays.sort(arr);
        for (int i = 0; i < 4; i++){
            System.out.println(i + ") " + arr[i] + " with the value of " + arr[i].calcValue() + " with an argument of " + (arr[i].getArg()));
        }
    }
}
