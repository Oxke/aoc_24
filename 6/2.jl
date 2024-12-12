lines = readlines("input")
str = lines |> join
grid = reduce(hcat, map(collect, lines)) |> permutedims
H, W = size(grid)

ahi = Set{Tuple{Int, Int}}()
didj = (-1, 0)

for i in 1:H, j in 1:W
    global ahi, ij
    if grid[i, j] == '#'
        push!(ahi, (i, j))
    elseif grid[i, j] == '^'
        ij = (i, j)
    end
end

function isloop(ij, didj, ahi, ahi2)
    history = Set{Tuple{Tuple{Int, Int}, Tuple{Int, Int}}}()
    while 1 <= ij[1] <= H && 1 <= ij[2] <= W
        (ij, didj) ∈ history && return true
        push!(history, (ij, didj))
        chosen = (ij[1] + didj[1], ij[2] + didj[2])
        if chosen ∈ ahi || chosen == ahi2
            didj = (didj[2], -didj[1])
        else
            ij = chosen
        end
    end
    global grid
    return false
end

N = 0
for i in 1:H, j in 1:W
    global ij, didj, ahi, N
    isloop(ij, didj, ahi, (i, j)) && (N += 1)
end

println(N)
