# Author: Lukasz Bratos

# Funkcja zwraca wartosc wyrazenia sin(x) + cos(3x) dla danego x
function f(x :: Float64)
    return sin(x) + cos(3 * x)
end

# Funkcja zwraca wartosc wyrazenia cos(x) - 3sin(3x) dla danego x (co jest pochodna wyrazenia sin(x) + cos(3x))
function derivativeOfF(x :: Float64)
    return cos(x) - 3 * sin(3 * x)
end

# Funkcja wylicza wartosc pochodnej funkcji sin(x) + cos(3x) dla danego x
function derivative(func, x0, h)
    return (func(x0 + h) - func(x0)) / h
end

# Wypisywanie wynikow w formacie pod LaTeXa
for i in 0:54
    println("\$ 2^{-$i} \$ & ", 1.0 + 2.0 ^ (-i), " & ", derivative(f, 1.0, 2.0 ^ (-i)), " & ", abs(derivativeOfF(1.0) - derivative(f, 1.0, 2.0 ^ (-i))), " \\\\\n\\hline")
end

println("f'(1.0) = ", derivativeOfF(1.0))