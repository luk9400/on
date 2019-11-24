# Author: Lukasz Bratos

include("methods.jl")

f1(x) = exp(1 - x) - 1
pf1(x) = -exp(1 - x)
f2(x) = x * exp(-x)
pf2(x) = -exp(-x) * (x - 1)
delta = 10^-5
epsilon = 10^-5
maxit = 100

# f1
println("Metoda bisekcji dla f1 na przedziale [0.0, 1.5]: ", Methods.mbisekcji(f1, 0.0, 1.5, delta, epsilon))
println("Metoda bisekcji dla f1 na przedziale [0.0, 2.0]: ", Methods.mbisekcji(f1, 0.0, 2.0, delta, epsilon))
println("Metoda Newtona dla f1 z x0 = 0.0: ", Methods.mstycznych(f1, pf1, 0.0, delta, epsilon, maxit))
println("Metoda siecznych dla f1, gdzie x0 = 0.5, a x1 = 1.5: ", Methods.msiecznych(f1, 0.0, 2.0, delta, epsilon, maxit))

# f2
println("Metoda bisekcji dla f2 na przedziale [-1.0, 1.5]: ", Methods.mbisekcji(f2, -1.0, 1.5, delta, epsilon))
println("Metoda bisekcji dla f2 na przedziale [-1.0, 1.0]: ", Methods.mbisekcji(f2, -1.0, 1.0, delta, epsilon))
println("Metoda Newtona dla f2 z x0 = -1.0: ", Methods.mstycznych(f2, pf2, -1.0, delta, epsilon, maxit))
println("Metoda siecznych dla f2, gdzie x0 = -1.0, a x1 = 1.0: ", Methods.msiecznych(f2, -1.0, 1.0, delta, epsilon, maxit))

# testy Newton
println("Metoda Newtona dla f1 z x0 = 3.0: ", Methods.mstycznych(f1, pf1, 3.0, delta, epsilon, maxit))
println("Metoda Newtona dla f1 z x0 = 15.0: ", Methods.mstycznych(f1, pf1, 15.0, delta, epsilon, maxit))
println("Metoda Newtona dla f2 z x0 = 1.0: ", Methods.mstycznych(f2, pf2, 1.0, delta, epsilon, maxit))
println("Metoda Newtona dla f2 z x0 = 50.0: ", Methods.mstycznych(f2, pf2, 50.0, delta, epsilon, maxit))