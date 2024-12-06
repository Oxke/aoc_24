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

function explore(ij, didj, ahi)
    seen = Set{Tuple{Int, Int}}()
    while 1 <= ij[1] <= H && 1 <= ij[2] <= W
        push!(seen, ij)
        chosen = (ij[1] + didj[1], ij[2] + didj[2])
        if chosen ∈ ahi
            didj = (didj[2], -didj[1])
        else
            ij = chosen
        end
    end
    return length(seen)
end

println(explore(ij, didj, ahi))
