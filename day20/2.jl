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

    return walls, H, W, start, goal
end

function h(a, b) # little hack: will use it for shortest path
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function Astar(walls, H, W, start, goal)
    explored = Set([start])
    dist = Dict(start => 0)
    hdist = Dict(start => h(start, goal))
    visited = Set()
    prev = Dict()

    while !isempty(explored)
        c = argmin(x -> get(hdist, x, Inf), explored)
        c == goal && return prev
        delete!(explored, c)
        push!(visited, c)
        for (di, dj) in [(0, -1), (0, 1), (-1, 0), (1, 0)]
            n = c[1] + di, c[2] + dj
            n in visited && continue
            if n[1] in 0:H && n[2] in 0:W && !(n in walls)
                nd = dist[c] + 1
                if nd < get(dist, n, Inf)
                    dist[n] = nd
                    hdist[n] = nd + h(n, goal)
                    push!(explored, n)
                    prev[n] = c
                end
            end
        end
    end

    return -1
end

function prev2path(prev, start, goal)
    prev == -1 && println("FUCK")
    path = []
    c = goal
    while c != start
        pushfirst!(path, c)
        c = prev[c]
    end
    pushfirst!(path, start)
    return path
end

function main(walls, H, W, start, goal)
    path = prev2path(Astar(walls, H, W, start, goal), start, goal)
    N = 0
    for i1 in 1:length(path), i2 in i1:length(path)
        d = h(path[i1], path[i2])
        d <= 20 && (i2 - i1) - d >= 100 && (N += 1)
    end
    return N
end

main(parse_input()...) |> println

