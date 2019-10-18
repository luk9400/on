# Author: Lukasz Bratos

# Typy zmiennopozycyjne dla ktorych bedziemy wykonywac testy
types = [Float16, Float32, Float64]

# Funkcja przyjmuje typ zmiennopozycyjny i oblicza wartosc wyrazenia 3(4/3 - 1) - 1
function kahanEps(type)
    uno = one(type)
    return 3 * uno * (((4 * uno) / (3 * uno)) - uno) - uno
end

for type in types
    println("Calculated value of Khan's epsilon for $type: ", kahanEps(type), " vs eps($type): ", eps(type))
end

