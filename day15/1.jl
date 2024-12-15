function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    grid = reduce(hcat, map(collect, lines)) |> permutedims
    H, W = size(grid)
    lines = readlines("input2")
    str = lines |> join
    return lines, str, grid, H, W
end

function movebox!(box, m, boxes, walls)
    new_box = (box[1]+m[1], box[2]+m[2])
    if new_box in walls
        return false
    elseif new_box in boxes
        if movebox!(new_box, m, boxes, walls)
            delete!(boxes, box)
            push!(boxes, new_box)
            return true
        else
            return false
        end
    else
        delete!(boxes, box)
        push!(boxes, new_box)
        return true
    end
end

function move(obj, m, boxes, walls, box=false)
    new_obj = (obj[1]+m[1], obj[2]+m[2])
    if new_obj in walls
        return obj
    elseif new_obj in boxes
        movebox!(new_obj, m, boxes, walls) && return new_obj
        return obj
    else
        return new_obj
    end
end

function sumboxes(boxes)
    res = 0
    for b in boxes
        res += (b[2]-1) + 100*(b[1]-1)
    end
    res
end

function show_status(robot, boxes, walls, H, W)
    for i in 1:H
        for j in 1:W
            if (i, j) == robot
                print('@')
            elseif (i, j) in boxes
                print('O')
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

function main(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    local robot
    boxes = Set{Tuple{Int, Int}}()
    walls = Set{Tuple{Int, Int}}()
    for i in 1:H, j in 1:W
        if grid[i, j] == '@'
            robot = (i, j)
        elseif grid[i, j] == 'O'
            push!(boxes, (i, j))
        elseif grid[i, j] == '#'
            push!(walls, (i, j))
        end
    end
    dir = Dict('>'=>(0, 1), '<'=>(0, -1), '^'=>(-1, 0), 'v'=>(1, 0))
    for m in str
        # show_status(robot, boxes, walls, H, W)
        robot = move(robot, dir[m], boxes, walls)
    end
    return sumboxes(boxes)
end

main(parse_input()...) |> println


