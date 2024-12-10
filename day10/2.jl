lines = readlines("input")
str = lines |> join

grid = reduce(hcat, map(collect, lines)) |> permutedims

grid = parse.(Int, grid)
H, W = size(grid)

zeros = Set{Tuple{Int, Int}}()

for i in 1:H, j in 1:H
    if grid[i, j] == 0
        push!(zeros, (i, j))
    end
end

function score(th::Tuple{Int, Int}, n::Int)
    n == 9 && return 1
    res = 0
    for (di, dj) in [(0, 1), (1, 0), (-1, 0), (0, -1)]
        1 <= th[1] + di <= H && 1 <= th[2] + dj <= W || continue
        if grid[th[1] + di, th[2] + dj] == n + 1
            res += score((th[1] + di, th[2] + dj), n + 1)
        end
    end
    return res
end

N = 0
for head in zeros
    global N
    N += score(head, 0)
end

println(N)


