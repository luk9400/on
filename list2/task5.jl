# Author: Lukasz Bratos

# Funcja oblicza wartość wyrażenia podanego w zadaniu
# n - liczba iteracji, p0 - wartość początkowa p0, r - dana stała
function func(n, p0, r)
    pn = p0
    for i in 1:n
        pn = pn + r * pn * (1 - pn)
    end
    return pn
end

# podpunkt 1

println("Funkcja obliczana normalnie: ", func(40, Float32(0.01), Float32(3.0)))
println("Funkcja obliczana z zaokrągleniem: ", func(30, Float32(0.722), Float32(3.0)))


# podpunkt 2

println("Wynik dla Float32: ", func(40, Float32(0.01), Float32(3.0)))
println("Wynik dla Float64: ", func(40, Float64(0.01), Float64(3.0)))