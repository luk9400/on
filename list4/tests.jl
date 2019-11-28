# Author: Luaksz Bratos

include("diff.jl")
using Test

# dane testowe do zadania 1
x1 = [3.0, 1.0, 5.0, 6.0]
f1 = [1.0, -3.0, 2.0, 4.0]
ans1 = [1.0, 2.0, -3.0 / 8.0, 7.0 / 40.0]

x2 = [-1.0, 0.0, 1.0, 2.0, 3.0]
f2 = [2.0, 1.0, 2.0, -7.0, 10.0]
ans2 = [2.0, -1.0, 1.0, -2.0, 2.0]

# dane testowe do zadania 2
fx2 = Diff.ilorazyRoznicowe(x2, f2)

# dane testowe do zadania 3
ans3 = [1.0, 6.0, -1.0, -6.0, 2.0]

@testset "Ilorazy roznicowe" begin
    @test isapprox(Diff.ilorazyRoznicowe(x1, f1), ans1)
    @test isapprox(Diff.ilorazyRoznicowe(x2, f2), ans2)
end

@testset "Wartosc wielomianu Newtona" begin
    @test isapprox(Diff.warNewton(x2, fx2, 2.0), -7.0)
    @test isapprox(Diff.warNewton(x2, fx2, 10.0), 13961.0)
    @test isapprox(Diff.warNewton(x2, fx2, 5.0), 506.0)
    @test isapprox(Diff.warNewton(x2, fx2, -3.0), 298.0)
end

@testset "Wspolczynniki w postaci normalnej z postaci Newtona" begin
    @test isapprox(Diff.naturalna(x2, fx2), ans3)
end