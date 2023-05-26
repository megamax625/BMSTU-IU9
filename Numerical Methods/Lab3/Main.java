import java.util.Arrays;
import java.util.function.UnaryOperator;

public class Main {
    static float x0 = 0;
    static float xn = 1;
    static float x0_2 = -1;
    static float xn_2 = 2;
    static UnaryOperator<Float> func = (x) -> (float)(Math.exp((double)(x)));
    static UnaryOperator<Float> func2 = (x) -> (float)(4 * Math.pow(x, 3) / (Math.pow(x, 8) + 1));
    static int n = 16;

    public static void main(String[] args) {
        System.out.println("Starting interpolation for exp");
        calcSpline(x0, xn, n, func);
        System.out.println("\nStarting interpolation for variant function");
        calcSpline(x0_2, xn_2, n, func2);
        System.out.println("Done");
    }

    public static void calcSpline(float x0, float xn, int n, UnaryOperator<Float> func) {
        float h = (xn - x0) / n;
        float[] x = new float[n + 1];
        float[] y = new float[n + 1];
        for (int i = 0; i < n + 1; i++) {
            x[i] = x0 + i * h;
            y[i] = func.apply(x[i]);
        }

        float[] c = findCoeffsC(n, h, y);
        c[0] = 0.0f;
        c[n] = 0.0f;
        float[] a = new float[n];
        float[] b = new float[n];
        float[] d = new float[n];
        findOtherCoeffs(a, b, d, y, c, h, n);

        System.out.println("a: " + Arrays.toString(a));
        System.out.println("b: " + Arrays.toString(b));
        System.out.println("c: " + Arrays.toString(c));
        System.out.println("d: " + Arrays.toString(d));

        for (int i = 0; i < 2 * x.length - 1; i++) {
            float xi = x0 + h * i/2;
            float yi = func.apply(xi);
            int ind = i / 2;
            if (ind >= n - 1) ind = n - 1;
            float spline = (float) (a[ind] + b[ind] * (xi - x[ind]) + c[ind] * Math.pow((xi - x[ind]), 2) + d[ind] * Math.pow((xi - x[ind]), 3));
            System.out.printf("x:%f\t y:%.16f\t spline value:%.16f\t diff:%.16f\t err:%16f\n", xi, yi, spline, yi - spline, Math.abs((yi-spline)/yi));
        }
    }

    private static float[] findCoeffsC(int n, float h, float[] y) {
        float[] a = new float[n];
        float[] b = new float[n];
        float[] c = new float[n];
        float[] d = new float[n];
        float[] alpha = new float[n];
        float[] beta = new float[n];
        float[] coeffs = new float[n + 1];

        float mul = 3 / (h * h);

        for (int i = 0; i < n; i++) {
            a[i] = 1.0f;
            c[i] = 1.0f;
            b[i] = 4.0f;
        }
        a[0] = 0.0f;
        c[n-1] = 0.0f;
        d[0] = mul * (y[2] - 2 * y[1] + y[0]);
        for (int i = 1; i < n - 1; i++) {
            d[i] = mul * (y[i + 1] - 2 * y[i] + y[i - 1]);
        }
        b[n - 1] = 4.0f;
        d[n - 1] = mul * (y[n] - 2 * y[n - 1] + y[n - 2]);

        alpha[0] = -c[0] / b[0];
        beta[0] = d[0] / b[0];
        for (int i = 1; i < b.length; i++) {
            if (i == b.length - 1) alpha[i] = 0.0f;
            else alpha[i] = -c[i] / (a[i - 1] * alpha[i - 1] + b[i]);
            beta[i] = (d[i] - a[i - 1] * beta[i - 1]) / (a[i - 1] * alpha[i - 1] + b[i]);
        }

        coeffs[n - 1] = beta[n-1];
        for (int i = n - 2; i >= 0; i--) {
            coeffs[i] = alpha[i] * coeffs[i + 1] + beta[i];
        }
        return coeffs;
    }

    private static void findOtherCoeffs(float[] a, float[] b, float[] d, float[] y, float[] c, float h, int n) {
        float mul1 = h / 3;
        float mul2 = 1.0f / (3 * h);
        for (int i = 1; i < n + 1; i++) {
            a[i - 1] = y[i-1];
            b[i - 1] = (y[i] - y[i-1]) / h - (mul1 * (c[i] + 2 * c[i - 1]));
            d[i - 1] = (c[i] - c[i - 1]) * mul2;
        }
    }
}
