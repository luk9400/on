# Author: Lukasz Bratos

module Blocksys

import SparseArrays
using LinearAlgebra

export readMatrixFromFile, readVectorFromFile, solveSparseGauss, solveSparseGaussWithChoice, sparseGaussLU, solveSparseGaussLU, sparseGaussWithChoice, solveSparseGaussLUWithChoice, printXToFile, printBToFile, computeRightSideVector

"""
Funkcja wczytuje macierz z pliku

Dane wejściowe:
    file - ścieżka pliku wejściowego
Dane wyjściowe:
    krotka (A, n, l), gdzie:
        A - macierz rzadka w formacie SparseMatrixCSC
        n - rozmiar macierzy
        l - rozmiar bloku
"""
function readMatrixFromFile(file::String)
    open(file) do f
        firstLine = split(readline(f))
        n = parse(Int64, firstLine[1])
        l = parse(Int64, firstLine[2])

        rows = Int64[]
        columns = Int64[]
        values = Float64[]

        for line in eachline(f)
            line = split(line)
            push!(rows, parse(Int64, line[1]))
            push!(columns, parse(Int64, line[2]))
            push!(values, parse(Float64, line[3]))
        end

        A = SparseArrays.sparse(rows, columns, values)
        return (A, n, l)
    end
end

"""
Funkcja wczytująca wektor z pliku

Dane wejściowe:
    file - ścieżka pliku wejściowego
Dane wyjściowe:
    vector - wczytany wektor
"""
function readVectorFromFile(file::String)::Vector{Float64}
    open(file) do f
        n = parse(Int64, readline(f))
        vector = []

        for line in eachline(f)
            push!(vector, parse(Float64, line))
        end

        return vector
    end
end

"""
Funkcja zapisująca wektor do pliku

Dane wejściowe:
    file - ścieżka do pliku
    x - wektor, który chcemy zapisać
"""
function printXToFile(file::String, x::Vector{Float64})
    open(file, "w") do f
        foreach(a->write(f, string(a), "\n"), x)
    end
end

"""
Funkcja zapisująca wektor do pliku wraz z błędem względnym

Dane wejściowe:
    file - ścieżka do pliku
    x - wektor, który chcemy zapisać
"""
function printBToFile(file::String, x::Vector{Float64})
    open(file, "w") do f
        y = ones(Float64, length(x))
        write(f, string(norm(y - x) / norm(x)), "\n")
        foreach(a->write(f, string(a), "\n"), x)
    end
end

"""
Funkcja wyliczająca wektor prawych stron na podstawie macierzy A

Dane wejściowe:
    A - macierz rzadka w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
Dane wyjściowe:
    b - wektor prawych stron
"""
function computeRightSideVector(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64)
    x = ones(Float64, n)
    b = zeros(Float64, n)

    for i in 1:n
        for j in max(1, i - (2 + l - i % l)):min(n, i + l)
            b[i] += A[i, j]
        end
    end

    return b
end

"""
Funkcja aplikująca metodę eliminacji Gaussa na macierzy A

Dane wejściowe:
    A - macierz rzadka w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
    b - wektor prawych stron
Dane wyjściowe:
    krotka (A, b), gdzie:
        A - zmodyfikowana macierz
        b - zmodyfikowany wektor prawych stron
"""
function sparseGauss(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, b::Vector{Float64})
    for k in 1:(n - 1)
        for i in (k + 1):min(n, Int64(l + l * floor((k + 1) / l)))
            z = A[i, k] / A[k, k]
            A[i, k] = 0.0
            for j in (k + 1):min(n, k + l)
                A[i, j] -= z * A[k, j]
            end
            b[i] -= z * b[k]
        end
    end

    return (A, b)
end

"""
Funkcja rozwiązująca układ równań Ax = b metodą eliminacji Gaussa

Dane wejściowe:
    A - macierz rzadka współczynników w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
    b - wektor prawych stron
Dane wyjściowe:
    x - wektor wyników
"""
function solveSparseGauss(_A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, _b::Vector{Float64})::Vector{Float64}
    A, b = sparseGauss(_A, n, l, _b)

    x = zeros(Float64, n)

    for i in n:-1:1
        sum = 0.0

        for j in (i + 1):min(n, i + l)
            sum += A[i, j] * x[j]
        end

        x[i] = (b[i] - sum) / A[i, i]
    end
    return x
end

"""
Funkcja aplikująca metodę eliminacji Gaussa (z częściowym wyborem elementu głównego) na macierzy A

Dane wejściowe:
    A - macierz rzadka w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
    b - wektor prawych stron
Dane wyjściowe:
    krotka (A, b, perm), gdzie:
        A - zmodyfikowana macierz
        b - zmodyfikowany wektor prawych stron
        perm - wektor permutacji
"""
function sparseGaussWithChoice(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, b::Vector{Float64})
    perm = [1:n;]

    for k in 1:(n - 1)
        for i in (k + 1):min(n, Int64(l + l * floor((k + 1) / l)))
            max = abs(A[perm[i], k])
            maxIdx = k

            for j in i:min(n, Int64(l + l * floor((k + 1) / l)))
                if abs(A[perm[i], k]) > max
                    max = abs(A[perm[j], k])
                    maxIdx = j
                end
            end

            perm[maxIdx], perm[k] = perm[k], perm[maxIdx]

            z = A[perm[i], k] / A[perm[k], k]
            A[perm[i], k] = 0.0

            for j in (k + 1):min(n, Int64(2 * l + l * floor((k + 1) / l)))
                A[perm[i], j] -= z * A[perm[k], j]
            end

            b[perm[i]] -= z * b[perm[k]]
        end
    end

    return (A, b, perm)
end

"""
Funkcja rozwiązująca układ równań Ax = b metodą eliminacji Gaussa (z częściowym wyborem elementu głównego)

Dane wejściowe:
    A - macierz rzadka współczynników w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
    b - wektor prawych stron
Dane wyjściowe:
    x - wektor wyników
"""
function solveSparseGaussWithChoice(_A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, _b::Vector{Float64})
    A, b, perm = sparseGaussWithChoice(_A, n, l, _b)

    x = zeros(Float64, n)

    for i in n:-1:1
        sum = 0.0
        for j in (i + 1):min(n, Int64(2 * l + l * floor((perm[i] + 1) / l)))
            sum += A[perm[i], j] * x[j]
        end

        x[i] = (b[perm[i]] - sum) / A[perm[i], i]
    end
    
    return x
end

"""
Funkcja dokonująca rozkładu LU macierzy A metodą eliminacji Gaussa 

Dane wejściowe:
    A - macierz rzadka w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
Dane wyjściowe:
    A - macierz rozkładu LU        
"""
function sparseGaussLU(_A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64)
    A = copy(_A)

    for k in 1:(n - 1)
        for i in (k + 1):min(n, Int64(l + l * floor((k + 1) / l)))
            z = A[i, k] / A[k, k]
            A[i, k] = z
            for j in (k + 1):min(n, k + l)
                A[i, j] = A[i, j] - z * A[k, j]
            end
        end
    end

    return A
end

"""
Funkcja rozwiązująca układ równań Ax = b korzystając z rozkładu LU

Dane wejściowe:
    A - macierz rozkładu LU w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
    b - wektor prawych stron
Dane wyjściowe:
    x - wektor wyników
"""
function solveSparseGaussLU(_A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, _b::Vector{Float64})::Vector{Float64}
    A = copy(_A)
    b = zeros(Float64, n)

    for i in 1:n
        sum = 0.0

        for j in max(1, Int64(l * floor((i - 1) / l) - 1)):(i - 1)
            sum += A[i, j] * b[j] 
        end
        
        b[i] = _b[i] - sum
    end

    x = zeros(Float64, n)

    for i in n:-1:1
        sum = 0.0

        for j in (i + 1):min(n, i + l)
            sum += A[i, j] * x[j]
        end

        x[i] = (b[i] - sum) / A[i, i]
    end

    return x
end

"""
Funkcja dokonująca rozkładu LU macierzy A metodą eliminacji Gaussa (z częściowym wyborem elementu głównego)

Dane wejściowe:
    A - macierz rzadka w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
Dane wyjściowe:
    krotka (A, perm), gdzie:
        A - macierz rozkładu LU        
        perm - wektor permutacji
"""
function sparseGaussLUWithChoice(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64)
    perm = [1:n;]

    for k in 1:(n - 1)
        for i in (k + 1):min(n, Int64(l + l * floor((k + 1) / l)))
            max = abs(A[perm[k], k])
            maxIdx = k
            for j in i:min(n, Int64(l + l * floor((k + 1) / l)))
                if abs(A[perm[j], k]) > max
                    max = abs(A[perm[j], k])
                    maxIdx = j
                end
            end

            perm[maxIdx], perm[k] = perm[k], perm[maxIdx]

            z = A[perm[i], k] / A[perm[k], k]
            A[perm[i], k] = z

            for j in (k + 1):min(n, Int64(2 * l + l * floor((k + 1) / l)))
                A[perm[i], j] -= z * A[perm[k], j]
            end
        end
    end
    
    return (A, perm)
end

"""
Funkcja rozwiązująca układ równań Ax = b korzystając z rozkładu LU (z częściowym wyborem elementu głównego)

Dane wejściowe:
    A - macierz rozkładu LU w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
    b - wektor prawych stron
    perm - wektor permutacji
Dane wyjściowe:
    x - wektor wyników
"""
function solveSparseGaussLUWithChoice(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, b::Vector{Float64}, perm::Vector{Int64})
    z = zeros(Float64, n)

    for i in 1:n
        sum = 0.0

        for j in max(1, Int64(l * floor((i - 1) / l) - 1)):(i - 1)
            sum += A[perm[i], j] * z[j]
        end

        z[i] = b[perm[i]] - sum
    end

    x = zeros(Float64, n)

    for i in n:-1:1
        sum = 0.0

        for j in (i + 1):min(n, Int64(2 * l + l * floor((perm[i] + 1) / l)))
            sum += A[perm[i], j] * x[j]
        end

        x[i] = (z[i] - sum) / A[perm[i], i]
    end

    return x
end

end