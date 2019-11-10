# Author: Lukasz Bratos

using LinearAlgebra

function hilb(n::Int)
    # Function generates the Hilbert matrix  A of size n,
    #  A (i, j) = 1 / (i + j - 1)
    # Inputs:
    #	n: size of matrix A, n>=1
    #
    #
    # Usage: hilb(10)
    #
    # Pawel Zielinski
    if n < 1
        error("size n should be >= 1")
    end
    return [1 / (i + j - 1) for i in 1:n, j in 1:n]
end
    
function matcond(n::Int, c::Float64)
# Function generates a random square matrix A of size n with
# a given condition number c.
# Inputs:
#	n: size of matrix A, n>1
#	c: condition of matrix A, c>= 1.0
#
# Usage: matcond(10, 100.0)
#
# Pawel Zielinski
    if n < 2
        error("size n should be > 1")
    end
    if c < 1.0
        error("condition number  c of a matrix  should be >= 1.0")
    end
    (U, S, V) = svd(rand(n, n))
    return U * diagm(0 => [LinRange(1.0, c, n);]) * V'
end

function calculate(matrix, x, size)
    b = matrix * x
    gauss = matrix \ b
    inversion = inv(matrix) * b

    gauss_err = norm(gauss - x) / norm(x)
    inv_err = norm(inversion - x) / norm(x)

    println("$size & $(rank(matrix)) & $(cond(matrix)) & $gauss_err & $inv_err \\\\ \\hline")
end

for i in 1:20
    matrix = hilb(i)
    x = ones(Float64, i)
    calculate(matrix, x, i)
end

for i in [5, 10, 20]
    for j in [1.0, 10.0, 10.0^3, 10.0^7, 10.0^12, 10.0^16]
        matrix = matcond(i, j)
        x = ones(Float64, i)
        calculate(matrix, x, i)
    end
end