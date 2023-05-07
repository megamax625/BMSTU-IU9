// Решить аналитически задачу Коши y'' + py' + qy = f(x), y(0) = y0, y'(0) = y0'
// p = 0, q = 4, f(x) = e^(-2x), y0 = 0, y0' = 0
// По найденному решению задачи Коши y(x) вычислить b = y(1)
// Найти численное решение (xi, yi), i = 1,n краевой задачи того же ур-я с краевыми условиями y(0) = a, y(1) = b, n = 10
// Найти погрешность решения || y - y~ || =  max|y(xi) - yi~|, 0 <= i <= n

import java.util.function.UnaryOperator;

// 12 Вариант: p = 0, q = 4, f(x) = e^(-2x), y0 = 0, y0' = 0;
// Аналитическое решение задачи y'' + 4y = e^(-2x) с условиями y(0) = 0, y'(0) = 0: 1/8 * (e^(-2x) - cos(2x) + sin(2x))
public class Main {
    static float p = 0.0f;
    static float q = 4.0f;
    static UnaryOperator<Float> func = (x) -> (float)(Math.exp(-2 * x));
    static UnaryOperator<Float> solution = (x) -> (float)((Math.exp(-2 * x) - Math.cos(2 * x) + Math.sin(2 * x)) / 8);
    static UnaryOperator<Float> pFunc = (x) -> 0.0f;
    static UnaryOperator<Float> qFunc = (x) -> 4.0f;

    public static void main(String[] args) {
        float r = 1.0f;
        float l = 0.0f;
        int n = 10;
        float yn = solution.apply(1.0f);
        float h = (r - l) / n;
        System.out.println("yn = y(1) = " + yn + ", h = " + h);

        //Методом прогонки
        System.out.println("Executing Thomas method");
        float[] x = new float[n + 1];
        float[] y = new float[n + 1];
        float[] fi = new float[n + 1];
        float[] pi = new float[n + 1];
        float[] qi = new float[n + 1];
        float[] aDiag = new float[n - 1];
        float[] bDiag = new float[n];
        float[] cDiag = new float[n - 1];
        float[] dDiag = new float[n];

        x[0] = l;
        fi[0] = func.apply(x[0]);
        pi[0] = pFunc.apply(l);
        qi[0] = qFunc.apply(l);
        for (int i = 1; i < n + 1; i++) {
            x[i] = x[0] + i * h;
            fi[i] = func.apply(x[i]);
            pi[i] = pFunc.apply(x[i]);
            qi[i] = qFunc.apply(x[i]);
        }
        y[n] = yn;
        bDiag[0] = 1.0f;
        cDiag[0] = -(1 - pi[0] * h / 2);
        for (int i = 0; i < n - 1; i++) {
            aDiag[i] = 1 - pi[i] * h / 2;
            bDiag[i] = h * h * qi[i] - 2;
            cDiag[i] = 1 + pi[i] * h / 2;
            dDiag[i] = h * h * fi[i];
        }
        bDiag[n - 1] = h * h * qi[n - 1] - 2;
        dDiag[n - 1] = h * h * fi[n - 1] - yn * (1 + pi[n - 1] * h / 2);
        dDiag[0] = h * h * fi[0] - solution.apply(l) * (1 - pi[0] * h / 2);
        findY(aDiag, bDiag, cDiag, dDiag, y);

        float maxError = Float.NEGATIVE_INFINITY;
        float y_wave;
        for (int i = 0; i < x.length; i++) {
            y_wave = solution.apply(x[i]);
            System.out.println("x" + (i+1) + " = " + String.format("%.06f", x[i]) + ", y" + (i+1) + " = " + y[i] + 
                                                    ", y~" + (i+1) + " = " + y_wave + ", diff = " + Math.abs(y[i] - y_wave));
            if (Math.abs(y[i] - y_wave) > maxError) maxError = Math.abs(y[i] - y_wave);
        }
        System.out.println("Error: " + maxError);

        // Методом стрельбы - fi, h, pi, qi сразу возьмём из метода прогонки т.к. разбиение то же и pi с qi константные функции, данные в задании
        System.out.println("\nExecuting shooting method");
        float[] xs = new float[n + 1];
        float[] ys = new float[n + 1];
        float[] y1 = new float[n + 1];
        float[] y2 = new float[n + 1];
        xs[0] = l;
        ys[0] = solution.apply(l);
        y1[0] = solution.apply(l);
        y1[1] = solution.apply(l) + h;
        y2[0] = 0;
        y2[1] = h;

        for (int i = 0; i < n + 1; i++) {
            xs[i] = xs[0] + i * h;
        }
        for (int i = 1; i < n; i++) {
            y1[i + 1] = (h * h * func.apply(xs[i]) + (2 - qi[i] * h * h) * y1[i] - (1 - pi[i] * h / 2) * y1[i - 1]) / (1 + pi[i] * h / 2);
            y2[i + 1] = ((2 - qi[i] * h * h) * y2[i] - (1 - pi[i] * h / 2) * y2[i - 1]) / (1 + pi[i] * h / 2);
        }
        for (int i = 1; i < n + 1; i++) {
            ys[i] = y1[i] + (solution.apply(r) - y1[n]) / y2[n] * y2[i];
        }

        maxError = Float.NEGATIVE_INFINITY;
        for (int i = 0; i < xs.length; i++) {
            y_wave = solution.apply(xs[i]);
            System.out.println("xs" + (i+1) + " = " + String.format("%.06f", xs[i]) + ", y" + (i+1) + " = " + ys[i] + 
                                                    ", y~" + (i+1) + " = " + y_wave + ", diff = " + Math.abs(ys[i] - y_wave));
            if (Math.abs(ys[i] - y_wave) > maxError) maxError = Math.abs(ys[i] - y_wave);
        }
        System.out.println("Error: " + maxError);
    }

    // прямой и обратный ход метода прогонки
    private static void findY(float[] aDiag, float[] bDiag, float[] cDiag, float[] dDiag, float[] y) {
        int n = bDiag.length;
        float[] alpha = new float[n];
        float[] beta = new float[n];

        alpha[0] = -cDiag[0] / bDiag[0];
        beta[0] = dDiag[0] / bDiag[0];
        for (int i = 1; i < bDiag.length; i++) {
            if (i == bDiag.length - 1) alpha[i] = 0.0f;
            else alpha[i] = -cDiag[i] / (aDiag[i - 1] * alpha[i - 1] + bDiag[i]);
            beta[i] = (dDiag[i] - aDiag[i - 1] * beta[i - 1]) / (aDiag[i - 1] * alpha[i - 1] + bDiag[i]);
        }

        y[n - 1] = beta[n - 1];
        for (int i = n - 2; i >= 0; i--) {
            y[i] = alpha[i] * y[i + 1] + beta[i];
        }
    }
}