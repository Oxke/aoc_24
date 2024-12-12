str = readlines("input") |> join
regex = r"(mul)\((\d+),(\d+)\)|(do)\(\)|(don't)\(\)"
sum = 0
token = true
for m in eachmatch(regex, str)
    global sum, token
    if token && m.captures[1] == "mul"
        sum += parse(Int, m.captures[2]) * parse(Int, m.captures[3])
    elseif m.captures[4] == "do"
        token = true
    elseif m.captures[5] == "don't"
        token = false
    end
end
println(sum)
