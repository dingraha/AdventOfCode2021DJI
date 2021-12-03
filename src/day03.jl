function day03_get_input(input_fname=joinpath(@__DIR__, "input", "day03.txt"))
    # return parse.(Int, eachline(input_fname); base=2)
    # return readlines(input_fname)
    lines = readlines(input_fname)
    nrows = length(lines)
    ncols = length(lines[1])
    data = Matrix{Char}(undef, nrows, ncols)
    for row in 1:nrows
        line = lines[row]
        for col in 1:ncols
            data[row, col] = line[col]
        end
    end
    return data
end


function day03_part1(data)
    # ans = 1
    # for col in size(data, 2):-1:1
    #     nzeros = count(x-x=='0', data, di
    # First get the number of zeros in each column.

    # Hmm... there's an even number of lines in the input. What happens if
    # there's the same number of 0s and 1s in a column?
    nrows = size(data, 1)
    gamma_vec = [nzeros>(nrows÷2) ? '0' : '1' for nzeros in count(b->b=='0', data, dims=1)]
    epsilon_vec = [b == '0' ? '1' : '0' for b in gamma_vec]
    # Now I need to turn that Matrix of Chars into a string somehow, and then a
    # decimal Int.
    gamma = parse(Int, String(gamma_vec[1, :]); base=2)
    epsilon = parse(Int, String(epsilon_vec[1, :]); base=2)
    return gamma*epsilon
end

function day03_part2(data)
    return 0
end

function day03(data=day03_get_input())
    return day03_part1(data), day03_part2(data)
end
