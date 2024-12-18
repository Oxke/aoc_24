function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    str = lines |> join

    walls = Set()
    for line in lines[1:1024]
        i, j = split(line, ",") |> x -> parse.(Int, x)
        push!(walls, (i, j))
    end

    return walls, 70, 70, (0, 0), (70, 70)
end

function h(a, b)
    return abs(a[1] - b[1]) + abs(a[2] - b[2])
end

function main(walls, H, W, start, goal)
    explored = Set([start])
    dist = Dict(start => 0)
    hdist = Dict(start => h(start, goal))
    visited = Set()

    while !isempty(explored)
        c = argmin(x -> get(hdist, x, Inf), explored)
        c == goal && return dist[goal]
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
                end
            end
        end
    end

    return -1
end

main(parse_input()...) |> println

