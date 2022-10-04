#
# Program that finds the maximum clique - Parallelized with Threads
#
#
# Finding the maximum clique in a graph
# The graph is read as an adjacency matrix
#

function isClique(adjMatrix::Array{Base.Int64,2},candidate,n)

    possibleClique = zeros(Int8,n)	
    powerOf2 = 1 
    for i = 1:n
        if (candidate & powerOf2 != 0) 
            possibleClique[i] = 1
        end
        powerOf2 = powerOf2 * 2
    end
    for i in 1:n
        for j in 1:n
            if i!=j &&
	    possibleClique[i] == 1 &&
	    possibleClique[j] == 1 &&
	    adjMatrix[i,j] == 0
                return false
            end
        end
    end
    return true
end

#
# Print the actual vertices in the max clique
#
function printMaxClique(maxClique,n)
    print("The vertices in the max clique are: ")
    powerOf2 = 1 
    for i = 1:n
        if (maxClique & powerOf2 != 0) 
            print(i," ")
        end
        powerOf2 = powerOf2 * 2
    end
    println()
end

function main()
    # Read the number of vertices in the graph
    nString = readline()
    n = tryparse(Base.Int64,nString)
    println("n is: ",n)

    # Allocate the adjacency matrix
    adjMatrix = zeros(Int64,n,n)
    # Read the lines from the file that containst the adjacency matrix
    for i = 1:n
        values = zeros(Int64,n)
        values = [parse(Base.Int64, x) for x in split(readline())]
        #println(values)
        for j = 1:n
             adjMatrix[i,j]  =  values[j]
        end
    end

    # Print the adjacency matrix
    for i = 1:n
        for j = 1:n
            print(adjMatrix[i,j]," ")
        end
        println()
    end
    possibleSubSets = 2^(n) - 1
    println("Number of possible subsets: ",possibleSubSets)
    # setOfSolutions = Set()
    # setOfAllCliques = Set()

    maxCliqueSize = 1
    maxCliqueCode = 1
    setLock = ReentrantLock()
    Threads.@threads for i = 1:possibleSubSets 
        if isClique(adjMatrix,i,n) 
            lock(setLock)
            try
                # push!(setOfAllCliques,i)
                if count_ones(i) > maxCliqueSize
                    maxCliqueSize = count_ones(i)
                    maxCliqueCode = i
                end
            finally
                unlock(setLock)
            end
        end
    end
    # println("Set of all cliques: ",setOfAllCliques)
    println("Size of max clique: ",maxCliqueSize)
    println("The code for the max clique is: ",maxCliqueCode)
    printMaxClique(maxCliqueCode,n)
    

end

#print("Elapsed time: ",@elapsed main()," seconds.")
@time main()