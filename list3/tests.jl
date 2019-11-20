# Author: Lukasz Bratos
include("methods.jl")

f(x) = x + 1
delta = 10^-5
epsilon = 10^-5

println(mbisekcji(f, -10.0, 10.0, delta, epsilon))

