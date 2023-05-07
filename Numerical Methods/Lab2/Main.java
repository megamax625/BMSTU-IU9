import java.util.function.UnaryOperator;

public class Main {
    static float eps = 0.0001f;
    static float a = 0;
    static float b = 1;
    static float a2 = -1;
    static float b2 = 2;

    public static void main(String[] args) {
        System.out.println("Checking rectangle method");
        methodCalc("rect", a, b, "func");
        System.out.println("Checking trapezoid method");
        methodCalc("trap", a, b, "func");
        System.out.println("Checking Simpson method");
        methodCalc("simp", a, b, "func");
        System.out.println("\n\nStarting calculations for variant function");
        System.out.println("Checking rectangle method");
        methodCalc("rect", a2, b2, "func2");
        System.out.println("Checking trapezoid method");
        methodCalc("trap", a2, b2, "func2");
        System.out.println("Checking Simpson method");
        methodCalc("simp", a2, b2, "func2");
    }

    private static float RungeRule(float I1, float I2, int p) {
        return (float)((I1 - I2) / (Math.pow(2, p) - 1));
    }

    @FunctionalInterface
    public interface Method {
        float method(int n, float a, float b, UnaryOperator<Float> function);
    }

    private static void methodCalc(String type, float a, float b, String function) {
        UnaryOperator<Float> func;
        if (function.equals("func")) func = (x) -> (float)(Math.exp((double)(x)));
        else func = (x) -> (float)(4 * Math.pow(x, 3) / (Math.pow(x, 8) + 1));
        int n = 1;
        int p = 0;
        Method method = null;
        switch (type) {
            case "rect" -> {
                method = Main::executeRect;
                p = 2;
            }
            case "trap" -> {
                method = Main::executeTrap;
                p = 2;
            }
            case "simp" -> {
                method = Main::executeSimp;
                p = 4;
            }
            default -> {
                System.out.println("Incorrect method type");
                System.exit(1);
            }
        }
        float h = (b - a) / n;
        float I1 = method.method(n, a, b, func);
        float I2 = method.method(n * 2, a, b, func);
        float delta = RungeRule(I1, I2, p);
        int iter = 1;
        while (Math.abs(delta) > eps) {
            n *= 2;
            I1 = I2;
            I2 = method.method(n * 2, a, b, func);
            delta = RungeRule(I1, I2, p);
            iter++;
        }
        System.out.println("Iterations needed: " + iter);
        System.out.println("I* value: " + I2 + ", delta: " + delta);
        System.out.println("Precise I value: " + (I2 - delta));
    }

    private static float executeRect(int n, float a, float b, UnaryOperator<Float> function) {
        float h = (b - a) / n;
        float sum = 0;
        for (int i = 1; i < n + 1; i++) {
            sum += function.apply((float)(a + h * (i - 0.5)));
        }
        return h * sum;
    }

    private static float executeTrap(int n, float a, float b, UnaryOperator<Float> function) {
        float h = (b - a) / n;
        float sum = 0;
        for (int i = 1; i < n; i++) {
            sum += function.apply(a + h * i);
        }
        return h * (sum + (function.apply(a) + function.apply(b)) / 2);
    }

    private static float executeSimp(int n, float a, float b, UnaryOperator<Float> function) {
        float h = (b - a) / n;
        float sum = 0;
        for (int i = 1; i < n + 1; i++) {
            sum += function.apply(a + h * (i - 1)) + 4 * function.apply((float)(a + h * (i - 0.5))) + function.apply(a + h * i);
        }
        return (h/6) * sum;
    }
}
