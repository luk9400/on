# Author: Lukasz Bratos

# import Pkg
# Pkg.add("Polynomials")
using Polynomials

# wspolczynniki wielomianu
p = [1, -210.0, 20615.0,-1256850.0, 53327946.0,-1672280820.0, 40171771630.0, 
    -756111184500.0, 11310276995381.0, -135585182899530.0, 1307535010540395.0, 
    -10142299865511450.0, 63030812099294896.0, -311333643161390640.0,
    1206647803780373360.0, -3599979517947607200.0, 8037811822645051776.0, 
    -12870931245150988800.0, 13803759753640704000.0, -8752948036761600000.0,
    2432902008176640000.0]

# wspolczynniki postaci iloczynowej
p_roots = [x for x in 1.0:20.0]
println(p_roots)

# wspolczynniki zmodyfikowanego wielomianu
p_mod = [1, -210.0 - 2 ^ -23, 20615.0,-1256850.0, 53327946.0,-1672280820.0, 40171771630.0, 
-756111184500.0, 11310276995381.0, -135585182899530.0, 1307535010540395.0, 
-10142299865511450.0, 63030812099294896.0, -311333643161390640.0,
1206647803780373360.0, -3599979517947607200.0, 8037811822645051776.0, 
-12870931245150988800.0, 13803759753640704000.0, -8752948036761600000.0,
2432902008176640000.0]

# wielomianu w postaci normalnej
A = Poly(reverse(p))
# wielomian w postaci iloczynowej
B = poly(p_roots)
# zmodyfikowany wielomian w postaci normalnej
C = Poly(reverse(p_mod))

# pierwiastki wielomianow
A_roots = reverse(roots(A))
C_roots = reverse(roots(C))

for i in 1:20
    println("$i & $(A_roots[i]) & $(abs(polyval(A, A_roots[i]))) & $(abs(polyval(B, A_roots[i]))) & ", abs(A_roots[i] - i), " \\\\ \\hline")
end

for i in 1:20
    println("$i & $(C_roots[i]) & $(abs(polyval(C, C_roots[i]))) & ", abs(C_roots[i] - i), " \\\\ \\hline")
end