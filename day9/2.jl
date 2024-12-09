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
            push!(v, ('.', n))
            empty = false
        else
            push!(v, (m, n))
            m += 1
            empty = true
        end
    end
    return v
end

# function compress(strin)
#     v = []
#     i, j = 1, length(strin)
#     while i <= j
#         c = strin[i]
#         if c == '.'
#             while strin[j] == '.'
#                 j -= 1
#                 j >= i || break
#             end
#             push!(v, strin[j])
#             j -= 1
#         else
#             push!(v, strin[i])
#         end
#         i += 1
#     end
#     return v
# end

function compress2(vec)
    v = []
    L = length(vec)
    i, j = 1, L
    while i <= j
        c, n = vec[i]
        if c == '.'
            while n > 0 && j > i
                while vec[j][1] == '.' || vec[j][2] > n
                    j -= 1
                    j > i || break
                end
                if j > i
                    push!(v, vec[j])
                    n -= vec[j][2]
                    vec[j] = ('.', vec[j][2])
                    j -= 1
                else
                    push!(v, ('.', n))
                    n = 0
                end
            end
            j = L
        else
            push!(v, vec[i])
        end
        i += 1
    end
    return v
end

function explain(vec)
    v = []
    for (c, n) in vec
        for _ in 1:n
            c == '.' ? push!(v, 0) : push!(v, c)
        end
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

str |> dec |> compress2 |> explain |> checksum |> println

