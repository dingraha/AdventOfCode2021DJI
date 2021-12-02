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
            aim += dist
        elseif cmd == "up"
            aim -= dist
        end
    end
    return horiz*depth
end

function day02(data=day02_get_input())
    cmds, dists = data
    return day02_part1(cmds, dists), day02_part2(cmds, dists)
end

function day02_transducers_part1(cmds, dists)
    # function f(cmd, dist)
    #     if cmd == "forward"
    #         return (dist, 0)
    #     elseif cmd == "down"
    #         return (0, dist)
    #     elseif cmd == "up"
    #         return (0, -dist)
    #     end
    # end
    # foldxl(+, zip(cmds, dists) |> MapSplat(f) |> Scan((old,new)->(old[1]+new[1], old[2]+new[2]), (0,0)) |> TakeLast(1) |> MapSplat(*))
    function f(horiz_depth, cmd_dist)
        horiz, depth = horiz_depth
        cmd, dist = cmd_dist
        if cmd == "forward"
            horiz += dist
        elseif cmd == "down"
            depth += dist
        elseif cmd == "up"
            depth -= dist
        end
        return horiz, depth
    end
    return foldl(*, zip(cmds, dists) |> Scan(f, (0, 0)) |> TakeLast(1) |> Cat())
end

function day02_transducers_part2(cmds, dists)
    function f(horiz_depth_aim, cmd_dist)
        horiz, depth, aim = horiz_depth_aim
        cmd, dist = cmd_dist
        if cmd == "forward"
            horiz += dist
            depth += aim*dist
        elseif cmd == "down"
            aim += dist
        elseif cmd == "up"
            aim -= dist
        end
        return horiz, depth, aim
    end
    # Need TakeLast(1) to get the last position.
    # Cat() to convert the nested single tuple [(horiz, depth, aim)] to to just [horiz, depth, aim].
    # Then Take(2) to drop aim, just leaving horiz and depth to be multiplied by foldl(*, ...).
    return foldl(*, zip(cmds, dists) |> Scan(f, (0, 0, 0)) |> TakeLast(1) |> Cat() |> Take(2))
end

function day02_transducers(data=day02_get_input())
    cmds, dists = data
    return day02_transducers_part1(cmds, dists), day02_transducers_part2(cmds, dists)
end

