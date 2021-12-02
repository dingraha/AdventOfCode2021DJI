
function day01_get_input(input_fname=joinpath(@__DIR__, "input", "day01.txt"))
    data = readdlm(input_fname)
    # readdlm returns a matrix. Make it a vector.
    return data[:, 1]
end

function day01_part1(depths)
    # Is the depth increasing?
    is_increasing = depths[2:end] .> depths[1:end-1]
    # Get the answer to part 1
    ans_part1 = count(is_increasing)

    return ans_part1
end

function day01_part2(depths)
    # Now we want to do a sliding sum of groups of three values. Is there a
    # clever way to do that? I'd need to iterate over subarrays... Well, would
    # this help me?
    #   depths[1:3:length(depths)]
    # That gets me the first of each three. But they don't overlap. I want to
    # slide. So, in a loop, that would just be:
    sliding_avg = Vector{Float64}()
    for i in 1:length(depths)-2
        push!(sliding_avg, sum(depths[i:i+2]))
    end
    # Now I can use the same trick as part one.
    is_increasing = sliding_avg[2:end] .> sliding_avg[1:end-1]
    ans_part2 = count(is_increasing)

end

function day01(depths=day01_get_input())
    ans_part1 = day01_part1(depths)
    ans_part2 = day01_part2(depths)

    return ans_part1, ans_part2
end

function day01_transducers_part1(depths)
    # Part 1:
    # ans_part1 = depths |> Consecutive(2, 1) |> Map(xy->(xy[2]>xy[1])) |> count
    # ans_part1 = depths |> Consecutive(2, 1) |> MapSplat(<) |> count
    ans_part1 = foldxl(+, depths |> Consecutive(2, 1) |> MapSplat(<))
    return ans_part1
end

function day01_transducers_part2(depths)
    # Part 2:
    # ans_part2 = depths |> Consecutive(3, 1) |> Map(sum) |> Consecutive(2, 1) |> Map(xy->(xy[2]>xy[1])) |> count
    ans_part2 = foldxl(+, depths |> Consecutive(3, 1) |> MapSplat(+) |> Consecutive(2, 1) |> MapSplat(<))

    return ans_part2
end

function day01_transducers(depths=day01_get_input())
    ans_part1 = day01_transducers_part1(depths)
    ans_part2 = day01_transducers_part2(depths)
    return ans_part1, ans_part2
end
