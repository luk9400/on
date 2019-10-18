# Author: Lukasz Bratos

# Funkcja f wyliczajaca wartosc dla danego x
function f(x :: Float64)
    return sqrt(x^2 + one(Float64)) - one(Float64)
end

# Funkcja g wyliczajaca wartosc dla danego x
function g(x :: Float64)
    return x^2 / (sqrt(x^2 + one(Float64)) + one(Float64))
end

# Wypisywanie wartości w formacie pod LaTeXa
for i in 1:10
    println(i, " & ", f(8.0 ^ (-i)), " & ", g(8.0 ^ (-i)), " \\\\\n\\hline")
end

for i in 1:10
    println(20 * i, " & ", f(8.0 ^ (-20 * i)), " & ", g(8.0 ^ (-20 * i)), " \\\\\n\\hline")
end