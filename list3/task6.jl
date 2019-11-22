# Author: Lukasz Bratos

include("methods.jl")

f1(x) = exp(1 - x) - 1
pf1(x) = -exp(1 - x)
f2(x) = x * exp(-x)
pf2(x) = -exp(-x) * (x - 1)
delta = 10^-5
epsilon = 10^-5
maxit = 100

newtonx0s = [0.5, 0.75, 1.0, 1.5, 5.0, 10.0, 20.0]

println("Metoda bisekcji dla f1 na przedziale [0.5, 1.5]: ", Methods.mbisekcji(f1, 0.5, 1.5, delta, epsilon))
println("Metoda siecznych dla f1, gdzie x0 = 0.5, a x1 = 1.5: ", Methods.msiecznych(f1, 0.5, 1.5, delta, epsilon, maxit))

foreach(
    x -> println("Metoda Newtona dla f1 z x0 = $x: ", Methods.mstycznych(f1, pf1, x, delta, epsilon, maxit)),
    newtonx0s)