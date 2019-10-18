# Author: Lukasz Bratos

# Funkcja przyjmuje zakres [a, b].
# Jesli w danym zakresie liczby sa rownomiernie rozmieszczone, 
# to zwraca roznice pomiedzy dwoma kolejnymi liczbami,
# w przeciwnym przypadku zwraca 0.
function calcualateSpread(a :: Float64, b :: Float64)
    exponentA = SubString(bitstring(a), 2:12)
    exponentB = SubString(bitstring(prevfloat(b)), 2:12)
    
    if exponentA != exponentB
        return 0.0
    end

    exponent = parse(Int, exponentA, base = 2)
    
    return (2.0 ^ (exponent - 1023)) * (2.0 ^ (-52))
end

println("Spread for [0.5, 1]: ", calcualateSpread(0.5, 1.0))
println("Spread for [1, 2]: ", calcualateSpread(1.0, 2.0))
println("Spread for [2, 4]: ", calcualateSpread(2.0, 4.0))