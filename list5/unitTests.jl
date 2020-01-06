include("blocksys.jl")

using Test
using LinearAlgebra

sizes = [16, 10000, 50000]

@testset "Tests for matrix $size" for size in sizes
    A, n, l = Blocksys.readMatrix("./examples/$(size)/A.txt")
    b = Blocksys.readVector("./examples/$(size)/b.txt")

    @testset "Gauss elimination" begin
        @test isapprox(Blocksys.solveGauss(A, n, l, b), \(A, b))
    end

    @testset "Gauss elimination with choice" begin
        @test isapprox(Blocksys.solveGaussWithChoice(A, n, l, b), \(A, b))
    end

    @testset "Solve LU" begin
        L, U = Blocksys.lu(A, n, l)
        @test isapprox(Blocksys.solveLu(L, U, n, l, b), \(A, b))
    end

    @testset "Solve LU with choice" begin
        L, U, perm = Blocksys.luWithChoice(A, n, l)
        @test isapprox(Blocksys.solveLuWithChoice(L, U, n, l, b, perm), \(A, b))
    end
end