grid = reduce(hcat, map(collect, readlines("input")))
W = length(grid[1, :])
H = length(grid[:, 1])

function NW_SE(i, j)
    (i <= H - 3 && j <= H - 3) || return false
    all(grid[i+k, j+k] == "XMAS"[k+1] for k in 0:3)
end
function NE_SW(i, j)
    (i <= H - 3 && j >= 4) || return false
    all(grid[i+k, j-k] == "XMAS"[k+1] for k in 0:3)
end
function SE_NW(i, j)
    (i >= 4 && j <= W - 3) || return false
    all(grid[i-k, j+k] == "XMAS"[k+1] for k in 0:3)
end
function SW_NE(i, j)
    (i >= 4 && j >= 4) || return false
    all(grid[i-k, j-k] == "XMAS"[k+1] for k in 0:3)
end

N = 0
for i in 1:H, j in 1:W
    global N
    if grid[i, j] == 'X'
        j <= W - 3 && grid[i, j:j+3] |> join == "XMAS" && (N += 1)
        j >= 4 && grid[i, j-3:j] |> join == "SAMX" && (N += 1)
        i <= H - 3 && grid[i:i+3, j] |> join == "XMAS" && (N += 1)
        i >= 4 && grid[i-3:i, j] |> join == "SAMX" && (N += 1)
        NW_SE(i, j) && (N += 1)
        NE_SW(i, j) && (N += 1)
        SE_NW(i, j) && (N += 1)
        SW_NE(i, j) && (N += 1)
    end
end
println(N)

