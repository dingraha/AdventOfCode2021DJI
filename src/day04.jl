function day04_get_input(input_fname=joinpath(@__DIR__, "input", "day04.txt"))
    draws = nothing
    boards = Vector{Matrix{Int64}}()
    open(input_fname, "r") do io
        draws = parse.(Int, split(readline(io), ','))

        while ! eof(io)
            # skip the blank line.
            @assert readline(io) == ""

            # Read the next card, which is 5 lines.
            lines = [parse.(Int, split(readline(io); keepempty=false)) for i in 1:5]
            # Now we have a Vector of Vector of Ints. Make it a matrix. First
            # make each line a row vector with reshape.
            lines = reshape.(lines, 1, :)
            # Now stack the row vectors vertically to make the board.
            board = vcat(lines...)

            # Board should be 5x5.
            @assert size(board) == (5, 5)

            # Save the board.
            push!(boards, board)
        end
    end
    return return draws, boards
end

function day04_part1(draws, boards)
    # OK, what if I step through each draws, replacing any matches with some
    # number, like 0. Then I'll check if any rows or columns sum to zero. Or
    # maybe I could just check if the determinate is zero? That must be true.
    for draw in draws
        for board in boards
            # Find all the entries in board equal to draw.
            mask = board .== draw
            # Set them to zero.
            board[mask] .= 0
            # Check if this board is solved.
            # What if there's a tie? I could save the winning boards in a
            # different list.
            if det(board) ≈ 0
                # We found the winning board.
                # Calculate and return the answer.
                return sum(board)*draw
            end
        end
    end
end

function day04_part2(draws, boards)
    # This time, I'll keep track of the order the boards win. 
    win_order = Vector{Int}()
    for draw in draws
        for (i, board) in enumerate(boards)
            # If this board has already won, skip it.
            if ! (i in win_order)
                # Find all the entries in board equal to draw.
                mask = board .== draw
                # Set them to zero.
                board[mask] .= 0
                # Check if this board is solved.
                # What if there's a tie? I could save the winning boards in a
                # different list.
                if det(board) ≈ 0
                    # We found a winning board.
                    # We don't want that one anymore.
                    # Save it as a winning board.
                    push!(win_order, i)
                end
            end
            # if win_order is now the same length as boards, then all the
            # boards have won. So calculate the score of the final board.
            if length(win_order) == length(boards)
                return sum(board)*draw
            end
        end
    end
end

function day04()
    draws, boards = day04_get_input()
    part1 = day04_part1(draws, boards)
    part2 = day04_part2(draws, boards)
    return part1, part2
end

