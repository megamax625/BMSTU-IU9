import java.io.FileNotFoundException;
import java.io.PrintWriter;
import java.io.UnsupportedEncodingException;
import java.util.Arrays;
import java.util.function.UnaryOperator;
import Jama.Matrix;

// Вариант 12: xi = {1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5}, 
//             yi = {0.31, 0.57, 1.67, 1.40, 1.18, 1.54, 1.55, 1.96, 2.42}

public class Main {
    public static void main(String[] args) throws FileNotFoundException, UnsupportedEncodingException {
        float[] x = new float[] {1.0f, 1.5f, 2.0f, 2.5f, 3.0f, 3.5f, 4.0f, 4.5f, 5.0f};
        float[] y = new float[] {0.31f, 0.57f, 1.67f, 1.40f, 1.18f, 1.54f, 1.55f, 1.96f, 2.42f};
        int n = x.length;
        int m = 4;
        float[] λ = new float[m];
        float[][] a = new float[m][m];
        float[] b = new float[m];

        for (int i = 0; i < m; i++) {
            for (int j = 0; j < m; j++) {
                a[i][j] = 0;
                for (int k = 0; k < n; k++) {
                    a[i][j] += Math.pow(x[k], i+j);
                }
            }
        }
        for (int i = 0; i < m; i++) {
            b[i] = 0;
            for (int k = 0; k < n; k++) {
                b[i] += y[k] * Math.pow(x[k], i);
            }
        }

        System.out.print("A =\t");
        for (int i = 0; i < a.length; i++) {
            for (int j = 0; j < a[i].length; j++) {
                System.out.format("%.6f\t", a[i][j]);
            }
            if (i < a.length - 1) System.out.println();
            System.out.print("\t");
        }


        System.out.print("\nb = (");
        for (int i = 0; i < b.length; i++) {
            System.out.format("%f", b[i]);
            if (i < b.length - 1) System.out.print("\t");
        }
        System.out.println(")");

        Matrix A = new Matrix(m, m);
        Matrix B = new Matrix(m, 1);
        for (int i = 0; i < m; i++) {
            for (int j = 0; j < m; j++) {
                A.set(i, j, a[i][j]);
            }
            B.set(i, 0, b[i]);
        }
        Matrix solution = A.solve(B);
        for (int i = 0; i < m; i++) {
            λ[i] = (float)(solution.get(i, 0));
            System.out.format("λ%d = %f\n", i, λ[i]);
        }

        float sku = 0;
        for (int k = 0; k < n; k++) {
            float sumPart = y[k] - λ[0];
            for (int i = 1; i < m; i++) {
                sumPart -= λ[i] * Math.pow(x[k], i);
            }
            sku += sumPart * sumPart;
        }
        sku = (float)(Math.sqrt(sku));
        float sko = (float)(sku / Math.sqrt(n+1));
        float normY = 0;
        for (int k = 0; k < n; k++) {
            normY += y[k] * y[k];
        }
        normY = (float)(Math.sqrt(normY));
        float relativeError = sko / normY;
        System.out.format("СКО Δ = %f, относительная ошибка δ = %f\n", sko, relativeError);

        UnaryOperator<Float> z = (v) -> (λ[0] + λ[1] * v + λ[2] * v * v + λ[3] * v * v * v);
        for (int i = 0; i < n; i++) System.out.format("x[%d] = %f, y[%d] = %f, z(x[%d]) = %f\n", i, x[i], i, y[i], i, z.apply(x[i]));
        System.out.println();
        float[] middleXs = new float[n - 1];
        float[] middleYs = new float[n - 1];
        for (int i = 0; i < n - 1; i++) {
            middleXs[i] = x[i] + (x[i+1] - x[i]) / 2;
            middleYs[i] = z.apply(middleXs[i]);
            System.out.format("x between x[%d] and x[%d]: %f, z(x) = %f\n", i, i + 1, middleXs[i], middleYs[i]);
        }

        float[] zs = new float[n];
        for (int i = 0; i < n; i++) zs[i] = z.apply(x[i]);
        PrintWriter writer = new PrintWriter("arrays.txt", "UTF-8");
        writer.println("x = np.array(" + Arrays.toString(x) + ")");
        writer.println("y = np.array(" + Arrays.toString(y) + ")");
        writer.println("middleXs = np.array(" + Arrays.toString(middleXs) + ")");
        writer.println("middleYs = np.array(" + Arrays.toString(middleYs) + ")");
        writer.println("zs = np.array(" + Arrays.toString(zs) + ")");
        writer.close();
    }
}