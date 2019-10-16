# Author: Lukasz Bratos

function f(x :: Float64)
    return sin(x) + cos(3 * x)
end

function derivativeOfF(x :: Float64)
    return cos(x) - 3 * sin(3 * x)
end

function derivative(func, x0, h)
    return (func(x0 + h) - func(x0)) / h
end