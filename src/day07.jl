function day07_get_input(input_fname=joinpath(@__DIR__, "input", "day07.txt"))
    return readdlm(input_fname, ',', Int)[1, :]
end

fuel(x, input) = sum(abs.(x .- input))

function day07_part1(input)
    pos_mean = sum(input)/length(input)
    pos_mean_int = round(Int, pos_mean)
    
    # pos_to_try = (pos_mean_int-200):(pos_mean_int+200)
    pos_to_try = minimum(input):maximum(input) # lol
    fuel_min, idx_min = findmin(fuel.(pos_to_try, Ref(input)))
    pos_min = pos_to_try[idx_min]
    return fuel_min
end

fuel_part2(x, input) = sum([sum(1:abs(y-x)) for y in input])

function day07_part2(input)
    pos_mean = sum(input)/length(input)
    pos_mean_int = round(Int, pos_mean)
    
    # pos_to_try = (pos_mean_int-200):(pos_mean_int+200)
    pos_to_try = minimum(input):maximum(input) # lol
    fuel_min, idx_min = findmin(fuel_part2.(pos_to_try, Ref(input)))
    pos_min = pos_to_try[idx_min]
    return fuel_min
end

function day07(input_fname=joinpath(@__DIR__, "input", "day07.txt"))
    pos = day07_get_input(input_fname)
    return day07_part1(pos), day07_part2(pos)
end
