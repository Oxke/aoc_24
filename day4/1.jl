grid = reduce(hcat, map(collect, readlines("input")))
W, H = size(grid)

N = 0
for i in 1:H, j in 1:W
    global N
    if grid[i, j] == 'X'
        for di in [-1, 0, 1], dj in [-1, 0, 1]
            1 <= i + 3di <= H && 1 <= j + 3dj <= W || continue
            if all(grid[i+k*di, j+k*dj] == "MAS"[k] for k in 1:3)
                N += 1
            end
        end
    end
end

println(N)
