# Author: Lukasz Bratos

# Nasze dane testowe do zadania
consts = [-2, -2, -2, -1, -1, -1, -1]
x0s = [1, 2, 1.99999999999999, 1, -1, 0.75, 0.25]

# Funkcja obliczajaca wartosc wyrazenia z zadania
# n - liczba iteracji, c - pewna stała, x0 - nasz argument
function func(n, c, x0)
    xn = x0
    for i in 1:n
        xn = xn ^ 2 + c
    end
    return xn    
end

for i in 1:7
    println("Wynik dla c = ", consts[i], ", x0 = ", x0s[i], ": ", func(40, Float64(consts[i]), Float64(x0s[i])))
end
