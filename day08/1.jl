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
            if 1 <= 2*i1 - i2 <= H && 1 <= 2*j1 - j2 <= W
                push!(antinodes, (2*i1 - i2, 2*j1 - j2))
            end
            if 1 <= 2*i2 - i1 <= H && 1 <= 2*j2 - j1 <= W
                push!(antinodes, (2*i2 - i1, 2*j2 - j1))
            end
        end
    end
end

println(length(antinodes))
