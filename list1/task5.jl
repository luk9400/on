# Author: Lukasz Bratos

x64 = [2.718281828,-3.141592654,1.414213562,0.5772156649,0.3010299957]
y64 = [1486.2497,878366.9879,-22.37492,4773714.647,0.000185049]
x32 = map(a -> convert(Float32, a), x64)
y32 = map(a -> convert(Float32, a), y64)
answer = -1.00657107000000e-11

function forward(x, y, n)
    s = 0.0
    for i in 1:n
        s = s + x[i] * y[i]
    end
    return s
end

function backward(x, y, n)
    s = 0.0
    for i in reverse(1:n)
        s = s + x[i] * y[i]
    end
    return s
end

function fromTheBiggestToTheSmallest(x, y, type, n)
    partials = Array{type}(undef, 5)
    for i in 1:n
        partials[i] = x[i] * y[i]
    end

    pos = sort(filter(x -> x > 0, partials), rev=true)
    neg = sort(filter(x -> x < 0, partials))
    
    return foldl(+, pos) + foldl(+, neg)
end

println(fromTheBiggestToTheSmallest(x64, y64, Float64, 5))
println(fromTheBiggestToTheSmallest(x32, y32, Float32, 5))

function fromTheSmallestToTheBiggest(x, y, type, n)
    partials = Array{type}(undef, 5)
    for i in 1:n
        partials[i] = x[i] * y[i]
    end

    pos = sort(filter(x -> x > 0, partials))
    neg = sort(filter(x -> x < 0, partials), rev=true)
    
    return foldl(+, pos) + foldl(+, neg)
end

println(fromTheSmallestToTheBiggest(x64, y64, Float64, 5))
println(fromTheSmallestToTheBiggest(x32, y32, Float32, 5))