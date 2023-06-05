public class Main {
    public static void main(String[] args) {
        System.out.println("Starting Gauss method for variant test problem");
        float[][] A = new float[][]{{3.2f, 1.0f, -0.1f, 1.0f},
                                    {0.4f, -0.7f, 4.0f, -8.5f},
                                    {0.3f, -1.0f, 3.4f, 5.2f},
                                    {1.0f, 0.2f, 2.5f, 0.2f}};
        float[] b = new float[]{1.5f, 21.9f, -2.7f, 9.9f};
        int n = b.length;
        float[] x = new float[n];
        
        for (int k = 0; k < n; k++) {
            // Поиск строки maxline с главным элементом
            int maxline = k;
            for (int i = k + 1; i < n; i++) {
                if (Math.abs(A[i][k]) > Math.abs(A[maxline][k])) {
                    maxline = i;
                }
            }
            // Перестановки a[k][j] <-> a[maxline][j], j = k,...,n; b[k] <-> b[maxline]
            for (int j = k; j < n; j++) {
                float temp = A[maxline][j];
                A[maxline][j] = A[k][j];
                A[k][j] = temp;
            }
            float temp = b[maxline];
            b[maxline] = b[k];
            b[k] = temp;
            // Исключение x[k] из строк системы с k+1-й по n-ю
            for (int i = k + 1; i < n; i++) {
                float div = A[i][k] / A[k][k];
                for (int j = k; j < n; j++) {
                    A[i][j] = A[i][j] - div * A[k][j];
                }
                b[i] = b[i] - div * b[k];
            }
        }
        // Обратный ход метода Гаусса
        x[n - 1] = b[n - 1] / A[n - 1][n - 1];
        for (int i = n - 2; i >= 0; i--) {
            float sum = 0.0f;
            for (int j = i + 1; j < n; j++) {
                sum += A[i][j] * x[j];
            }
            x[i] = (b[i] - sum) / A[i][i];
        }
        // Вывод результата и аналитического решения
        System.out.print("x = [");
        for (int i = 0; i < n; i++) {
            System.out.printf("%.10f\t", x[i]);
        }
        System.out.println("]");
        System.out.print("Analytical x = [");
        float[] analyt_x = new float[n];
        analyt_x[0] = (float)(-5795) / (float)(3651);
        analyt_x[1] = (float)(30773) / (float)(3651);
        analyt_x[2] = (float)(34385) / (float)(8519);
        analyt_x[3] = (float)(-36952) / (float)(25557);
        System.out.printf("%.10f\t", analyt_x[0]);
        System.out.printf("%.10f\t", analyt_x[1]);
        System.out.printf("%.10f\t", analyt_x[2]);
        System.out.printf("%.10f\t", analyt_x[3]);
        System.out.println("]");
        // Вывод невязки и относительной невязки
        float Δ = Float.NEGATIVE_INFINITY;
        for (int i = 0; i < n; i++) {
            float sum = 0.0f;
            for (int j = 0; j < n; j++) {
                sum += A[i][j] * x[j];
            }
            float v = Math.abs(b[i] - sum);
            if (v > Δ) Δ = v;
        }
        System.out.printf("Δ = %.10f\n", Δ);
        float δ = Float.NEGATIVE_INFINITY;
        float max_x = Float.NEGATIVE_INFINITY;
        for (int i = 0; i < n; i++) {
            if (Math.abs(x[i]) > max_x) max_x = Math.abs(x[i]);
        }
        δ = Δ / max_x;
        System.out.printf("δ = %.10f\n", δ);
    }
}