function day06_get_input(input_fname=joinpath(@__DIR__, "input", "day06.txt"))
    return readdlm(input_fname, ',', Int)[1, :]
end

function day06_part1(fish, num_days=80)
    for day in 1:num_days
        # First step, figure out which fish have a counter of zero.
        zfish = fish .== 0
        # Next step, substract 1 from all fish who don't have an age of zero.
        fish[.!zfish] .-= 1
        # Set to 6 all the fish that do have zero ages.
        fish[zfish] .= 6
        # Add all the new fish.
        nzfish = count(zfish)
        append!(fish, fill(8, nzfish))
    end
    return length(fish)
end

function day06_part2(fish, num_days=80)
    nf = OffsetArray(fill(0, 9), 0:8)
    for day in 1:num_days
        # First step, figure out which fish have a counter of zero.
        zfish = fish .== 0
        # Next step, substract 1 from all fish who don't have an age of zero.
        fish[.!zfish] .-= 1
        # Set to 6 all the fish that do have zero ages.
        fish[zfish] .= 6
        # Count how many new fish we need to add.
        nzfish = count(zfish)
        # The new value for fish with counter 8 will be the number of zero
        # fish in the original input, plus the number of zero new fish. But we
        # also need to save the original value for later, so put that in temp.
        nf[8], temp = nzfish + nf[0], nf[8]
        # Now, need to set the number of new 7 fish, which is the number of new 8
        # fish previously. And save the old number for later.
        nf[7], temp = temp, nf[7]
        nf[6], temp = temp, nf[6]
        nf[5], temp = temp, nf[5]
        nf[4], temp = temp, nf[4]
        nf[3], temp = temp, nf[3]
        nf[2], temp = temp, nf[2]
        nf[1], temp = temp, nf[1]
        nf[0], temp = temp, nf[0]
        # Now need to add the number of 0 new fish to the number of 6 new fish.
        nf[6] += temp
    end
    return length(fish) + sum(nf)
end

function day06(input_fname=joinpath(@__DIR__, "input", "day06.txt"))
    fish = day06_get_input(input_fname)
    return day06_part1(copy(fish)), day06_part2(copy(fish), 256)
end
