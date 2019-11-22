# Author: Lukasz Bratos
include("methods.jl")

# Różnica naszych funkcji
f(x) = exp(x) - 3 * x
g(x) = 3 * x - exp(x)
delta = 10^-4
epsilon = 10^-4

println("Przedział [0.0, 1.0: ", Methods.mbisekcji(f, 0.0, 1.0, delta, epsilon))
println("Przedział [1.0, 2.0: ", Methods.mbisekcji(f, 1.0, 2.0, delta, epsilon))

println("Przedział [0.0, 1.0: ", Methods.mbisekcji(g, 0.0, 1.0, delta, epsilon))
println("Przedział [1.0, 2.0: ", Methods.mbisekcji(g, 1.0, 2.0, delta, epsilon))