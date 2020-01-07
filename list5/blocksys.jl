# Author: Lukasz Bratos

module Blocksys

import SparseArrays
using LinearAlgebra

export readMatrix, readVector, solveGauss, solveGaussWithChoice, lu, solveLu, gaussWithChoice, solveLuWithChoice, printXToFile, printBToFile, computeRightSideVector

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
function readMatrix(file::String)
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
function readVector(file::String)::Vector{Float64}
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
        for j in max(1, i - (2 + l)):min(n, i + l)
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
function gauss(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, b::Vector{Float64})
    for k in 1:(n - 1)
        for i in (k + 1):min(n, k + l + 1)  
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
function solveGauss(_A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, _b::Vector{Float64})::Vector{Float64}
    A, b = gauss(_A, n, l, _b)

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
function gaussWithChoice(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, b::Vector{Float64})
    perm = [1:n;]

    for k in 1:(n - 1)
        max = 0.0
        maxIdx = 0

        for i in k:min(n, k + l + 1)
            if abs(A[perm[i], k]) > max
                max = abs(A[perm[i], k])
                maxIdx = i
            end
        end

        perm[maxIdx], perm[k] = perm[k], perm[maxIdx]

        for i in (k + 1):min(n, k + l + 1) 
            z = A[perm[i], k] / A[perm[k], k]
            A[perm[i], k] = 0.0

            for j in (k + 1):min(n, k + 2 * l)
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
function solveGaussWithChoice(_A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, _b::Vector{Float64})
    A, b, perm = gaussWithChoice(_A, n, l, _b)

    x = zeros(Float64, n)

    for i in n:-1:1
        sum = 0.0
        
        for j in (i + 1):min(n, i + 2 * l)
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
    A - macierz U
    L - macierz L        
"""
function lu(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64)
    # A is our U
    L = SparseArrays.spzeros(n, n)

    for k in 1:(n - 1)
        L[k ,k] = 1.0

        for i in (k + 1):min(n, k + l + 1)
            z = A[i, k] / A[k, k]
            L[i, k] = z
            A[i, k] = 0.0
            for j in (k + 1):min(n, k + 2 * l)
                A[i, j] -= z * A[k, j]
            end
        end
    end
    L[n,n] = 1.0

    return (A, L)
end

"""
Funkcja rozwiązująca układ równań Ax = b korzystając z rozkładu LU

Dane wejściowe:
    U - macierz U w formacie SparseMatrixCSC
    L - macierz L w formacie SparseMatrixCSC
    n - rozmiar macierzy
    l - rozmiar bloku
    b - wektor prawych stron
Dane wyjściowe:
    x - wektor wyników
"""
function solveLu(U::SparseArrays.SparseMatrixCSC{Float64,Int64}, L::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, b::Vector{Float64})::Vector{Float64}
    x = zeros(Float64, n)
    
    for k in 1:(n - 1)
        for i in (k + 1):min(n, k + l + 1)
            b[i] -= L[i, k] * b[k]
        end
    end

    for i in n:-1:1
        sum = 0.0

        for j in (i + 1):min(n, i + l)
            sum += U[i, j] * x[j]
        end

        x[i] = (b[i] - sum) / U[i, i]
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
        A - macierz U
        L - macierz L        
        perm - wektor permutacji
"""
function luWithChoice(A::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64)
    # A is our U
    perm = [1:n;]

    L = SparseArrays.spzeros(n, n)

    for k in 1:(n - 1)

        max = 0.0
        maxIdx = 0

        for i in k:min(n, k + l + 1)
            if abs(A[perm[i], k]) > max
                max = abs(A[perm[i], k])
                maxIdx = i
            end
        end

        perm[maxIdx], perm[k] = perm[k], perm[maxIdx]

        for i in (k + 1):min(n, k + l + 1)
            z = A[perm[i], k] / A[perm[k], k]

            L[perm[i], k] = z
            A[perm[i], k] = 0.0

            for j in (k + 1):min(n, k + 2 * l)
                A[perm[i], j] -= z * A[perm[k], j]
            end
        end
    end
    
    return (A, L, perm)
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
function solveLuWithChoice(U::SparseArrays.SparseMatrixCSC{Float64,Int64}, L::SparseArrays.SparseMatrixCSC{Float64,Int64}, n::Int64, l::Int64, b::Vector{Float64}, perm::Vector{Int64})
    x = zeros(Float64, n)

    for k in 1:(n - 1)
        for i in (k + 1):min(n, k + l + 1)
            b[perm[i]] -= L[perm[i], k] * b[perm[k]]
        end
    end

    for i in n:-1:1
        sum = 0.0

        for j in (i + 1):min(n, i + 2 * l)
            sum += U[perm[i], j] * x[j]
        end

        x[i] = (b[perm[i]] - sum) / U[perm[i], i]
    end

    return x
end

end