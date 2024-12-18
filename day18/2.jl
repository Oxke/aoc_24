function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    str = lines |> join

    walls = Set()
    for line in lines[1:1024]
        i, j = split(line, ",") |> x -> parse.(Int, x)
        push!(walls, (i, j))
    end

    return walls, 70, 70, (0, 0), (70, 70), lines
end

function cc(walls, w, H, W)
    w in walls || return false
    vis = Set()
    stack = [w]
    while !isempty(stack)
        i, j = pop!(stack)
        (i, j) in vis && continue
        push!(vis, (i, j))
        (j == W || i == 0) && return true
        for di in -1:1, dj in -1:1
            ni, nj = i + di, j + dj
            (ni, nj) in walls && push!(stack, (ni, nj))
        end
    end
    return false
end

function cc_cut(walls, H, W)
    for i in 0:H
        cc(walls, (i, 0), H, W) && return true
    end
    return false
end

function main(walls, H, W, start, goal, lines)
    for line in lines[1025:end]
        i, j = split(line, ",") |> x -> parse.(Int, x)
        push!(walls, (i, j))
        cc_cut(walls, H, W) && return i, j
    end
end

main(parse_input()...) |> println

