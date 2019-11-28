# Author: Lukasz Bratos

include("diff.jl")

f(x) = abs(x)
g(x) = 1.0 / (1.0 + x^2)
n = [5, 10, 15]

for i in [5, 10, 15]
    Diff.rysujNnfx(f, -1.0, 1.0, i)
    Diff.rysujNnfx(g, -5.0, 5.0, i)
end