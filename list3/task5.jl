# Author: Lukasz Bratos
include("methods.jl")

f(x) = exp(x) - 3x
delta = 10^-4
epsilon = 10^-4

println(Methods.mbisekcji(f, 0.0, 1.0, delta, epsilon))
println(Methods.mbisekcji(f, 1.0, 2.0, delta, epsilon))