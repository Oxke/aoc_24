using Combinatorics

function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    str = lines |> join
    return lines, str, grid, H, W
end

NUMKEYPAD = Dict(
    '1' => (3, 1),
    '2' => (3, 2),
    '3' => (3, 3),
    '4' => (2, 1),
    '5' => (2, 2),
    '6' => (2, 3),
    '7' => (1, 1),
    '8' => (1, 2),
    '9' => (1, 3),
    '0' => (4, 2),
    'A' => (4, 3))

DIRKEYPAD = Dict(
    '^' => (1, 2),
    '<' => (2, 1),
    '>' => (2, 3),
    'v' => (2, 2),
    'A' => (1, 3))

function nextcell(cur, m)
    i, j = cur
    if m == '^'
        return (i-1, j)
    elseif m == 'v'
        return (i+1, j)
    elseif m == '<'
        return (i, j-1)
    elseif m == '>'
        return (i, j+1)
    end
end

function keypad((si, sj), (gi, gj), avoid)
    s = ""
    (di, dj) = (gi-si, gj-sj)
    s *= di > 0 ? 'v'^di : '^'^(abs(di))
    s *= dj > 0 ? '>'^dj : '<'^(abs(dj))

    res = []
    for p in permutations(s)
        cell = (si, sj)
        ok = true
        for m in p
            cell = nextcell(cell, m)
            cell == avoid && (ok = false; break)
        end
        ok && push!(res, join(p) * 'A')
    end
    return res
end

memo = Dict()

shortest(s, stop=26, level=stop) = get!(memo, (s, level)) do
    res = 0
    last = level == stop ? NUMKEYPAD['A'] : DIRKEYPAD['A']
    avoid = level == stop ? (4, 1) : (1, 1)
    for c in s
        cd = level == stop ? NUMKEYPAD[c] : DIRKEYPAD[c]
        ms = keypad(last, cd, avoid)
        if level == 0
            res += length(ms[1])
        else
            res += minimum(shortest(m, stop, level-1) for m in ms)
        end
        last = cd
    end
    return res
end

complexity(l, code) = l * parse(Int, code[1:3])

function main(lines, str, grid, H, W)
    S = 0
    for line in lines
        lstr = shortest(line, 25)
        S += complexity(lstr, line)
    end
    return S
end

main(parse_input()...) |> println

