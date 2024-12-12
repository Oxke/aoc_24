function parse_input(lines=nothing, str=nothing, grid=nothing)
    lines = readlines("input")
    str = lines |> join
    grid = reduce(hcat, map(collect, lines)) |> permutedims
    H, W = size(grid)
    return lines, str, grid
end

function cc_border(border, point)
    res = Vector{Tuple{Int, Int}}()
    push!(res, point)
    i = 1
    while i <= length(res)
        cy, cx = res[i]
        for d in [-3, 3]
            ny = cy%3==0 ? cy + d : cy
            nx = cx%3==0 ? cx + d : cx
            if (ny, nx) ∈ border
                (ny, nx) ∈ res || push!(res, (ny, nx))
            end
        end
        i += 1
    end
    return Set(res)
end

function rborder(border)
    n = 0
    while !isempty(border)
        n += 1
        point = pop!(border)
        ccb = cc_border(border, point)
        border = setdiff(border, ccb)
    end
    return n
end

function cc(grid, point)
    H, W = size(grid)
    plant = grid[point...]
    vec_interior = Vector{Tuple{Int, Int}}()
    border = Set{Tuple{Int, Int}}()

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
                push!(border, (3cy+dy, 3cx+dx))
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
        res += length(interior) * rborder(border)
    end
    res
end

main(parse_input()...) |> println

