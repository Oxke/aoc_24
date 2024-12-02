list1 = zeros(Int, 0)
list2 = zeros(Int, 0)

for line in eachline("input1")
    n1, n2 = split(line, "   ") .|> x -> parse(Int, x)
    insert!(list1, searchsortedfirst(list1, n1), n1)
    insert!(list2, searchsortedfirst(list2, n2), n2)
end

res = (list1 - list2 .|> abs) |> sum
println(res)
