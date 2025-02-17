using BenchmarkTools

include("1.jl")
part1 = @benchmark main(parse_input()...)

include("2v2.jl")
part2 = @benchmark main(parse_input()...)

open("1.txt", "w") do io
    show(io, "text/plain", part1)
end
open("2.txt", "w") do io
    show(io, "text/plain", part2)
end
