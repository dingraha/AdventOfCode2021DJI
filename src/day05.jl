function day05_get_input(input_fname=joinpath(@__DIR__, "input", "day05.txt"))
    pstarts = Vector{Vector{Int}}()
    pends = Vector{Vector{Int}}()
    
    open(input_fname, "r") do io
        for line in eachline(io)
            pstart_str, pend_str = split(line, "->")
            p1_str, p2_str = split(pstart_str, ",")
            p1, p2 = parse(Int, p1_str), parse(Int, p2_str)
            push!(pstarts, [p1, p2])
            p1_str, p2_str = split(pend_str, ",")
            p1, p2 = parse(Int, p1_str), parse(Int, p2_str)
            push!(pends, [p1, p2])
        end
    end
    # This will return a Matrix of size (2, length(pstarts)), etc..
    return reduce(hcat, pstarts), reduce(hcat, pends)
end

function day05_part1(pstarts, pends)
    @assert size(pstarts) == size(pends)
    nlines = size(pstarts, 2)
    # Find the limits of the grid we'll make. Maybe I should have made a
    # 4xnlines Matrix, but whatever.
    xmin, ymin = minimum(hcat(minimum(pstarts; dims=2), minimum(pends; dims=2)); dims=2)
    xmax, ymax = maximum(hcat(maximum(pstarts; dims=2), maximum(pends; dims=2)); dims=2)

    grid = OffsetArray(zeros(Int, xmax-xmin+1, ymax-ymin+1), xmin:xmax, ymin:ymax)
    for (pstart, pend) in zip(eachcol(pstarts), eachcol(pends))
        # So, only supposed to consider horizontal or vertical segments.
        # That means ones where either the x coordinate or y coordinate are the
        # same.
        if (pstart[1] == pend[1]) || (pstart[2] == pend[2])
            xmin, xmax = minmax(pstart[1], pend[1])
            ymin, ymax = minmax(pstart[2], pend[2])
            for I in CartesianIndices((xmin : xmax, ymin : ymax))
                grid[I] += 1
            end
        end
    end

    # Now, count the number of entries in grid that are greater than 2.
    return count(>=(2), grid)
end

function day05_part2(pstarts, pends)
    @assert size(pstarts) == size(pends)
    nlines = size(pstarts, 2)
    # Find the limits of the grid we'll make. Maybe I should have made a
    # 4xnlines Matrix, but whatever.
    xmin, ymin = minimum(hcat(minimum(pstarts; dims=2), minimum(pends; dims=2)); dims=2)
    xmax, ymax = maximum(hcat(maximum(pstarts; dims=2), maximum(pends; dims=2)); dims=2)

    grid = OffsetArray(zeros(Int, xmax-xmin+1, ymax-ymin+1), xmin:xmax, ymin:ymax)
    for (pstart, pend) in zip(eachcol(pstarts), eachcol(pends))
        # Now I want to also handle diagonal stuff.
        xmin, xmax = minmax(pstart[1], pend[1])
        ymin, ymax = minmax(pstart[2], pend[2])
        if (pstart[1] == pend[1]) || (pstart[2] == pend[2])
            for I in CartesianIndices((xmin : xmax, ymin : ymax))
                grid[I] += 1
            end
        else
            xoffset = pend[1] > pstart[1] ? 1 : -1
            yoffset = pend[2] > pstart[2] ? 1 : -1
            for (x, y) in zip(pstart[1]: xoffset : pend[1], pstart[2] : yoffset : pend[2])
                grid[x, y] += 1
            end
        end
    end

    # Now, count the number of entries in grid that are greater than 2.
    return count(>=(2), grid)
end

function day05(input_fname=joinpath(@__DIR__, "input", "day05.txt"))
    pstarts, pends = day05_get_input(input_fname)
    return day05_part1(pstarts, pends), day05_part2(pstarts, pends)
end

