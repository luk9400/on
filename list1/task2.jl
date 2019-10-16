# Author: Lukasz Bratos

types = [Float16, Float32, Float64]

function kahanEps(type)
    uno = one(type)
    return 3 * uno * (((4 * uno) / (3 * uno)) - uno) - uno
end

for i in types
    println(kahanEps(i), " vs ", eps(i))
end

