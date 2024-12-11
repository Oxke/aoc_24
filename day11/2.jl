lines = readlines("input")
str = lines |> join
str = str .|> x -> split(x, ' ')
str = parse.(Int, str)

stones = Dict{Int, Int}()
for stone in str
    stones[stone] = get(stones, stone, 0) + 1
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

for _ in 1:75 # part 1: 25, part 2: 75
    global stones
    stones = blink(stones)
end

stones |> values |> sum |> println

