lines = readlines("input")
str = lines |> join
str = str .|> x -> split(x, ' ')
str = parse.(Int, str)

function update(str)
    v = []
    for stone in str
        nd = ndigits(stone)
        if stone == 0
            push!(v, 1)
        elseif nd % 2 == 0
            push!(v, stone ÷ 10^(nd ÷ 2))
            push!(v, stone % 10^(nd ÷ 2))
        else
            push!(v, 2024*stone)
        end
    end
    return v
end


for i in 1:25
    global str
    str = update(str)
end

println(length(str))

