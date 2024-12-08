lines = readlines("input")
str = lines |> join

grid = reduce(hcat, map(collect, lines)) |> permutedims
# grid = reduce(hcat, map(split, lines)) |> permutedims

# grid = parse.(Int, grid)
H, W = size(grid)

# lines = lines .|> x -> split(x, [':', ' '])
# for line in lines
#     global N
#     res, _, parts... = line
#     res = parse(Int, res)
#     parts = parse.(Int, parts)
#
#     # DO STUFF
# end

antinodes = Set{Tuple{Int, Int}}()

for i1 in 1:H, j1 in 1:W
    grid[i1, j1] == '.' && continue
    for i2 in 1:H, j2 in 1:W
        grid[i2, j2] == '.' && continue
        if grid[i1, j1] == grid[i2, j2] && (i1, j1) != (i2, j2)
            for k in -W:W
                if 1<=i1 + k*(i1 - i2) <= H && 1<=j1 + k*(j1 - j2) <= W
                    push!(antinodes, (i1 + k*(i1 - i2), j1 + k*(j1 - j2)))
                end
            end
        end
    end
end

println(length(antinodes))
