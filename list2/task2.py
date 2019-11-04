import matplotlib.pyplot as plt
import math

x = [i / 10.0 for i in range(-100, 400)]

def f(x):
    return math.exp(x) * math.log(1 + math.exp(-x))

y = [f(i) for i in x]

plt.title("Wykres funkcji f(x)")
plt.xlabel("x")
plt.ylabel("y")
plt.plot(x, y)
plt.show()