function parse_input(lines=nothing, str=nothing, grid=nothing, W=nothing, H=nothing)
    lines = readlines("input")
    keys = []; locks = []
    for i in 1:8:length(lines)
        grid = reduce(hcat, map(collect, lines[i:i+6])) |> permutedims
        grid = Int.(grid)
        grid[1, 1] == 46 && push!(keys, grid)
        grid[1, 1] == 35 && push!(locks, grid)
    end
    return keys, locks
end

function main(keys, locks)
    N = 0
    for key in keys, lock in locks
        minimum(key + lock) > 70 && (N += 1)
    end
    return N
end

main(parse_input()...) |> println

