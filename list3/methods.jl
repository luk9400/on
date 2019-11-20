# Author: Lukasz Bratos

#module Methods

function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    fa = f(a)
    fb = f(b)
    e = b - a
    err = 0
    it = 0
    r = Float64(0.0)
    v = Float64(0.0)
    
    if sign(fa) == sign(fb)
        err = 1
        return (r, v, it, err)
    end

    while e > epsilon
        it += 1

        e = e / 2
        r = a + e
        v = f(r)

        if abs(e) < delta || abs(v) < epsilon
            return (r, v, it, err)
        end

        if sign(v) != sign(fa)
            b = r
            fb = v
        else
            a = r
            fa = v
        end
    end
end

function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)
    err = 0

    if abs(v) < epsilon
        # nie chce nawet myslec co to za blad
        err = 3
        return (x0, v, 0, err)
    end

    for k in 1:maxit

        if (pf(x0) < eps(Float64))
            # pochodna bliska zeru?
            err = 2
            return (x0, v, k, err)
        end

        x1 = x0 - v / pf(x0)
        v = f(x1)

        if abs(x1 - x0) < delta || abs(v) < epsilon
            return (x1, v, k, err)
        end

        x0 = x1
    end

    # nie osiagnieto wymaganej dokladnosci w maxit iteracji
    err = 1
    return (x0, v, maxit, err)
end

function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    fx0 = f(x0)
    fx1 = f(x1)
    err = 0

    for it in 1:maxit
        if abs(fx0) > abs(fx1)
            x0, x1 = x1, x0
            fx0, fx1 = fx1, fx0
        end

        s = (x1 - x0) / (fx1 - fx0)
        x1 = x0
        fx1 = fx0
        x0 = x0 - fx0 * s
        fx0 = f(x0)

        if abs(x1 - x0) < delta || abs(fx0) < epsilon
            return (x0, fx0, it, err)
        end
    end

    # nie osiagnieto wymaganej dokladnosci w maxit iteracji
    err = 1
    return (x0, fx0, maxit, err)
end

#end