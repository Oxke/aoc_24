using LinearAlgebra
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
        C = (C[1] + 10^13, C[2] + 10^13)

        M = [A[1] B[1]; A[2] B[2]]
        det = M[1, 1] * M[2, 2] - M[1, 2] * M[2, 1]
        det == 0 && println("ECCO CHE AVEVO RAGIONE")
        b = [C[1]; C[2]]

        (A[1] * C[2] - A[2] * C[1]) % det == 0 || continue
        (B[1] * C[2] - B[2] * C[1]) % det == 0 || continue

        res += M \ b ⋅ [3, 1]
    end
    return round(Int, res)
end

main(parse_input()...) |> println

