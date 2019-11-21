# Author: Lukasz Bratos
include("methods.jl")

f(x) = sin(x) - (x / 2) ^ 2
pf(x) = cos(x) - (x / 2)
delta = 10 ^ -5 / 2
epsilon = 10 ^ -5 / 2
maxit = 100

println("Metoda bisekcji: ", Methods.mbisekcji(f, 1.5, 2.0, delta, epsilon))
println("Metoda Newtona: ", Methods.mstycznych(f, pf, 1.5, delta, epsilon, maxit))
println("Metoda siecznych: ", Methods.msiecznych(f, 1.0, 2.0, delta, epsilon, maxit))
