# Author: Lukasz Bratos

module Diff
using Plots
gr()

export ilorazyRoznicowe, warNewton, naturalna, rysujNnfx

"""
Funkcja oblicza iloraz różnicowy

Dane:
x – wektor długości n + 1 zawierający węzły x0, ..., xn
    x[1] = x0, ..., x[n+1] = xn
f – wektor długości n + 1 zawierający wartości interpolowanej funkcji w węzłach
    f(x0), ..., f(xn)

Wyniki:
fx– wektor długości n + 1 zawierający obliczone ilorazy różnicowe
    fx[1] = f[x0],
    fx[2] = f[x0, x1], ..., fx[n] = f[x0, ..., xn−1], fx[n+1] = f[x0, ..., xn]
"""
function ilorazyRoznicowe(x::Vector{Float64}, f::Vector{Float64})
    len = length(f)
    fx = Vector{Float64}(undef, len)

    for i in 1:len
        fx[i] = f[i]
    end

    for i in 2:len
        for j in len:-1:i
            fx[j] = (fx[j] - fx[j - 1]) / (x[j] - x[j - i + 1])
        end
    end

    return fx
end

"""
Funkcja wyliczajaca wartosc wielomianu interpolacyjnego stopnia n w postaci Newtona Nn(x)
za pomoca uogolnionego algorytmu Hornera

Dane:
x – wektor długości n + 1 zawierający węzły x0, ..., xn
    x[1] = x0, ..., x[n+1] = xn
fx – wektor długości n+ 1 zawierający ilorazy różnicowe
    fx[1] = f[x0],
    fx[2] = f[x0, x1], ..., fx[n] = f[x0, ..., xn−1], fx[n+1] =f [x0, ..., xn]
t – punkt, w którym należy obliczyć wartość wielomianu

Wyniki:
nt – wartość wielomianu w punkcie t
"""
function warNewton(x::Vector{Float64}, fx::Vector{Float64}, t::Float64)
    len = length(x)
    nt = fx[len]

    for i in (len - 1):-1:1
        nt = fx[i] + (t - x[i]) * nt
    end

    return nt
end

"""
Funkcja wyliczajaca wspolczynniki wielomianu w postaci normanej z wielomianu 
interpolacyjnego w postaci Newtona

Dane:
x – wektor długości n+ 1 zawierający węzły x0, ..., xn
    x[1] = x0, ..., x[n+1] = xn
fx – wektor długości n + 1 zawierający ilorazy różnicowe
    fx[1] = f[x0],
    fx[2] = f[x0, x1], ..., fx[n] = f[x0, ..., xn−1], fx[n+1] = f[x0, ..., xn]

Wyniki:
a – wektor długości n+ 1 zawierający obliczone współczynniki postaci naturalnej
    a[1] = a0,
    a[2] = a1, ..., a[n] = an−1, a[n+1] = an.
"""
function naturalna(x::Vector{Float64}, fx::Vector{Float64})
    len = length(x)
    a = Vector{Float64}(undef, len)
    a[len] = fx[len]

    for i in (len - 1):-1:1
        a[i] = fx[i] - a[i + 1] * x[i]

        for j in (i + 1):(len - 1)
            a[j] = a[j] - a[j + 1] * x[i]
        end
    end

    return a
end

"""
Funkcja rysująca wielomian interpolacyjny i interpolowaną funkcję na danym przedziale

Dane:
f – funkcja f(x) zadana jako anonimowa funkcja,
a, b – przedział interpolacji
n – stopień wielomianu interpolacyjnego
filename - nazwa pliku wynikowego

Wyniki:
– funkcja rysuje wielomian interpolacyjny i interpolowaną funkcję w przedziale [a, b]
"""
function rysujNnfx(f, a::Float64, b::Float64, n::Int, filename::String)
    dist = (b - a) / n

    x = Vector{Float64}(undef, n + 1)
    y = Vector{Float64}(undef, n + 1)

    for i in 1:(n + 1)
        x[i] = a + (i - 1) * dist
        y[i] = f(x[i]);
    end

    fx = ilorazyRoznicowe(x, y)

    numOfPoints = 100
    accuracy_dist = (b - a) / numOfPoints

    fx_val = Vector{Float64}(undef, numOfPoints + 1)
    wx_res = Vector{Float64}(undef, numOfPoints + 1)

    for i in 1:(numOfPoints + 1)
        t = a + (i - 1) * accuracy_dist
        fx_val[i] = f(t)
        wx_res[i] = warNewton(x, fx, t)
    end

    plot(range(a, stop=b, length=(numOfPoints + 1)), fx_val, color = "red", label = "f(x)")
    plot!(range(a, stop=b, length=(numOfPoints + 1)), wx_res, color = "blue", label = "w(x)")
    savefig("./plots/$filename.png")
end

end

