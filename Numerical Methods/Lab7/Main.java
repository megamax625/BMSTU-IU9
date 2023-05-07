import java.util.Arrays;

// alpha = 0.1 * k, beta = 0.1 * k, где k - номер варианта, Вар 12 => alpha = 1.2, beta = 1.2
// A = (11.2 -1.0 0.2 2.0
//      1.0 10.8 -2.0 0.1
//      0.3 -4.0 10.8 1.0
//      0.2 -0.3 -0.5 4.8)
// b = (2.2 0.8 3.0 1.0)

public class Main {

    public static void main(String[] args) {
        float eps = 0.01f;
        float[][] A = new float[][]{{11.2f, -1.0f, 0.2f, 2.0f},
                                    {1.0f, 10.8f, -2.0f, 0.1f},
                                    {0.3f, -4.0f, 10.8f, 1.0f},
                                    {0.2f, -0.3f, -0.5f, 4.8f}};
        float[] b = new float[]{2.2f, 0.8f, 3.0f, 1.0f};
        int n = b.length;
        float[] x = new float[n];
        float[] x_next = new float[n];
        
        // первое приближение - c
        System.out.println("Метод простой итерации:");
        for (int i = 0; i < n; i++) {
            x[i] = b[i] / A[i][i];
        }
        System.out.println("Начальное приближение c: " + Arrays.toString(x));
        float δ = Float.MAX_VALUE;
        float Δ = Float.MAX_VALUE;
        int iter = 0;
        while (δ > eps) {
            iter++;
            x_next[0] = (b[0] - (A[0][1] * x[1] + A[0][2] * x[2] + A[0][3] * x[3])) / A[0][0];
            x_next[1] = (b[1] - (A[1][0] * x[0] + A[1][2] * x[2] + A[1][3] * x[3])) / A[1][1];
            x_next[2] = (b[2] - (A[2][0] * x[0] + A[2][1] * x[1] + A[2][3] * x[3])) / A[2][2];
            x_next[3] = (b[3] - (A[3][0] * x[0] + A[3][1] * x[1] + A[3][2] * x[2])) / A[3][3];

            float xk = x[0];
            float xk_next = x_next[0];
            for (int i = 1; i < n; i++) {
                if (Math.abs(x_next[i] - x[i]) > Math.abs(xk_next - xk)) {
                    xk = x[i];
                    xk_next = x_next[i];
                }
                x[i] = x_next[i];
            }
            x[0] = x_next[0];
            if (Δ > Math.abs(xk_next - xk)) Δ = Math.abs(xk_next - xk);
            if (δ > (Δ / Math.abs(xk))) δ = Δ / Math.abs(xk);

            System.out.println("iteration №" + iter + ": x = " + Arrays.toString(x) + ", Δ = " + Δ + ", δ = " + δ);
        }

        // Метод Зейделя
        System.out.println("Метод Зейделя:");
        x = new float[n];
        x_next = new float[n];
        
        // первое приближение - c
        for (int i = 0; i < n; i++) {
            x[i] = b[i] / A[i][i];
        }
        System.out.println("Начальное приближение c: " + Arrays.toString(x));
        δ = Float.MAX_VALUE;
        Δ = Float.MAX_VALUE;
        iter = 0;
        while (Δ > 0.0001) {
            iter++;
            x_next[0] = (b[0] - (A[0][1] * x[1] + A[0][2] * x[2] + A[0][3] * x[3])) / A[0][0];
            x_next[1] = (b[1] - (A[1][0] * x_next[0] + A[1][2] * x[2] + A[1][3] * x[3])) / A[1][1];
            x_next[2] = (b[2] - (A[2][0] * x_next[0] + A[2][1] * x_next[1] + A[2][3] * x[3])) / A[2][2];
            x_next[3] = (b[3] - (A[3][0] * x_next[0] + A[3][1] * x_next[1] + A[3][2] * x_next[2])) / A[3][3];

            float xk = x[0];
            float xk_next = x_next[0];
            for (int i = 1; i < n; i++) {
                if (Math.abs(x_next[i] - x[i]) > Math.abs(xk - xk_next)) {
                    xk = x[i];
                    xk_next = x_next[i];
                }
                x[i] = x_next[i];
            }
            x[0] = x_next[0];
            if (Δ > Math.abs(xk_next - xk)) Δ = Math.abs(xk_next - xk);
            if (δ > (Δ / Math.abs(xk))) δ = Δ / Math.abs(xk);

            System.out.println("iteration №" + iter + ": x = " + Arrays.toString(x) + ", Δ = " + Δ + ", δ = " + δ);
        }
    }
}