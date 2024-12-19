function parse_input()
    lines = readlines("input")
    return split(lines[1], ", "), lines[3:end]
end

cache = Dict{String, Int}(""=>1)

n_made(p, ts) = get!(cache, p) do
    sum(n_made(p[length(t)+1:end], ts) for t in ts if startswith(p, t); init=0)
end

# main(towels, patterns) = count(x -> n_made(x, towels)>0, patterns) # part 1
main(towels, patterns) = sum(x -> n_made(x, towels), patterns) # part 2

main(parse_input()...) |> println
