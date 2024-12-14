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

function safety(posvel, H, W)
    MY = (H-1) ÷ 2
    MX = (W-1) ÷ 2
    grid = zeros(Int, 2, 2)
    for (px, py, _, _) in posvel
        (px != MX && py != MY) || continue
        grid[Int(px > MX) + 1, Int(py > MY) + 1] += 1
    end
    return prod(grid)
end

function main(posvel, H, W)
    for _ in 1:100
        posvel = update(posvel, H, W)
    end
    return safety(posvel, H, W)
end

main(parse_input()...) |> println
