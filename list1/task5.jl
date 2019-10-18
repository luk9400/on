# Author: Lukasz Bratos

# Wektory do testowania, odpowiednio dla Float64 i Float32 oraz prawidlowa odpowiedz
x64 = [2.718281828,-3.141592654,1.414213562,0.5772156649,0.3010299957]
y64 = [1486.2497,878366.9879,-22.37492,4773714.647,0.000185049]
x32 = map(a -> convert(Float32, a), x64)
y32 = map(a -> convert(Float32, a), y64)
answer = -1.00657107000000e-11

# Algorytm 'w przod'. Przyjmuje wektor x oraz y i rozmiar wektorow n.
function forward(x, y, n)
    s = 0.0
    for i in 1:n
        s = s + x[i] * y[i]
    end
    return s
end

# Algorytm 'w tyl'. Przyjmuje wektor x oraz y i rozmiar wektorow n.
function backward(x, y, n)
    s = 0.0
    for i in reverse(1:n)
        s = s + x[i] * y[i]
    end
    return s
end

# Algorytm 'od najwiekszego do najmniejszego'. Przyjmuje wektor x oraz y, typ zmiennopozycyjny w ktorym wykonywane sa obliczenia oraz rozmiar wektorow n.
function fromTheBiggestToTheSmallest(x, y, type, n)
    partials = Array{type}(undef, 5)
    for i in 1:n
        partials[i] = x[i] * y[i]
    end

    pos = sort(filter(x -> x > 0, partials), rev=true)
    neg = sort(filter(x -> x < 0, partials))
    
    return foldl(+, pos) + foldl(+, neg)
end



# Algorytm 'od najmniejszego do najwiekszego'. Przyjmuje wektor x oraz y, typ zmiennopozycyjny w ktorym wykonywane sa obliczenia oraz rozmiar wektorow n.
function fromTheSmallestToTheBiggest(x, y, type, n)
    partials = Array{type}(undef, 5)
    for i in 1:n
        partials[i] = x[i] * y[i]
    end

    pos = sort(filter(x -> x > 0, partials))
    neg = sort(filter(x -> x < 0, partials), rev=true)
    
    return foldl(+, pos) + foldl(+, neg)
end

println("Wynik dla 'w przod' i Float64: ", forward(x64, y64, 5))
println("Wynik dla 'w przod' i Float32: ", forward(x32, y32, 5))

println("Wynik dla 'w tyl' i Float64: ", forward(x64, y64, 5))
println("Wynik dla 'w tyl' i Float32: ", forward(x32, y32, 5))

println("Wynik dla najwiekszy-najmniejszy i Float64: ", fromTheBiggestToTheSmallest(x64, y64, Float64, 5))
println("Wynik dla najwiekszy-najmniejszy i Float32: ", fromTheBiggestToTheSmallest(x32, y32, Float32, 5))

println("Wynik dla najmniejszy-najwiekszy i Float64: ", fromTheSmallestToTheBiggest(x64, y64, Float64, 5))
println("Wynik dla najmniejszy-najwiekszy i Float32: ", fromTheSmallestToTheBiggest(x32, y32, Float32, 5))