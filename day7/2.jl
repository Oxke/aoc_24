using Base.Iterators: product

lines = readlines("input")
str = lines |> join

# grid = reduce(hcat, map(collect, lines)) |> permutedims
# grid = reduce(hcat, map(x -> split(x, r":| "), lines)) |> permutedims

# H, W = size(grid)

lines = lines .|> x -> split(x, [':', ' '])

function gives_value(res, parts)
    n_op = length(parts) - 1

    for op in product(fill(["+", "*", "||"], n_op)...)
        res_ = parts[1]
        for i in 1:n_op
            if op[i] == "+"
                res_ += parts[i+1]
            elseif op[i] == "*"
                res_ *= parts[i+1]
            else
                res_ = 10^(floor(log10(parts[i+1])) + 1) * res_ + parts[i+1]
            end
        end
        if res_ == res
            # println(res_, " ", res)
            return true
        end
    end

    return false
end

N = 0
for (i, line) in enumerate(lines)
    global N
    res, _, parts... = line
    res = parse(Int, res)
    parts = parse.(Int, parts)

    gives_value(res, parts) && (N += res)
end

println(N)


