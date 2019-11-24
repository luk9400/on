# Author: Lukasz Bratos
include("methods.jl")
using Test

f(x) = x^2 - 16
pf(x) = 2*x
g(x) = x * exp(-x)
pg(x) = -exp(-x) * (x - 1)
delta = 10^-5
epsilon = 10^-5
maxit = 100

@testset "Metoda bisekcji" begin
    @test abs(Methods.mbisekcji(f, 2.0, 5.5, delta, epsilon)[1]) <= 4 + epsilon
    @test abs(Methods.mbisekcji(f, 2.0, 3.0, delta, epsilon)[4]) == 1
end

@testset "Metoda Newtona" begin
    @test abs(Methods.mstycznych(g, pg, -1.0, delta, epsilon, maxit)[1]) <= 0 + epsilon
    @test abs(Methods.mstycznych(g, pg, 1.0, delta, epsilon, maxit)[4]) == 2
    @test abs(Methods.mstycznych(g, pg, -1.0, delta, epsilon, 1)[4]) == 1
end

@testset "Metoda siecznych" begin
    @test abs(Methods.msiecznych(g, -1.0, 1.0, delta, epsilon, maxit)[1]) <= 0 + epsilon
    @test abs(Methods.msiecznych(g, -1.0, 1.0, delta, epsilon, 2)[4]) == 1
end

