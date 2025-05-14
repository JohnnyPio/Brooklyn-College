xs = [2.0, 1.0, 4.0, 3.0]
ys = [1.8, 1.2, 4.2, 3.3]
theta_line = [0.0, 0.0]
ts = 3.0
theta_quad = [4.5, 2.1, 7.8]

# def line(x):
#     return lambda theta: theta[0] * x + theta[1]

line = lambda xs: lambda theta_line: [theta_line[0] * x + theta_line[1] for x in xs]

quad = lambda ts: lambda theta: [theta[0] * x * x + theta[1] * x + theta[0] for x in xs]

plane = lambda

# def quad(t):
#     return lambda theta: theta[0] * t * t + theta[1] * t + theta[2]

      # Returns a function that expects theta# So: y = 2.0 * 3.0 + 1.0 = 7.0
print(line(xs)(theta_line))
print(quad(ts)(theta_quad))