# import Pkg
# Pkg.add("IterTools")
using IterTools

grid = reduce(hcat, map(collect, readlines("input")))
W = length(grid[1, :])
H = length(grid[:, 1])

N = 0
for i in 1:H, j in 1:W
    global N
    if grid[i, j] == 'X'
        for (di, dj) in product([-1, 0, 1], [-1, 0, 1])
            1 <= i + 3di <= H && 1 <= j + 3dj <= W || continue
            if all(grid[i+k*di, j+k*dj] == "MAS"[k] for k in 1:3)
                N += 1
            end
        end
    end
end
println(N)

