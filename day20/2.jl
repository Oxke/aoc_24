function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    str = lines |> join
    grid = reduce(hcat, map(collect, lines)) |> permutedims
    H, W = size(grid)

    start, goal = nothing, nothing
    walls = []

    for i in 1:H
        for j in 1:W
            if grid[i, j] == 'S'
                start = (i, j)
            elseif grid[i, j] == 'E'
                goal = (i, j)
            elseif grid[i, j] == '#'
                push!(walls, (i, j))
            end
        end
    end

    return walls, start, goal
end

function manhattan(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function dfs(walls, c, goal, prev=(0,0))
    c == goal && return [c]
    for (di, dj) in [(0, -1), (0, 1), (-1, 0), (1, 0)]
        (di, dj) == prev && continue
        n = c[1] + di, c[2] + dj
        n in walls && continue
        return [c, dfs(walls, n, goal, (-di, -dj))...]
    end
    return -1
end

function main(walls, start, goal)
    path = dfs(walls, start, goal)
    println("path is ", length(path), "ps long")
    part1 = 0
    part2 = 0
    for i1 in 1:length(path), i2 in i1:length(path)
        d = manhattan(path[i1], path[i2])
        if d <= 20 && (i2 - i1) - d >= 100
            part2 += 1
            d <= 2 && (part1 += 1)
        end
    end
    return part1, "\n", part2
end

main(parse_input()...) |> x -> println(x...)

