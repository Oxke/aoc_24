n_safe = 0

for line in eachline("input")
    global n_safe
    list = split(line, " ") .|> x -> parse(Int, x)
    list[1] == list[2] && continue
    if list[1] < list[2]
        for i in 2:length(list)
            0 < list[i] - list[i-1] <= 3 || @goto cont
        end
    else
        for i in 2:length(list)
            0 < list[i-1] - list[i] <= 3 || @goto cont
        end
    end
    n_safe += 1
    @label cont
end

println(n_safe)
