list1 = zeros(Int, 0)
list2 = zeros(Int, 0)

for line in eachline("input1")
    n1, n2 = split(line, "   ") .|> x -> parse(Int, x)
    insert!(list1, searchsortedfirst(list1, n1), n1)
    insert!(list2, searchsortedfirst(list2, n2), n2)
end

res = 0
for n1 in list1
    global res
    n = searchsortedlast(list2, n1) - searchsortedfirst(list2, n1) + 1
    # splice!(list2, 1:searchsortedlast(list2, n1))
    res += n * n1
    # println(res, " += ", n, " * ", n1)
end

println(res)




