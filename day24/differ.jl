function parse_input(lines=nothing, str=nothing, grid=nothing, W=nothing, H=nothing)
    lines = readlines("input")
    lines2 = readlines("input_C")
    str = lines |> join

    dif = []
    for (i, line) in enumerate(lines)
        if lines[i] != lines2[i]
            push!(dif, split(line, " ")[end])
        end
    end

    return dif
end

function main(dif)
    sort!(dif)
    return join(dif, ",")
end

main(parse_input()) |> println

