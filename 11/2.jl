function parse_input()
    lines = readlines("input")
    str = lines |> join .|> x -> split(x, ' ')
    str = parse.(Int, str)
    stones = Dict{Int, Int}()
    for stone in str
        stones[stone] = get(stones, stone, 0) + 1
    end
    return stones
end

function blink(stones)
    b_stones = Dict{Int, Int}()
    for (stone, count) in stones
        nd = ndigits(stone)
        if stone == 0
            b_stones[1] = get(b_stones, 1, 0) + count
        elseif nd % 2 == 0
            b_stones[stone ÷ 10^(nd ÷ 2)] = get(b_stones, stone ÷ 10^(nd ÷ 2), 0) + count
            b_stones[stone % 10^(nd ÷ 2)] = get(b_stones, stone % 10^(nd ÷ 2), 0) + count
        else
            b_stones[2024*stone] = get(b_stones, 2024*stone, 0) + count
        end
    end
    return b_stones
end

function main(N, stones)
    for _ in 1:N # part 1: 25, part 2: 75
        stones = blink(stones)
    end
    stones |> values |> sum
end

main(75, parse_input()) |> println
