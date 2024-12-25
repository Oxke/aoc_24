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

GATES = Dict("AND" => &, "OR" => |, "XOR" => ⊻)

function get_num(wires, c::Char)
    N = 0
    for (k, v) in wires
        k[1] == c && (N += v * 2^parse(Int, k[2:3]))
    end
    return N
end

function main(wires, ops)
    for _ in 1:length(ops), op in ops
        if haskey(wires, op[1]) && haskey(wires, op[2]) && !haskey(wires, op[4])
            wires[op[4]] = GATES[op[3]](wires[op[1]], wires[op[2]])
        end
    end
    get_num(wires, 'z')
end

main(parse_input()...) |> println

