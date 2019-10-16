# Author: Lukasz Bratos

types = [Float16, Float32, Float64]

function macheps(type)
    x = one(type)
    while one(type) + x / 2 != one(type)
        x = x / 2
    end
    println("Calculated macheps for $type: $x vs eps($type): ", eps(type))
    return x
end

# for i in types
#     macheps(i)
# end

function eta(type)
    x = one(type)
    while x / 2 > 0
        x = x / 2
    end
    println("Calculated eta for $type: $x vs nextfloat($type(0.0)): ", nextfloat(type(0.0)))
    return x
end

# for i in types
#     eta(i)
# end

function maxFloat(type)
    x = one(type)
    while !isinf(x * 2)
        x *= 2 
    end
    println("Calculated MAX for $type: $x vs floatmax($type): ", floatmax(type))
    return x
end

for i in types
    maxFloat(i)
end