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

function numkeypad(start, goal)
    si, sj = NUMKEYPAD[start]
    gi, gj = NUMKEYPAD[goal]

    if si < gi && sj < gj
        (gi, sj) == (4, 1) && return ['>'^(gj-sj) * 'v'^(gi-si) * 'A']
        return ['v'^(gi-si) * '>'^(gj-sj) * 'A', '>'^(gj-sj) * 'v'^(gi-si) * 'A']
    end
    if si >= gi && sj < gj
        return ['^'^(si-gi) * '>'^(gj-sj) * 'A', '>'^(gj-sj) * '^'^(si-gi) * 'A']
    end
    if si < gi && sj >= gj
        return ['<'^(sj-gj) * 'v'^(gi-si) * 'A', 'v'^(gi-si) * '<'^(sj-gj) * 'A']
    end
    if si >= gi && sj >= gj
        (si, gj) == (4, 1) && return ['^'^(si-gi) * '<'^(sj-gj) * 'A']
        return ['<'^(sj-gj) * '^'^(si-gi) * 'A', '^'^(si-gi) * '<'^(sj-gj) * 'A']
    end

    return []
end

function dirkeypad(start, goal)
    si, sj = DIRKEYPAD[start]
    gi, gj = DIRKEYPAD[goal]

    if si > gi && sj < gj
        (gi, sj) == (1, 1) && return ['>'^(gj-sj) * '^'^(si-gi) * 'A']
        return ['>'^(gj-sj) * '^'^(si-gi) * 'A', '^'^(si-gi) * '>'^(gj-sj) * 'A']
    end
    if si <= gi && sj < gj
        return ['>'^(gj-sj) * 'v'^(gi-si) * 'A', 'v'^(gi-si) * '>'^(gj-sj) * 'A']
    end
    if si > gi && sj >= gj
        return ['<'^(sj-gj) * '^'^(si-gi) * 'A', '^'^(si-gi) * '<'^(sj-gj) * 'A']
    end
    if si <= gi && sj >= gj
        (si, gj) == (1, 1) && return ['v'^(sj-gj) * '<'^(gi-si) * 'A']
        return ['<'^(sj-gj) * 'v'^(gi-si) * 'A', 'v'^(gi-si) * '<'^(sj-gj) * 'A']
    end

    return []
end

function ntranslate(string)
    res = ""
    last = 'A'
    for char in string
        res *= numkeypad(last, char)[1] # only one path, turns out to be the
        last = char                     # shortest by sheer luck (or by design
    end                                 # (or math (or magic))) idc, it works
    return res
end

function dtranslate(string)
    res = ""
    last = 'A'
    for char in string
        res *= dirkeypad(last, char)[1] # only one path, turns out to be the
        last = char                     # shortest by sheer luck (or by design
    end                                 # (or math (or magic))) idc, it works
    return res
end

function complexity(string, code)
    regex = r"\d*"
    code = parse(Int, match(regex, code).match)
    return length(string) * code
end

function main(lines, str, grid, H, W)
    S = 0
    for line in lines
        str = line |> ntranslate |> dtranslate |> dtranslate
        S += complexity(str, line)
    end
    return S
end

main(parse_input()...) |> println

