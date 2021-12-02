function day02_get_input(input_fname=joinpath(@__DIR__, "input", "day02.txt"))
    data = readdlm(input_fname)
    cmds = Vector{String}(data[:, 1])
    dist = Vector{Int}(data[:, 2])
    return cmds, dist
end

function day02_part1(cmds, dists)
    horiz = 0
    depth = 0
    for (cmd, dist) in zip(cmds, dists)
        if cmd == "forward"
            horiz += dist
        elseif cmd == "down"
            depth += dist
        elseif cmd == "up"
            depth -= dist
        end
    end
    return horiz*depth
end

function day02_part2(cmds, dists)
    horiz = 0
    depth = 0
    aim = 0
    for (cmd, dist) in zip(cmds, dists)
        if cmd == "forward"
            horiz += dist
            depth += aim*dist
        elseif cmd == "down"
            # depth += dist
            aim += dist
        elseif cmd == "up"
            # depth -= dist
            aim -= dist
        end
    end
    return horiz*depth
end

function day02(data=day02_get_input())
    cmds, dists = data
    return day02_part1(cmds, dists), day02_part2(cmds, dists)
end
