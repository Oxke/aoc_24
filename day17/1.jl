function parse_input(part::Int)
    lines = readlines("input")

    program = []
    registers = Dict{Char, Int}()
    for line in lines
        line = split(line, " ")
        if line[1] == "Program:"
            program = split(line[2], ",") |> x -> parse.(Int, x)
        elseif line[1] == "Register"
            registers[line[2][1]] = parse(Int, line[3])
        end
    end

    part == 1 && return registers['A'], registers['B'], registers['C'], program
    part == 2 && return program, length(program)
end

function run_thing(A::Int, B::Int, C::Int, program::Vector{Int})
    outputs = []
    i = 1
    while i < length(program)
        opcode, literal = program[i:i+1]
        combo = literal in 4:6 ? [A, B, C][literal-3] : literal
        if opcode == 0
            A = A >>> combo
        elseif opcode == 1
            B = B ⊻ literal
        elseif opcode == 2
            B = combo % 8
        elseif opcode == 3
            A != 0 && (i = literal+1; continue)
        elseif opcode == 4
            B = B ⊻ C
        elseif opcode == 5
            push!(outputs, combo % 8)
        elseif opcode == 6
            B = A >>> combo
        elseif opcode == 7
            C = A >>> combo
        end
        i += 2
    end
    return outputs
end

# notice pattern in output, 8a keeps same output end, while values 0 through 7
# mod 8 change only the first element of output, going through all the values 0
# to 7
function match_pr(program::Vector{Int}, wrong::Int, a=0)
    wrong == 0 && return a
    for c in 0:7
        if run_thing(a<<3 + c, 0, 0, program) == program[wrong:end]
            ret = match_pr(program, wrong-1, a<<3 + c)
            ret != -1 && return ret
        end
    end
    return -1
end

# part 1
run_thing(parse_input(1)...) |> x -> join(x, ",") |> println

# part 2
match_pr(parse_input(2)...) |> println


