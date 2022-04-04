function day09_get_input(input_fname=joinpath(@__DIR__, "input", "day09.txt"))
    rows = Vector{Vector{Int}}()
    for line in eachline(input_fname)
        push!(rows, parse.(Int, [c for c in line]))
    end
    return permutedims(hcat(rows...))
end

function day09_part1(heightmap)
    # Inspired by https://julialang.org/blog/2016/02/iteration/
    out = fill(true, size(heightmap))
    R = CartesianIndices(heightmap)
    Ifirst, Ilast = first(R), last(R)
    ishift, jshift = CartesianIndex(1, 0), CartesianIndex(0, 1)
    for I in CartesianIndices(heightmap)
        # So, I want to check left and right, up and down.
        for J in max(Ifirst, I-ishift):min(Ilast, I+ishift)
            if !(J == I)
                out[I] = out[I] && (heightmap[I] < heightmap[J])
            end
        end
        for J in max(Ifirst, I-jshift):min(Ilast, I+jshift)
            if !(J == I)
                out[I] = out[I] && (heightmap[I] < heightmap[J])
            end
        end
    end
    return sum(heightmap[out] .+ 1)
end

function day09_part2(heightmap)
    # OK, now, what I need to be able to do is to find a search path for each
    # location. And I also need to be able to tell which low point each point
    # belongs to. To keep track of basins, I could use a Matrix{CartesianIndex},
    # where the matrix holds the cartesian index of the low point. But when I
    # step through the map, I don't know which low point each point belongs to
    # until I find it. I'll just have to keep track of it, I guess. Or have a
    # dict that maps points to low points.
    N = ndims(heightmap)
    loc2lowpoint = Dict{CartesianIndex{N}, CartesianIndex{N}}()
    R = CartesianIndices(heightmap)
    Ifirst, Ilast = first(R), last(R)
    ishift, jshift = CartesianIndex(1, 0), CartesianIndex(0, 1)
    for I in R
        # First, check if the height is 9, and thus doesn't belong to a basin.
        heightmap[I] == 9 && continue

        # Also, if I is in the loc2lowpoint, then we don't need to do anything.
        I in keys(loc2lowpoint) && continue

        # But now what do I need to do? I need to be able

        found_lowpoint = false
        unknown_visited = Vector{CartesianIndex{N}}()
        J = I
        while !found_lowpoint
            # So, I want to check left and right, up and down.
            found_new_dir = false
            for K in flatten((max(Ifirst, J-ishift):min(Ilast, J+ishift), max(Ifirst, J-jshift):min(Ilast, J+jshift)))
                if heightmap[K] < heightmap[J]
                    # We found the point we need to head to.
                    found_new_dir = true
                    # Check if we know which low point K belongs to.
                    if K in keys(loc2lowpoint)
                        # We know heightmap[J] is not 9, and now we know that
                        # heightmap[K] is lower, so heightmap[J] belongs to the same
                        # low point as heightmap[K].
                        loc2lowpoint[J] = loc2lowpoint[K]
                    else
                        push!(unknown_visited, J)
                        # push!(unknown_visited, K)
                    end
                    # Now I've found a new search direction. I want to continue
                    # the process with a new K or something.
                    break
                end
            end
            # Did we find a search direction?
            if found_new_dir
                # We did, so repeat with the new point
                J = K
            else
                # We didn't, so this must be a low point
                found_lowpoint = true
            end
        end
    end

    return 0
end

function day09(input_fname=joinpath(@__DIR__, "input", "day09.txt"))
    heightmap = day09_get_input(input_fname)
    return day09_part1(heightmap), day09_part2(heightmap)
end
