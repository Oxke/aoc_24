function _intersect_sorted(array1::Vector{Int}, array2::Vector{Int})
    length(array2) == 0 && return Int[]
    result = Int[]
    i = 1
    for x in array1
        while array2[i] < x && i < length(array2)
            i += 1
        end
        array2[i] == x && push!(result, x)
    end
    return result
end

function intersect_sorted(arrays...; G=SimpleGraph())
    length(arrays) == 0 && return Vector(1:G.nv)
    length(arrays) == 1 && return arrays[1]
    _intersect_sorted(arrays[1], intersect_sorted(arrays[2:end]...))
end

function insert_sorted!(arr::Vector{Int}, x::Int)
    i = searchsortedfirst(arr, x)
    if i > length(arr) || arr[i] != x
        insert!(arr, i, x)
    end
    return arr
end

abstract type Graph end

nv(G::Graph) = G.nv
edges(G::Graph) = G.edges
conj_list(G::Graph) = G.conj_list

mutable struct UndirectedGraph <: Graph
    nv::Int
    edges::Vector{Tuple{Int,Int}}
    conj_list::Vector{Vector{Int}}
    directed::Bool
    UndirectedGraph(nv=0, edges=[], conj_list=[]) = new(nv, edges, conj_list, false)
end

function Base.show(io::IO, G::Graph)
    println(io, "Graph($(G.nv), $(length(G.edges)))")
end

function SimpleGraph(nv=0, edges=[], conj_list=[])
    if edges != []
        for (u,v) in edges
            push!(conj_list[u], v)
        end
    elseif conj_list != []
        for u in 1:nv, v in conj_list[u]
            push!(edges, (u,v))
        end
    end
    return UndirectedGraph(nv, edges, conj_list)
end

function add_vertex!(G::Graph, n=1)
    G.nv += n
    for _ in 1:n
        push!(G.conj_list, [])
    end
end

function add_edge!(G::Graph, u, v)
    push!(G.edges, (u,v))
    G.directed || push!(G.edges, (v,u))
    insert_sorted!(G.conj_list[u], v)
    G.directed || insert_sorted!(G.conj_list[v], u)
end

function extend_clique(clique::Vector{Int}, G::UndirectedGraph, k::Int)
    0 < length(clique) == k && return [clique]
    res = Vector{Int}[]
    for v in intersect_sorted(Vector(maximum(clique, init=1):G.nv), [G.conj_list[u] for u in clique]...; G)
    # for v in intersect_sorted([G.conj_list[u] for u in clique]...; G)
        res = Vector{Int}[res..., extend_clique([clique..., v], G, k)...]
    end
    0 == length(res) == k && return [clique]
    return res
end

function cliques(G::UndirectedGraph, k::Int)
    k >= 0 || error("wtf")
    k == 0 && return maximal_cliques(G)
    extend_clique(Int[], G, k)
end

function maximal_cliques(G::UndirectedGraph)
    res = Vector{Int}[]
    for v in 1:G.nv
        push!(res, sort(extend_clique([v], G, 0), by=length, rev=true)[1])
    end
    return res
end
