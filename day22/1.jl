parse_input() = parse.(Int, readlines("input"))

function process(secret)
    secret = secret ⊻ (secret << 6) & (2^24-1)
    secret = secret ⊻ (secret >> 5) & (2^24-1)
    secret = secret ⊻ (secret << 11) & (2^24-1)
    return secret
end

function gen_secrets(secret, n)
    for _ in 1:n
        secret = process(secret)
    end
    return secret
end

main(lines) = sum(gen_secrets(line, 2000) for line in lines; init=0)

main(parse_input()) |> println


