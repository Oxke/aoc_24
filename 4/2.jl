W = readlines("input")

N = 0
for i = 2:length(W)-1, j = 2:length(W[1])-1
    global N
    if W[i][j] == 'A'
        if [W[i-1][j-1], W[i+1][j+1], W[i-1][j+1], W[i+1][j-1]] ⊆ ['M', 'S']
            W[i-1][j-1] != W[i+1][j+1] && W[i-1][j+1] != W[i+1][j-1] && (N += 1)
        end
    end
end

println(N)
