parse_input() = parse.(Int, readlines("input"))

function process(secret)
    secret = secret ⊻ (secret << 6) & (2^24-1)
    secret = secret ⊻ (secret >> 5) & (2^24-1)
    secret = secret ⊻ (secret << 11) & (2^24-1)
    return secret
end

function gen_bananas(secret, n)
    bananas = Dict()
    last_four = [10, 10, 10, 10]
    c = 0
    s = secret%10
    for i in 1:n
        secret = process(secret)
        c = secret%10 - s
        s = secret%10
        deleteat!(last_four, 1)
        push!(last_four, c)
        get!(bananas, copy(last_four), s)
    end
    return bananas
end

function main(lines)
    bananas = Dict()
    for line in lines
        new = gen_bananas(line, 2000)
        for (k, v) in new
            10 in k && continue
            bananas[k] = get(bananas, k, 0) + v
        end
    end
    return maximum(values(bananas))
end

main(parse_input()) |> println


