# Author: Lukasz Bratos

# Funkcja znajduje minimalna wartosc w przedziale [1, 2],
# ktora nie spelna rownania x * 1/x == 1 w arytmetyce zmiennopozycyjnej.
function betweenOneAndTwo()
    x = one(Float64)
    while nextfloat(x) * (one(Float64) / nextfloat(x)) == one(Float64) && x < 2.0
        x = nextfloat(x)
    end
    return nextfloat(x)
end

function theSmallestOne()
    x = zero(Float64)
    while nextfloat(x) * (one(Float64) / nextfloat(x)) == one(Float64)
        x = nextfloat(x)
    end
    return nextfloat(x)
end

println("The smallest number in [1, 2] that doesn't satisfy the quation x * 1/x = 1: ", betweenOneAndTwo())
println("The smallest number in [-inf, +inf] that doesn't satisfy the quation x * 1/x = 1: ", theSmallestOne())