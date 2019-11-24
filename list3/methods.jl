# Author: Lukasz Bratos

module Methods

export mbisekcji, mstycznych, msiecznych

"""
Funkcja rozwiazuje rownanie postaci f(x) = 0 metoda bisekcji.
function mbisekcji(f, a::Float64, b::Float64, delta::Float64, epsilon::Float64)
    Dane:
    f – funkcja f(x) zadana jako anonimowa funkcja,
    a, b – końce przedziału początkowego,
    delta, epsilon - dokładności obliczeń,
    Wyniki:
    (r, v, it, err) – czwórka, gdzie
    r – przybliżenie pierwiastka równania f(x) = 0,
    v – wartość f(r),
    it – liczba wykonanych iteracji,
    err – sygnalizacja błędu
        0 - brak błędu
        1 - funkcja nie zmienia znaku w przedziale [a,b]
"""
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

"""
Funkcja rozwiazuje rownanie postaci f(x) = 0 metoda Newtona (stycznych).
function mstycznych(f,pf,x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    Dane:
    f, pf– funkcją f(x) oraz pochodną f′(x) zadane jako anonimowe funkcje,
    x0 – przybliżenie początkowe,
    delta, epsilon – dokładności obliczeń,
    maxit – maksymalna dopuszczalna liczba iteracji,
    Wyniki:
    (r, v, it, err) – czwórka, gdzie
    r – przybliżenie pierwiastka równania f(x) = 0,
    v – wartość f(r),
    it – liczba wykonanych iteracji,
    err – sygnalizacja błędu
        0 - metoda zbieżna
        1 - nie osiągnięto wymaganej dokładności w maxit iteracji,
        2 - pochodna bliska zeru
"""
function mstycznych(f, pf, x0::Float64, delta::Float64, epsilon::Float64, maxit::Int)
    v = f(x0)
    err = 0

    if abs(v) < epsilon
        return (x0, v, 0, err)
    end

    for it in 1:maxit
        if abs(pf(x0)) < epsilon
            # pochodna bliska zeru
            err = 2
            return (x0, v, it, err)
        end

        x1 = x0 - v / pf(x0)
        v = f(x1)

        if abs(x1 - x0) < delta || abs(v) < epsilon
            return (x1, v, it, err)
        end

        x0 = x1
    end

    # nie osiagnieto wymaganej dokladnosci w maxit iteracji
    err = 1
    return (x0, v, maxit, err)
end

"""
Funkcja rozwiazuje rownanie postaci f(x) = 0 metoda siecznych.
function msiecznych(f, x0::Float64, x1::Float64, delta::Float64, epsilon::Float64,maxit::Int)
    Dane:
    f – funkcja f(x)zadana jako anonimowa funkcja,
    x0, x1 – przybliżenia początkowe,
    delta, epsilon – dokładności obliczeń,
    maxit – maksymalna dopuszczalna liczba iteracji,
    Wyniki:
    (r, v, it, err)– czwórka, gdzie
    r – przybliżenie pierwiastka równania f(x) = 0,
    v – wartość f(r),
    it – liczba wykonanych iteracji,
    err – sygnalizacja błędu
    0 - metoda zbieżna
    1 - nie osiągnięto wymaganej dokładności w maxit iteracji
"""
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

end