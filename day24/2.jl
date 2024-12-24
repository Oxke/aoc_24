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

function get_num(wires, c::Char)
    N = 0
    for (k, v) in wires
        k[1] == c && (N += v * 2^parse(Int, k[2:3]))
    end
    return N
end


function evaluate!(wires, ops, causing=[])
    res = []
    for _ in 1:length(ops), op in ops
        if haskey(wires, op[1]) && haskey(wires, op[2]) && !haskey(wires, op[4])
            if op[4] in causing
                push!(res, op)
                push!(causing, op[1])
                push!(causing, op[2])
            end
            if op[3] == "AND"
                wires[op[4]] = wires[op[1]] & wires[op[2]]
            elseif op[3] == "OR"
                wires[op[4]] = wires[op[1]] | wires[op[2]]
            elseif op[3] == "XOR"
                wires[op[4]] = wires[op[1]] ⊻ wires[op[2]]
            end
        end
    end
    return get_num(wires, 'z'), res, causing
end

function base2(N)
    s = ""
    while N > 0
        s *= string(N % 2)
        N = N ÷ 2
    end
    return reverse(s)
end

function differ(a, b)
    res = []
    i = 0
    ceil(log2(a)) == ceil(log2(b)) || return "z = 0"
    while a > 0 && b > 0
        if a % 2 != b % 2
            push!(res, "z$i")
            println("z$i is ", b % 2, " instead of ", a % 2)
        end
        a ÷= 2; b ÷= 2
        i += 1
    end
    return res
end

function main(wires, ops)
    z = get_num(wires, 'x') + get_num(wires, 'y')
    # d = differ(z, evaluate!(copy(wires), ops)[1])
    # evaluate!(wires, ops, d)[2] |> length |> println
    return evaluate!(wires, ops)[1] - z
end

main(parse_input()...) |> println

