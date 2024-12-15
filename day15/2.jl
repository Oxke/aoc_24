function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    g = reduce(hcat, map(collect, lines)) |> permutedims
    H, W = size(g)
    robot = (0, 0)
    lboxes = Set{Tuple{Int, Int}}()
    rboxes = Set{Tuple{Int, Int}}()
    walls = Set{Tuple{Int, Int}}()
    for i in 1:H, j in 1:H
        if g[i, j] == '#'
            push!(walls, (i, 2j-1))
            push!(walls, (i, 2j))
        elseif g[i, j] == 'O'
            push!(lboxes, (i, 2j-1))
            push!(rboxes, (i, 2j))
        elseif g[i, j] == '@'
            robot = (i, 2j-1)
        end
    end
    lines = readlines("input2")
    str = lines |> join
    return str, robot, lboxes, rboxes, walls, H, 2W
end

function show_status(robot, lboxes, rboxes, walls, H, W)
    for i in 1:H
        for j in 1:W
            if (i, j) == robot
                print('@')
            elseif (i, j) in lboxes
                print('[')
            elseif (i, j) in rboxes
                print(']')
            elseif (i, j) in walls
                print('#')
            else
                print('.')
            end
        end
        println()
    end
    println()
end

function moveboxh!(box, m, lboxes, rboxes, walls, left=true)
    new_box = (box[1]+m[1], box[2]+m[2])
    if new_box in walls
        return false
    elseif new_box in lboxes ∪ rboxes
        if moveboxh!(new_box, m, lboxes, rboxes, walls, new_box in lboxes)
            left ? delete!(lboxes, box) : delete!(rboxes, box)
            left ? push!(lboxes, new_box) : push!(rboxes, new_box)
            return true
        else
            return false
        end
    else
        left ? delete!(lboxes, box) : delete!(rboxes, box)
        left ? push!(lboxes, new_box) : push!(rboxes, new_box)
        return true
    end
end

function moveh(obj, m, lboxes, rboxes, walls)
    new_obj = (obj[1]+m[1], obj[2]+m[2])
    if new_obj in walls
        return obj
    elseif new_obj in lboxes || new_obj in rboxes
        moveboxh!(new_obj, m, lboxes, rboxes, walls, new_obj in lboxes) && return new_obj
        return obj
    else
        return new_obj
    end
end

function move(robot, dir, lboxes, rboxes, walls)
    dir[1] == 0 && return moveh(robot, dir, lboxes, rboxes, walls)
    new_robot = (robot[1]+dir[1], robot[2]+dir[2])
    if new_robot in walls
        return robot
    end
    # BFS
    q = [robot]
    vis = [robot]
    while !isempty(q)
        r = popfirst!(q)
        cur = (r[1]+dir[1], r[2]+dir[2])
        if cur in lboxes
            push!(q, cur)
            push!(vis, cur)
            push!(q, (cur[1], cur[2]+1))
            push!(vis, (cur[1], cur[2]+1))
        elseif cur in rboxes
            push!(q, cur)
            push!(vis, cur)
            push!(q, (cur[1], cur[2]-1))
            push!(vis, (cur[1], cur[2]-1))
        end
        cur in walls && return robot
    end
    for thing in reverse(vis)
        if thing in lboxes
            delete!(lboxes, thing)
            push!(lboxes, (thing[1]+dir[1], thing[2]+dir[2]))
        elseif thing in rboxes
            delete!(rboxes, thing)
            push!(rboxes, (thing[1]+dir[1], thing[2]+dir[2]))
        end
    end
    return new_robot
end

function sumboxes(boxes)
    res = 0
    for b in boxes
        res += (b[2]-1) + 100*(b[1]-1)
    end
    res
end

function main(str, robot, lboxes, rboxes, walls, H, W)
    dir = Dict('>'=>(0, 1), '<'=>(0, -1), '^'=>(-1, 0), 'v'=>(1, 0))
    for m in str
        # show_status(robot, lboxes, rboxes, walls, H, W)
        robot = move(robot, dir[m], lboxes, rboxes, walls)
    end
    return sumboxes(lboxes)
end

main(parse_input()...) |> println

