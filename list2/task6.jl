# Author: Lukasz Bratos

# Odkomentować przy pierwszym użyciu
# import Pkg
# Pkg.add("Plots")
# Pkg.add("PyPlot")
using Plots

# Nasze dane testowe do zadania
consts = [-2, -2, -2, -1, -1, -1, -1]
x0s = [1, 2, 1.99999999999999, 1, -1, 0.75, 0.25]

# Funkcja obliczajaca wartosc wyrazenia z zadania
# n - liczba iteracji, c - pewna stała, x0 - nasz argument
function func(n, c, x0)
    arr = zeros(Float64, 0)
    xn = x0
    push!(arr, xn)
    for i in 1:n
        xn = xn ^ 2 + c
        push!(arr, xn)
    end
    return arr    
end

x = 0:40
for i in 1:7
    println("Wynik dla c = ", consts[i], ", x0 = ", x0s[i], ": \n", func(40, Float64(consts[i]), Float64(x0s[i])))
    y = func(40, Float64(consts[i]), Float64(x0s[i]))
    pyplot()
    savefig(scatter(x, y, title = "$i.", xlabel = "x", ylabel = "y"), "plot$i.png")
end
