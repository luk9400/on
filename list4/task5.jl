# Author: Lukasz Bratos

include("diff.jl")

f(x) = exp(x)
g(x) = x^2.0 * sin(x)

for i in [5, 10, 15]
    Diff.rysujNnfx(f, 0.0, 1.0, i, "plot5a$i")
    Diff.rysujNnfx(g, -1.0, 1.0, i, "plot5b$i")
end