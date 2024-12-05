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

wrong = []
err = true
while err
    global err
    for page in pages
        global N, wrong
        err = false
        for rule in rules
            e1 = findfirst(x -> x == rule[1], page)
            e2 = findfirst(x -> x == rule[2], page)
            e1 != nothing || continue
            e2 != nothing || continue
            if e1 > e2
                err = true
                page[e1], page[e2] = page[e2], page[e1]
            end
        end
        err && push!(wrong, page)
    end
end

srted = []
i = length(wrong)
while i >= 1
    global i, sorted, wrong
    s = sort(wrong[i])
    if s in srted
        deleteat!(wrong, i)
    else
        push!(srted, s)
    end
    i -= 1
end

res = 0
for c in wrong
    global res
    # c = weird_sort(c)
    length(c) % 2 == 0 && print("FUCK")
    res += c[length(c)÷2+1]
end

println(res)

