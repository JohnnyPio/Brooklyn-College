# John Piotrowski - 7410X - Final Project
# implement a generic gradient descent function in any other programming language that you can pass in a line, curve, and plane. That can take dataset and any equation and find best fit theta. And it should take hyper parametsr ir ha e some felxible method for sealing with hyperparams

# Increase recursion limit to be greater than python's default 1000 limit :)
import sys
sys.setrecursionlimit(2000)

# Line
xs = [2.0, 1.0, 4.0, 3.0]
ys = [1.8, 1.2, 4.2, 3.3]
theta_line = [0.0, 0.0]

# Final Quad
quad_xs = [-1.0, 0.0, 1.0, 2.0, 3.0]
quad_ys = [2.55, 2.1, 4.35, 10.2, 18.25]
theta_quad = [0.0, 0.0, 0.0]

# Plane
plane_xs = [[1.0, 2.05],[1.0, 3.0],[2.0, 2.0],[2.0, 3.91],[3.0, 6.13],[4.0, 8.09]]
plane_ys = [13.99, 15.99, 18.0, 22.4, 30.2, 37.94]
theta_plane = [[0.0, 0.0], 0.0]

line = lambda xs: \
    lambda theta: \
        [theta[0] * x + theta[1] for x in xs]

quad = lambda ts: \
    lambda theta: \
        [theta[0] * t**2 + theta[1] * t + theta[2] for t in ts]

def our_dot(w, t):
    result = 0
    for i in range(len(w)):
        result += w[i] * t[i]
    return result

plane = lambda ts: \
    lambda theta: \
        [(our_dot(theta[0],t)) + theta[1] for t in ts]

# Early Quad
t = [3.0]
theta_quad_early = [4.5, 2.1, 7.8]

# Dot Testing
dot_1 = [2.0, 1.0, 7.0]
dot_2 = [8.0, 4.0, 3.0]

# print(line(xs)(theta_line))
# print(quad(t)(theta_quad_early))
# print(our_dot(dot_1, dot_2))

l2_loss = \
    lambda target: \
        lambda xs, ys: \
            lambda theta: (
                # pred_ys = target(xs)(theta)
                sum((ys[i] - target(xs)(theta)[i]) ** 2
                for i in range(min(len(ys), len(target(xs)(theta))))
))

print(f"l2-loss is {(l2_loss(line)(xs,ys)(theta_line))}")

def revise(f, revs, theta):
    if revs == 0:
        return theta
    else:
        return revise(f, revs - 1, f(theta))

# Best ChatGPT translation of the gradient-of function from malt
def gradient_of(f, theta, eps=1e-6):
    if isinstance(theta, list) and any(isinstance(x, list) for x in theta):
        # Handle nested parameters (like for plane)
        grad = []
        # Handle the nested list part
        for i in range(len(theta[0])):
            theta_plus = [theta[0][:], theta[1]]  # Create a copy
            theta_minus = [theta[0][:], theta[1]]  # Create a copy
            theta_plus[0][i] += eps
            theta_minus[0][i] -= eps
            grad_i = (f(theta_plus) - f(theta_minus)) / (2 * eps)
            grad.append(grad_i)
        # Handle the bias term
        theta_plus = [theta[0][:], theta[1] + eps]
        theta_minus = [theta[0][:], theta[1] - eps]
        grad_bias = (f(theta_plus) - f(theta_minus)) / (2 * eps)
        return [grad, grad_bias]
    else:
        # Original implementation for flat parameters
        return [
            (f([theta[j] + eps if j == i else theta[j] for j in range(len(theta))]) -
             f([theta[j] - eps if j == i else theta[j] for j in range(len(theta))])) / (2 * eps)
            for i in range(len(theta))
        ]

# def gradient_descent(obj, theta, alpha, revs):
#     def f(big_theta):
#         grad = gradient_of(lambda bt: obj(bt), big_theta)
#         return [param - alpha * g for param, g in zip(big_theta, grad)]
#     return revise(f, revs, theta)

# gradient_descent = \
#     lambda obj, theta, alpha, revs: (
#         revise(
#         lambda big_theta: [
#             param - (alpha * g)
#             for param, g in zip(
#                 big_theta,
#                 gradient_of(lambda b_t: obj(b_t), big_theta)
#         )
#     ],
#     revs,
#     theta
# ))

def gradient_descent(obj, theta, alpha, revs):
    def f(big_theta):
        grad = gradient_of(lambda b_t: obj(b_t), big_theta)
        if isinstance(big_theta, list) and any(isinstance(x, list) for x in big_theta):
            # Handle nested parameters (like for plane)
            new_weights = [[w - alpha * g for w, g in zip(big_theta[0], grad[0])],
                         big_theta[1] - alpha * grad[1]]
            return new_weights
        else:
            # Handle flat parameters
            return [param - alpha * g for param, g in zip(big_theta, grad)]
    return revise(f, revs, theta)


line_grad_descent = gradient_descent(l2_loss(line)(xs,ys), theta_line, 0.01, 1000)

print(f"gradient descent is {line_grad_descent}")

quad_grad_descent = gradient_descent(l2_loss(quad)(quad_xs,quad_ys), theta_quad, 0.001, 1000)

print(f"gradient descent is {quad_grad_descent}")

plane_grad_descent = gradient_descent(l2_loss(plane)(plane_xs,plane_ys), theta_plane, 0.001, 1000)

print(f"gradient descent is {plane_grad_descent}")