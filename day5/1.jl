lines = readlines("input")

rules = []
pages = []
for line in lines
    global rules, pages
    m = match(r"(\d+)\|(\d+)", line)

    if m != nothing
        push!(rules, (parse(Int, m.captures[1]), parse(Int, m.captures[2])))
    elseif length(line) > 0
        push!(pages, split(line, ",") .|> x -> parse(Int, x))
    end
end

N = 0
correct = []
for page in pages
    global N, correct
    yep = true
    for rule in rules
        findfirst(x -> x == rule[1], page) != nothing || continue
        findfirst(x -> x == rule[2], page) != nothing || continue
        if findfirst(x -> x == rule[1], page) > findfirst(x -> x == rule[2], page)
            yep = false
            break
        end
    end
    N += Int(yep)
    yep && push!(correct, page)
end

res = 0
for c in correct
    global res
    length(c) % 2 == 0 && print("FUCK")
    res += c[length(c)÷2+1]
end

# println(correct)
println(res)

