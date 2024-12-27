include("myGraphs.jl")

function parse_input(lines=nothing, str=nothing, grid=nothing, H=nothing, W=nothing)
    lines = readlines("input")
    G = SimpleGraph()
    vert_s2n = Dict{String, Int}()
    vert_n2s = Dict{Int, String}()
    for line in lines
        v1s, v2s = split(line, "-")
        if haskey(vert_s2n, v1s)
            v1n = vert_s2n[v1s]
        else
            add_vertex!(G)
            v1n = nv(G)
            vert_s2n[v1s] = v1n
            vert_n2s[v1n] = v1s
        end
        if haskey(vert_s2n, v2s)
            v2n = vert_s2n[v2s]
        else
            add_vertex!(G)
            v2n = nv(G)
            vert_s2n[v2s] = v2n
            vert_n2s[v2n] = v2s
        end
        add_edge!(G, v1n, v2n)
    end
    return G, vert_s2n, vert_n2s
end

function part1(G, vert_s2n, vert_n2s)
    triangles = cliques(G, 3)
    triangles = map(triangle -> sort([vert_n2s[v] for v in triangle]), triangles)
    count(t -> any(startswith('t'), t), triangles)
end

function part2(G, vert_s2n, vert_n2s)
    max_clique = sort(cliques(G, 0), by=length, rev=true)[1]
    sort!(max_clique, by=x->vert_n2s[x])
    join([vert_n2s[v] for v in max_clique], "-")
end

part1(parse_input()...) |> println
part2(parse_input()...) |> println

