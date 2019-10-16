# Author: Lukasz Bratos

function f(x :: Float64)
    return sqrt(x^2 + one(Float64)) - one(Float64)
end

function g(x :: Float64)
    return x^2 / (sqrt(x^2 + one(Float64)) + one(Float64))
end

println(f(0.000008), " vs ", g(0.000008))