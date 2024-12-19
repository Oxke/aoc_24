function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    str = lines |> join

    walls = []
    for line in lines
        i, j = split(line, ",") |> x -> parse.(Int, x)
        push!(walls, (i, j))
    end

    return walls, 70, 70, (0, 0), (70, 70)
end

function cc!(walls, w, H, W, vis)
    w in walls || return false
    stack = [w]
    while !isempty(stack)
        i, j = pop!(stack)
        (i, j) in vis && continue
        push!(vis, (i, j))
        (j == W || i == 0) && return true
        for dj in -1:1, di in 1:-1:-1
            ni, nj = i + di, j + dj
            (ni, nj) in walls && !((ni, nj) in vis) && push!(stack, (ni, nj))
        end
    end
    return false
end

function cc_cut(walls, H, W)
    vis = Set()
    for i in 0:H
        cc!(walls, (i, 0), H, W, vis) && return true
    end
    return false
end

function main(walls, H, W, start, goal)
    lo = 1025
    hi = length(walls)
    while lo < hi
        m = (lo + hi) ÷ 2
        if cc_cut(walls[1:m], H, W)
            hi = m
        else
            lo = m + 1
        end
    end
    return walls[lo]
end

main(parse_input()...) |> println

