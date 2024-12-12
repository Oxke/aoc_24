function parse_input(lines=nothing, str=nothing, grid=nothing)
    lines = readlines("input1")
    str = lines |> join
    grid = reduce(hcat, map(collect, lines)) |> permutedims
    H, W = size(grid)
    return lines, str, grid
end

function rborder(border)
    nborder = Set{Tuple{Int, Int, Int, Int}}()
    y, x, dy, dx = pop!(border)
    L = 1
    while !isempty(border)
        found = false
        println(length(border))
        for (di, dj) in [(0, 1), (0, -1), (1, 0), (-1, 0)]
            found && break
            ny, nx = y + di, x + dj
            for (ndy, ndx) in [(0, 1), (0, -1), (1, 0), (-1, 0)]
                if (ny, nx, ndy, ndx) ∈ border
                    delete!(border, (ny, nx, ndy, ndx))
                    L += 1
                    dy == ndy && dx == ndx && (L -= 1)
                    y, x, dy, dx = ny, nx, ndy, ndx
                    found = true
                    break
                end
            end
        end
    end
    return L
end

function cc(grid, point)
    H, W = size(grid)
    plant = grid[point...]
    vec_interior = Vector{Tuple{Int, Int}}()
    border = Set{Tuple{Int, Int, Int, Int}}()

    push!(vec_interior, point)
    i = 1
    while i <= length(vec_interior)
        cy, cx = vec_interior[i]
        new = false
        degree = 0
        for (dy, dx) in [(0, 1), (0, -1), (1, 0), (-1, 0)]
            ny, nx = cy + dy, cx + dx
            if 1 <= ny <= H && 1 <= nx <= W && grid[ny, nx] == plant
                (ny, nx) ∈ vec_interior || push!(vec_interior, (ny, nx))
            else
                push!(border, (cy, cx, dy, dx))
            end
        end
        i += 1
    end

    return Set(vec_interior), border, plant
end

function main(lines=nothing, str=nothing, grid=nothing)
    H, W = size(grid)
    points = Set{Tuple{Int, Int}}()
    for y in 1:H, x in 1:W
        if 1 <= y <= H && 1 <= x <= W
            push!(points, (y, x))
        end
    end
    res = 0
    while !isempty(points)
        point = pop!(points)
        interior, border, plant = cc(grid, point)
        points = setdiff(points, interior)
        println(plant, ": ", length(interior), " x ", rborder(border))
    end
    res
end

main(parse_input()...) |> println

