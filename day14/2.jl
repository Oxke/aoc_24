function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")

    lines = lines .|> x -> split(x, [',', ' ', '='])
    res = []
    for line in lines
        _, px, py, _, vx, vy = line
        px, py, vx, vy = parse.(Int, [px, py, vx, vy])
        push!(res, (px, py, vx, vy))
    end
    H = 103
    W = 101

    return res, H, W
end

function update(posvel, H, W)
    new_posvel = []
    for (px, py, vx, vy) in posvel
        push!(new_posvel, ((px + vx + W) % W, (py + vy + H) % H, vx, vy))
    end
    return new_posvel
end

function print_grid(posvel, H, W)
    grid = zeros(Int, W, H)
    for (px, py, _, _) in posvel
        grid[px+1, py+1] += 1
    end
    for i in 1:H
        for j in 1:W
            if grid[j, i] > 0
                print(grid[j, i])
            else
                print(".")
            end
        end
        println()
    end
end

function lcc(pos, point)
    cc = [point]
    i = 1
    while i <= length(cc)
        px, py = cc[i]
        for (dx, dy) in [(0,-1), (0, 1), (1, 0), (-1, 0)]
            nx, ny = px+dx, py+dy
            if (nx, ny) in pos && !((nx, ny) in cc)
                push!(cc, (nx, ny))
            end
        end
        i += 1
    end
    return Set(cc)
end

# function to check if there is a connected component of at least 20 points
# then probably it is not a coincidence
function bigcc(posvel)
    pos = Set{Tuple{Int, Int}}()
    for (px, py, _, _) in posvel
        push!(pos, (px, py))
    end
    for p in pos
        pcc = lcc(pos, p)
        length(pcc) >= 20 && return true
        setdiff!(pos, pcc)
    end
    return false
end

function main(posvel, H, W)
    for i in 1:1000000
        posvel = update(posvel, H, W)
        bigcc(posvel) && (print_grid(posvel, H, W); return i)
    end
    return "Niente alberi (o meglio niente agglomerati di roba)"
end

main(parse_input()...) |> println
