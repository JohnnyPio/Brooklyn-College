import java.util.*;
import java.util.function.Function;

public class GradientDescentSimple {

    public static final double ALPHA = 0.01;
    public static final int REVS = 1000;

    public static Function<List<Double>, Function<List<Double>, List<Double>>> line = 
        xs -> theta -> {
            List<Double> line_out = new ArrayList<>();
            for (double x : xs) {
                double y = theta.get(0) * x + theta.get(1);
                line_out.add(y);
            }
            return line_out;
        };

    public static Function<List<Double>, Function<List<Double>, List<Double>>> quad =
        ts -> theta -> {
            List<Double> quad_out = new ArrayList<>();
            for (double t : ts) {
                double y = theta.get(0) * (t * t) + theta.get(1) * t + theta.get(2);
                quad_out.add(y);
            }
            return quad_out;
        };
        
    public static void main(String[] args) {
        List<Double> xs_line = Arrays.asList(2.0, 1.0, 4.0, 3.0);
        List<Double> theta_line = Arrays.asList(0.0, 0.0);

        List<Double> line_result = line.apply(xs_line).apply(theta_line);
        System.out.println("Line Predictions: " + line_result);

        List<Double> ts_quad = Arrays.asList(3.0);
        List<Double> theta_quad = Arrays.asList(4.5, 2.1, 7.8);

        List<Double> quad_result = quad.apply(ts_quad).apply(theta_quad);
        System.out.println("Quad Predictions: " + quad_result);
    }
}

    // // L2 loss function
    // public static double computeLoss(List<Double> ys, List<Double> predicted) {
    //     double sum = 0;
    //     for (int i = 0; i < ys.size(); i++) {
    //         double error = ys.get(i) - predicted.get(i);
    //         sum += error * error;
    //     }
    //     return sum;
    // }

    // // Numerical gradient calculation
    // public static List<Double> computeGradient(List<Double> xs, List<Double> ys, List<Double> theta) {
    //     double delta = 1e-5;
    //     List<Double> gradient = new ArrayList<>();

    //     for (int i = 0; i < theta.size(); i++) {
    //         List<Double> thetaUp = new ArrayList<>(theta);
    //         List<Double> thetaDown = new ArrayList<>(theta);
    //         thetaUp.set(i, thetaUp.get(i) + delta);
    //         thetaDown.set(i, thetaDown.get(i) - delta);

    //         double lossUp = computeLoss(ys, predictLine(xs, thetaUp));
    //         double lossDown = computeLoss(ys, predictLine(xs, thetaDown));
    //         double grad = (lossUp - lossDown) / (2 * delta);
    //         gradient.add(grad);
    //     }
    //     return gradient;
    // }

    // // Gradient descent
    // public static List<Double> gradientDescent(List<Double> xs, List<Double> ys, List<Double> initTheta) {
    //     List<Double> theta = new ArrayList<>(initTheta);

    //     for (int step = 0; step < REVS; step++) {
    //         List<Double> gradient = computeGradient(xs, ys, theta);
    //         for (int i = 0; i < theta.size(); i++) {
    //             double newVal = theta.get(i) - ALPHA * gradient.get(i);
    //             theta.set(i, newVal);
    //         }
    //     }

    //     return theta;
    // }
