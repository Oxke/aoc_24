function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    str = lines |> join
    res = []
    A = 0
    B = 0
    for line in lines
        line == "" && continue
        numb = parse.(Int, match.match for match in eachmatch(r"\d+", line))
        but = match(r"A:|B:|X", line).match
        but == "A:" && (A = (numb[1], numb[2]))
        but == "B:" && (B = (numb[1], numb[2]))
        but == "X" && push!(res, (A, B, (numb[1], numb[2])))
    end
    return res, str, grid, H, W
end

function main(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    res = 0
    for (A, B, C) in lines
        tokens = Inf

        d1 = gcdx(A[1], B[1])
        C[1] % d1[1] == 0 || continue
        d2 = gcdx(A[2], B[2])
        C[2] % d2[1] == 0 || continue
        A = (A[1] ÷ d1[1], A[2] ÷ d2[1])
        B = (B[1] ÷ d1[1], B[2] ÷ d2[1])
        C = (C[1] ÷ d1[1], C[2] ÷ d2[1])

        for x in 0:100
            for y in 0:100
                A[1] * x + B[1] * y > C[1] && break
                A[2] * x + B[2] * y > C[2] && break
                if A[1] * x + B[1] * y == C[1] && A[2] * x + B[2] * y == C[2]
                    tokens = Int(min(tokens, 3x + y))
                end
            end
        end
        tokens < Inf && (res += tokens)
    end
    return res
end

main(parse_input()...) |> println

