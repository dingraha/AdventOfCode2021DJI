function day03_get_input(input_fname=joinpath(@__DIR__, "input", "day03.txt"))
    return readlines(input_fname)
end

function day03_part1(data)
    nrows = length(data)
    ncols = length(data[1])
    nzeros = zeros(Int, ncols)
    for row in data
        for (c, col) in enumerate(row)
            if col == '0'
                nzeros[c] += 1
            end
        end
    end

    gamma_vec = [nz > (nrows÷2) ? '0' : '1' for nz in nzeros]
    epsilon_vec = [b == '0' ? '1' : '0' for b in gamma_vec]
    gamma = parse(Int, String(gamma_vec); base=2)
    epsilon = parse(Int, String(epsilon_vec); base=2)
    return gamma*epsilon
end

function day03_part2(data)
    nrows = length(data)
    ncols = length(data[1])
    # So now I need to go through the input, looking for the row that matches
    # the most common values. I need to start with the left-most column.
    data_d = Dict(zip(1:nrows, data))

    # Step through each column, removing any rows that don't match.
    for c in 1:ncols
        # First, find the target value, which is the most common value in this
        # column.
        nzeros = 0
        for (k, row) in data_d
            if row[c] == '0'
                nzeros += 1
            end
        end
        nones = length(data_d) - nzeros
        target_val = nzeros > nones ? '0' : '1'
        for (k, row) in data_d
            if row[c] != target_val
                delete!(data_d, k)
            end
        end
        if length(data_d) == 1
            break
        end
    end
    @assert length(data_d) == 1

    k, ox_gen_str = first(data_d)
    ox_gen = parse(Int, ox_gen_str; base=2)

    data_d = Dict(zip(1:nrows, data))
    for c in 1:ncols
        # First, find the target value, which is the least common value in this
        # column.
        nzeros = 0
        for (k, row) in data_d
            if row[c] == '0'
                nzeros += 1
            end
        end
        nones = length(data_d) - nzeros
        target_val = nzeros > nones ? '1' : '0'
        for (k, row) in data_d
            if row[c] != target_val
                delete!(data_d, k)
            end
        end
        if length(data_d) == 1
            break
        end
    end
    @assert length(data_d) == 1

    k, co2_scrub_str = first(data_d)
    co2_scrub = parse(Int, co2_scrub_str; base=2)

    return ox_gen*co2_scrub
end

function day03(data=day03_get_input())
    return day03_part1(data), day03_part2(data)
end

function day03_part1_transducers(data)
    nrows = length(data)
    ncols = length(first(data))
    foo = data |> Scan(zeros(Int, ncols)) do nones, row
            for (i, c) in enumerate(row)
                if c == '1'
                    nones[i] += 1
                end
            end
            return nones 
        end |>
        TakeLast(1) |>
        Cat() |>
        Map(>(length(data)÷2)) |> collect
    return foo
end
