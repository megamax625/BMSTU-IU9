import java.util.Arrays;
import java.util.function.BinaryOperator;
import java.util.function.UnaryOperator;

public class Main {
    static float eps = 0.001f;
    static float h0 = 0.03125f;
    static float a = 1;
    static float b = 2;
    static UnaryOperator<Float> phi1 = (x) -> (float)(Math.log(x));
    static UnaryOperator<Float> phi2 = (x) -> (float)(Math.log(x) + 1);
    // J(u,v) = phi2(u) - phi1(u) = 1 + ln(x) - ln(x) = 1
    static BinaryOperator<Float> func = (u, v) -> (float)(Math.exp(u + (phi1.apply(u) + v)));

    public static float RungeRule(float I1, float I2) {
        return (float)(Math.abs(I1 - I2) / 3);
    }

    public static void main(String[] args) {
        // Вычисление методом повторного интегрирования
        int n = 2;
        int m = 2;
        float hx = (b - a) / n;
        float hy = (1.0f - 0.0f) / m;
        float[] xs = new float[n+1];
        float[] ys = new float[m+1];
        for (int i = 0; i < n+1; i++) xs[i] = a + i * hx;
        for (int i = 0; i < m+1; i++) ys[i] = i * hy;
        System.out.println("First iteration x-es:" + Arrays.toString(xs));
        System.out.println("First iteration y-s:" + Arrays.toString(ys));

        float[] Fxs = new float[n+1];
        for (int i = 0; i < n + 1; i++) {
            float sum = 0;
            for (int j = 0; j < m + 1; j++) {
                float add = func.apply(xs[i], ys[j]);
                if (j == 0 || j == m) add /= 2;
                sum += add;
            }
            Fxs[i] = hy * sum;
        }

        float I = 0;
        for (int i = 0; i < n + 1; i++) {
            float add = Fxs[i];
            if (i == 0 || i == n) add /= 2;
            I += add;
        }
        I *= hx;

        System.out.println("First iteration I = " + I);
        float NextI = Float.POSITIVE_INFINITY;
        int iter = 2;
        while (RungeRule(I, NextI) > eps) {
            I = NextI;
            n *= 2;
            m *= 2;
            hx = (b - a) / n;
            hy = (1.0f - 0.0f) / m;
            xs = new float[n+1];
            ys = new float[m+1];
            for (int i = 0; i < n+1; i++) xs[i] = a + i * hx;
            for (int i = 0; i < m+1; i++) ys[i] = i * hy;
            Fxs = new float[n+1];
            for (int i = 0; i < n + 1; i++) {
                float sum = 0;
                for (int j = 0; j < m + 1; j++) {
                    float add = func.apply(xs[i], ys[j]);
                    if (j == 0 || j == m) add /= 2;
                    sum += add;
                }
                Fxs[i] = hy * sum;
            }
    
            NextI = 0;
            for (int i = 0; i < n + 1; i++) {
                float add = Fxs[i];
                if (i == 0 || i == n) add /= 2;
                NextI += add;
            }
            NextI *= hx;
            System.out.printf("Iteration №" + iter + ", I = " + NextI + ", error of " + RungeRule(I, NextI) + "\n");
            iter++;
        }

        // Вычисление методом ячеек
        System.out.printf("\nStarting to execute cell method with h0 = %f\n", h0);
        int n0 = (int)((b - a) / h0);
        int m0 = (int)(1.0f / h0);
        float[] xi = new float[n0+1];
        float[] yi = new float[m0+1];
        System.out.printf("n0 = %d, m0 = %d\n", n0, m0);
        for (int i = 0; i < n0+1; i++) xi[i] = a + i * h0;
        for (int i = 0; i < m0+1; i++) yi[i] = i * h0;
        System.out.println("First iteration x-es:" + Arrays.toString(xi));
        System.out.println("First iteration y-s:" + Arrays.toString(yi));
        // Координаты х от 1 до 2, y от 0 до 1
        float i1 = 0;
        for (int i = 0; i < n0; i++) {
            for (int j = 0; j < m0; j++) {
                i1 += func.apply(xi[i] + h0/2, yi[j] + h0/2);
            }
        }
        i1 *= h0 * h0;
        iter = 1;
        System.out.printf("Iteration №%d, double integral value of %f, h = %f\n", iter, i1, h0);
        float i2 = Float.POSITIVE_INFINITY;
        float h = h0;
        while (RungeRule(i1, i2) > eps) {
            h = h/2;
            n0 *= 2;
            m0 *= 2;
            iter++;
            i2 = i1;
            i1 = 0;
            float[] xis = new float[n0+1];
            float[] yis = new float[m0+1];
            System.out.printf("n0 = %d, m0 = %d\n", n0, m0);
            for (int i = 0; i < n0+1; i++) xis[i] = a + i * h;
            for (int i = 0; i < m0+1; i++) yis[i] = i * h;
            for (int i = 0; i < n0; i++) {
                for (int j = 0; j < m0; j++) {
                    i1 += func.apply(xis[i] + h/2, yis[j] + h/2);
                }
            }
            i1 *= h * h;
            System.out.printf("Iteration №%d, double integral value of %f, h = %f, error of %f\n", iter, i1, h, RungeRule(i1, i2));
        }
        // Значение аналитоического решения:
        System.out.println("Analytical solution: " + (Math.exp(1) - 1) * Math.exp(1) * Math.exp(1));
    }
}