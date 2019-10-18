# Author: Lukasz Bratos

# Typy zmiennopozycyjne dla ktorych bedziemy wykonywac testy
types = [Float16, Float32, Float64]

# Funkcja wyznacza iteracyjnie epsilon maszynowy dla danego typu zmiennopozycyjnego.
function macheps(type)
    x = one(type)
    while one(type) + x / 2 != one(type)
        x = x / 2
    end
    return x
end

# Funkcja wyznacza iteracyjnie wartosc eta dla danego typy zmiennopozycyjnego.
function eta(type)
    x = one(type)
    while x / 2 > 0
        x = x / 2
    end
    return x
end

# Funkcja wyznacza iteracyjnie maksymalna wartosc dla danego typu zmiennopozycyjnego.
function maxFloat(type)
    x = one(type)
    while !isinf(x * 2)
        x *= 2 
    end
    y = x / 2
    while !isinf(x + y) && y >= 1.0
        x += y 
        y /= 2
    end
    return x
end

for type in types
    println("Calculated macheps for $type: ", macheps(type), " vs eps($type): ", eps(type))
    println("Calculated eta for $type: ", eta(type), " vs nextfloat($type): ", nextfloat(type(0.0)))
    println("Calculated MAX for $type: ", maxFloat(type), " vs floatmax($type): ", floatmax(type))
end