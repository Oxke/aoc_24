str = readlines("input") |> join
regex = r"mul\((\d+),(\d+)\)"
sum = 0
for m in eachmatch(regex, str)
    global sum
    sum += parse(Int, m.captures[1]) * parse(Int, m.captures[2])
end
println(sum)
