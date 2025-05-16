# John Piotrowski - 7410X - Final Project
# implement a generic gradient descent function in any other programming language that you can pass in a line, curve, and plane. That can take dataset and any equation and find best fit theta. And it should take hyper parametsr ir ha e some felxible method for sealing with hyperparams

# Increase python's recursion limit to be greater than the default 1000 :)
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


def pred_ys(target, xs, theta):
    return target(xs)(theta)

l2_loss = \
    lambda target: \
        lambda xs, ys: \
            lambda theta: (
                sum((ys[i] - pred_ys(target, xs, theta)[i]) ** 2
                    for i in range(len(ys)))
                    )

# # Early testing - keeping for posterity
# # Early Quad
# t = [3.0]
# theta_quad_early = [4.5, 2.1, 7.8]
# # Dot Testing
# dot_1 = [2.0, 1.0, 7.0]
# dot_2 = [8.0, 4.0, 3.0]
# print(line(xs)(theta_line))
# print(quad(t)(theta_quad_early))
# print(our_dot(dot_1, dot_2))
# print(f"l2-loss is {(l2_loss(line)(xs,ys)(theta_line))}")

def contains_tensor(theta):
    if any(isinstance(x, list) for x in theta):
        return True
    else:
        return False

# Using central difference approximation: https://en.wikipedia.org/wiki/Finite_difference
def gradient_of_list(f, theta, change_of_theta):
    gradient = []
    for l1 in range(len(theta)):
        theta_plus_change = []
        theta_minus_change = []
        for l2 in range(len(theta)):
            if l2 == l1:
                theta_plus_change.append(theta[l2] + change_of_theta)
                theta_minus_change.append(theta[l2] - change_of_theta)
            else:
                theta_plus_change.append(theta[l2])
                theta_minus_change.append(theta[l2])
        total_change_in_f = f(theta_plus_change) - f(theta_minus_change)
        total_change_in_theta = (2 * change_of_theta)
        gradient.append(total_change_in_f/total_change_in_theta)
    return gradient

# Needed to add flatten method (pg. 184) for the tensor
def flatten(theta):
    flattened_list = []
    original_nested_list_structure = []     # Only will work for tensors of rank 2, good enough for now.
    for param in theta:
        if isinstance(param, list):
            original_nested_list_structure.append(len(param))
            flattened_list.extend(param)
        else:
            original_nested_list_structure.append(1)
            flattened_list.append(param)
    return flattened_list, original_nested_list_structure

# In general, I was surprised by how few resources are out there for unflattening a list with a structure - could be a good opp. for a library
def unflatten(flattened_list, structure):
    original_list = []
    index = 0
    for count in structure:
        if count == 1:
            original_list.append(flattened_list[index])
            index += 1
        else:
            original_list.append(flattened_list[index:index + count])
            index += count
    return original_list

def gradient_of_tensor(f, theta, change_of_theta):
    flattened_theta, structure = flatten(theta)
    flattened_gradient = gradient_of_list(lambda flattened_list:
                                  f(unflatten(flattened_list, structure)), flattened_theta, change_of_theta)
    return unflatten(flattened_gradient, structure)

def gradient_of(f, theta, change_of_theta=1e-8):
    # Using the default value (pg. 168)
    if contains_tensor(theta):
        return gradient_of_tensor(f, theta, change_of_theta)
    else:
        return gradient_of_list(f, theta, change_of_theta)

def revise(f, revs, theta):
    if revs == 0:
        return theta
    else:
        return revise(f, revs - 1, f(theta))


def gradient_descent(obj, theta, alpha, revs):
    def f(big_theta):
        gradient = gradient_of(obj, big_theta)
        if contains_tensor(big_theta):
            weights = []
            for i in range(len(big_theta[0])):
                weights.append(big_theta[0][i] - alpha * gradient[0][i])
            return [weights, big_theta[1] - alpha * gradient[1]]
        else:
            return [param - alpha * gradient for param, gradient in zip(big_theta, gradient)]
    return revise(f, revs, theta)

line_grad_descent = gradient_descent(l2_loss(line)(xs,ys), theta_line, 0.01, 1000)
print(f"gradient descent is {line_grad_descent}")

quad_grad_descent = gradient_descent(l2_loss(quad)(quad_xs,quad_ys), theta_quad, 0.001, 1000)
print(f"gradient descent is {quad_grad_descent}")

plane_grad_descent = gradient_descent(l2_loss(plane)(plane_xs,plane_ys), theta_plane, 0.001, 1000)
print(f"gradient descent is {plane_grad_descent}")