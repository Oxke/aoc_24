function parse_input(lines=nothing, str=nothing, grid=nothing, W=nothing, H=nothing)
    lines = readlines("input")
    str = lines |> join

    wires = Dict{String, Bool}()
    ops = Vector()

    for line in lines
        if ':' in line
            wire, val = split(line, ": ")
            wires[wire] = parse(Bool, val)
        elseif '>' in line
            op = split(line, " ")
            ops = push!(ops, (op[1], op[3], op[2], op[5]))
        end
    end

    return wires, ops
end

function main(wires, ops)
    for _ in 1:length(ops), op in ops
        if haskey(wires, op[1]) && haskey(wires, op[2]) && !haskey(wires, op[4])
            if op[3] == "AND"
                wires[op[4]] = wires[op[1]] & wires[op[2]]
            elseif op[3] == "OR"
                wires[op[4]] = wires[op[1]] | wires[op[2]]
            elseif op[3] == "XOR"
                wires[op[4]] = wires[op[1]] ⊻ wires[op[2]]
            end
        end
    end
    N = 0
    for (k, v) in wires
        if k[1] == 'z'
            b = v * 2^parse(Int, k[2:3])
            N += b
        end
    end
    return N
end

main(parse_input()...) |> println

