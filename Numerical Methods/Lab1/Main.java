import java.util.Arrays;

import Jama.Matrix;

public class Main {
    public static void main(String[] args) {
        float[] b = {4.0f, 4.0f, 4.0f, 4.0f};
        float[] a = {1.0f, 1.0f, 1.0f};
        float[] c = {1.0f, 1.0f, 1.0f};
        float[] d = {5.0f, 6.0f, 6.0f, 5.0f};
        float[] alpha = new float[b.length];
        float[] beta = new float[b.length];
        float[] x = new float[b.length];

        checkForDiagonalDominance(a, b, c);
        forward(a, b, c, d, alpha, beta);
        System.out.println(Arrays.toString(alpha));
        System.out.println(Arrays.toString(beta));
        back(x, alpha, beta);
        System.out.println("x = (");
        for (float f : x) {
            System.out.format("%.16f\n",f);
        }
        System.out.println(")");
        float[] newD = new float[d.length];
        newD[0] = (b[0] * x[0] + c[0] * x[1]);
        int n = b.length;
        for (int i = 1; i < n - 1; i++) {
            newD[i] = (a[i] * x[i - 1] + b[i] * x[i] + c[i] * x[i + 1]);
        }
        newD[n - 1] = (a[n - 2] * x[n - 2] + b[n - 1] * x[n - 1]);
        System.out.println("d* = " + Arrays.toString(newD));
        float[] error = getCalcError(a, b, c, d, newD);
        System.out.println("error = (");
        for (float e : error) {
            System.out.format("%.16f\n", e);
        }
        System.out.println(")");
    }

    private static void checkForDiagonalDominance(float[] a, float[] b, float[] c) {
        for (int i = 1; i < b.length - 2; i++) {
            if (b[i] < Math.abs(a[i]) + Math.abs(c[i])) {
                System.out.println("Не выполняется условие диагонального преобладания");
            }
        }
        if (b[b.length - 1] < a[a.length - 1]) {
            System.out.println("Не выполняется условие диагонального преобладания");
        }
    }

    private static void forward(float[] a, float[] b, float[] c, float[] d, float[] alpha, float[] beta) {
        alpha[0] = -c[0] / b[0];
        beta[0] = d[0] / b[0];
        for (int i = 1; i < b.length; i++) {
            if (i == b.length - 1) {
                alpha[i] = 0.0f;
                beta[i] = (d[i] - a[i - 1] * beta[i - 1]) / (a[i - 1] * alpha[i - 1] + b[i]);
            } else {
                float frac = (float)(1.0 / (a[i - 1] * alpha[i - 1] + b[i]));
                alpha[i] = -c[i] * frac;
                beta[i] = (d[i] - a[i - 1] * beta[i - 1]) * frac;
            }
        }
    }
    private static void back(float[] x, float[] alpha, float[] beta) {
        int n = beta.length;
        x[n-1] = beta[n-1];
        for (int i = n - 2; i >= 0; i--) {
            x[i] = alpha[i] * x[i+1] + beta[i];
        }
    }

    private static float[] getCalcError(float[] a, float[] b, float[] c, float[] d, float[] newD) {
        int n = b.length;
        Matrix A = new Matrix(n, n); // матрица из нулей размера n * n
        for (int i = 0; i < n; i++) {
            A.set(i, i, b[i]);
        }
        for (int i = 0; i < n - 1; i++) {
            A.set(i + 1, i, a[i]);
            A.set(i, i + 1, c[i]);
        }
        //A.print(4, 4);
        A = A.inverse(); // обратная матрица
        //A.print(4, 4);
        float[] r = d.clone();
        for (int i = 0; i < n; i++) {
            r[i] -= newD[i];
        }
        System.out.println("r: " + Arrays.toString(r));
        float[] e = new float[n];
        for (int i = 0; i < n; i++) {
            e[i] = 0.0f;
            for (int j = 0; j < n; j++) {
                e[i] += A.get(i, j) * r[j];
            }
        }
        return e;
    }
}