lines = readlines("input")
str = lines |> join

# grid = reduce(hcat, map(collect, lines)) |> permutedims
# grid = reduce(hcat, map(split, lines)) |> permutedims

# grid = parse.(Int, grid)
# H, W = size(grid)

# lines = lines .|> x -> split(x, [':', ' '])
# for line in lines
#     global N
#     res, _, parts... = line
#     res = parse(Int, res)
#     parts = parse.(Int, parts)
#
#     # DO STUFF
# end

function dec(strin)
    v = []
    empty = false
    m = 0
    for c in strin
        n = parse(Int, c)
        if empty
            for _ in 1:n
                push!(v, '.')
            end
            empty = false
        else
            for _ in 1:n
                push!(v, m)
            end
            m += 1
            empty = true
        end
    end
    return v
end

function compress(strin)
    v = []
    i, j = 1, length(strin)
    while i <= j
        c = strin[i]
        if c == '.'
            while strin[j] == '.'
                j -= 1
                j >= i || break
            end
            push!(v, strin[j])
            j -= 1
        else
            push!(v, strin[i])
        end
        i += 1
    end
    return v
end

function checksum(strin)
    n = 0
    for (i, c) in enumerate(strin)
        n += (i-1) * c
    end
    return n
end

println(checksum(compress(dec(str))))
