function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    str = lines |> join

    grid = reduce(hcat, map(collect, lines)) |> permutedims
    H, W = size(grid)

    reindeer = (0, 0)
    E = (0, 0)
    walls = Set()
    for i in 1:H, j in 1:W
        if grid[i, j] == 'S'
            reindeer = (i, j)
        elseif grid[i, j] == 'E'
            E = (i, j)
        elseif grid[i, j] == '#'
            push!(walls, (i, j))
        end
    end

    return reindeer, E, walls, H, W
end

function print_state(walls, best, H, W)
    for i in 1:H, j in 1:W
        print((i, j) in walls ? '#' : (i, j) in best ? 'O' : '.')
        j == W && println()
    end
end

function main(reindeer, E, walls, H, W)
    directions = [(0, 1), (0, -1), (1, 0), (-1, 0)]
    res = Inf
    cost = Dict{Tuple{Int, Int}, Int}()
    queue = [(reindeer, 0, (0, 0))]
    prevs = Dict{Tuple{Int, Int}, Tuple{Int, Int}}()
    while !isempty(queue)
        (i, j), d, prev = popfirst!(queue)
        last_dir = (i - prev[1], j - prev[2])
        for (di, dj) in directions
            new_i, new_j = i + di, j + dj
            pcost = get(cost, (new_i, new_j), Inf)
            nd = d + 1 + (last_dir == (0, 0) || (di, dj) == last_dir ? 0 : 1000)
            if new_i in 1:H && new_j in 1:W && (new_i, new_j) ∉ walls && pcost >= nd
                push!(queue, ((new_i, new_j), nd, (i, j)))
                cost[(new_i, new_j)] = nd
            end
        end
    end
    print(cost[E])
    best = Set([E])
    queue = [(E, 0, E)]
    cost2 = Dict(E => 0)
    while !isempty(queue)
        (i, j), d, prev = popfirst!(queue)
        last_dir = (i - prev[1], j - prev[2])
        if (cost[E] - d) in [cost[(i, j)], cost[(i, j)] + 1000] && prev in best
            push!(best, (i, j))
        end
        for (di, dj) in directions
            new_i, new_j = i + di, j + dj
            pcost = get(cost2, (new_i, new_j), Inf)
            nd = d + 1 + (last_dir == (0, 0) || (di, dj) == last_dir ? 0 : 1000)
            if new_i in 1:H && new_j in 1:W && (new_i, new_j) ∉ walls && pcost >= nd
                push!(queue, ((new_i, new_j), nd, (i, j)))
                cost2[(new_i, new_j)] = nd
            end
        end
    end
    print_state(walls, best, H, W)
    return length(best)
end

main(parse_input()...) |> println


