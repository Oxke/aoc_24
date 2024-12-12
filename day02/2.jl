n_safe = 0

function test_line(list, to_del)
    to_del > 0 && deleteat!(list, to_del)
    list[1] == list[2] && return false
    if list[1] < list[2]
        for i in 2:length(list)
            0 < list[i] - list[i-1] <= 3 || return false
        end
    else
        for i in 2:length(list)
            0 < list[i-1] - list[i] <= 3 || return false
        end
    end
    return true
end

function test_safe(list)
    for i in 0:length(list)
        test_line(copy(list), i) && return true
    end
    return false
end

for line in eachline("input")
    global n_safe
    list = split(line, " ") .|> x -> parse(Int, x)
    test_safe(list) || continue
    n_safe += 1
end

println(n_safe)
