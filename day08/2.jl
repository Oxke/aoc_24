lines = readlines("input")
str = lines |> join

grid = reduce(hcat, map(collect, lines)) |> permutedims
H, W = size(grid)

antinodes = Set{Tuple{Int, Int}}()

for i1 in 1:H, j1 in 1:W
    grid[i1, j1] == '.' && continue
    for i2 in 1:H, j2 in 1:W
        grid[i2, j2] == '.' && continue
        if grid[i1, j1] == grid[i2, j2] && (i1, j1) != (i2, j2)
            for k in -W:W # W < H
                if 1<=i1 + k*(i1 - i2) <= H && 1<=j1 + k*(j1 - j2) <= W
                    push!(antinodes, (i1 + k*(i1 - i2), j1 + k*(j1 - j2)))
                end
            end
        end
    end
end

println(length(antinodes))
