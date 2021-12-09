function day08_get_input(input_fname=joinpath(@__DIR__, "input", "day08.txt"))
    patterns, outs = Vector{Vector{String}}(), Vector{Vector{String}}()
    for line in eachline(input_fname)
        l, r = split(line, "|")
        push!(patterns, split(l, keepempty=false))
        push!(outs, split(r, keepempty=false))
    end
    return patterns, outs
end

function day08_part1(patterns, outs)
    c = 0
    lens = [2, 3, 4, 7]
    for out in outs
        for l in lens
            c += count(x->length(x)==l, out)
        end
    end
    return c
end

function decode_7digit(pattern, out)
    # Mapping from length of patterns to the pattern letters.
    # patlens = DefaultDict{Int64, Set{String}}(Set{String}())
    patlens = Dict(
        2=>Set{String}(),
        3=>Set{String}(),
        4=>Set{String}(),
        5=>Set{String}(),
        6=>Set{String}(),
        7=>Set{String}())
    for p in pattern
        push!(patlens[length(p)], p)
    end

    # Mapping from the true segment name to the scrambled one.
    true2messed = Dict{Char, Char}()

    # First, find the patterns that have 2, 3, and 7 segments.
    p1 = pop!(patlens[2], only(patlens[2]))
    p4 = pop!(patlens[4], only(patlens[4]))
    p7 = pop!(patlens[3], only(patlens[3]))
    p8 = pop!(patlens[7], only(patlens[7]))

    # The pattern for 7 and 1 differ by only one segment (`a`), so we can use that to
    # find the scrambled value of that segment.
    true2messed['a'] = only(setdiff(Set(p7), Set(p1)))

    # length: digits
    # 2: 1
    # 3: 7
    # 4: 4
    # 5: 2, 3, 5,
    # 6: 0, 6, 9
    # 7: 8

    # OK, so I could take the two segments in 1, then compare those to the three
    # digits that have 6 segments. The two segments from 1 will be in both 0
    # and 9, but one of them will *not* be in 6. That segment that's not in one
    # of those length-6 segments is the true c. So, first find the length-6
    # pattern whose intersection with 1 is not equal to 1, which will be 6's
    # pattern.
    len6 = patlens[6]
    # p6 = only(filter(x->intersect(x, p1)!==p1, len6))
    p6 = only(filter(x->!(intersect(Set(x), Set(p1))==Set(p1)), len6))
    pop!(len6, p6)
    # So the intersection of p6 and p1 will give me the true `f` segment.
    true2messed['f'] = only(intersect(Set(p6), Set(p1)))
    # And now we can find what the true `c` segment is, since there are only two
    # segments in 1, and we know one of them.
    true2messed['c'] = only(setdiff(Set(p1), true2messed['f']))

    # So, what's next? If I fid the difference between 2 and 3, that would give
    # me e. Oh, but I need to be able to distingish 2 and 3 from 5. Oh, but 5 is
    # the only length-5 pattern without c, so I can get that one.
    len5 = patlens[5]
    p5 = only(filter(x->!(true2messed['c'] in x), len5))
    pop!(len5, p5)
    # So now 2 is the only unknown length-5 pattern with 'f' in it.
    p2 = only(filter(x->!(true2messed['f'] in x), len5))
    pop!(len5, p2)
    # And the last length-5 pattern is 3.
    p3 = only(len5)
    pop!(len5, p3)
    # So now we can get e.
    true2messed['e'] = only(setdiff(Set(p2), Set(p3)))

    # So now I know what 1, 7, 4, 6, 5, 2, 3 are.
    # Can I figure out 0 and 9?
    # I know what 'e' is.
    # So, of the two length-six patterns, 0 is the one with 'e' in it.
    p0 = only(filter(x->true2messed['e'] in x, len6))
    pop!(len6, p0)
    # And then the last length-6 pattern is 9.
    p9 = only(len6)

    # OK, so let's get the last ones.
    # What don't I know yet?
    # I know a, c, e, f.
    # I can get d by finding the set difference between 0 and 8.
    true2messed['d'] = only(setdiff(Set(p8), Set(p0)))
    # So now I just need b, g.
    # So, I could take c, d, f from 4 and be left with 'b'.
    true2messed['b'] = only(setdiff(Set(p4), Set((true2messed['c'], true2messed['d'], true2messed['f']))))
    # And finally, 'g'.
    true2messed['g'] = only(setdiff(Set(p2), Set((true2messed['a'], true2messed['c'], true2messed['d'], true2messed['e']))))

    # So, now how do I get the correct number? I need a mapping from the messed
    # digits to the number they represent.
    messed2digit = Dict(
                        Set((true2messed['a'], true2messed['b'], true2messed['c'], true2messed['e'], true2messed['f'], true2messed['g']))=>"0",
                        Set((true2messed['c'], true2messed['f']))=>"1",
                        Set((true2messed['a'], true2messed['c'], true2messed['d'], true2messed['e'], true2messed['g']))=>"2",
                        Set((true2messed['a'], true2messed['c'], true2messed['d'], true2messed['f'], true2messed['g']))=>"3",
                        Set((true2messed['b'], true2messed['c'], true2messed['d'], true2messed['f']))=>"4",
                        Set((true2messed['a'], true2messed['b'], true2messed['d'], true2messed['f'], true2messed['g']))=>"5",
                        Set((true2messed['a'], true2messed['b'], true2messed['d'], true2messed['e'], true2messed['f'], true2messed['g']))=>"6",
                        Set((true2messed['a'], true2messed['c'], true2messed['f']))=>"7",
                        Set((true2messed['a'], true2messed['b'], true2messed['c'], true2messed['d'], true2messed['e'], true2messed['f'], true2messed['g']))=>"8",
                        Set((true2messed['a'], true2messed['b'], true2messed['c'], true2messed['d'], true2messed['f'], true2messed['g']))=>"9",
    )
    
    return parse(Int, join(getindex.(Ref(messed2digit), Set.(out))))
end

function day08_part2(patterns, outs)
    c = 0
    for (p, o) in zip(patterns, outs)
        c += decode_7digit(p, o)
    end
    return c
end

function day08(input_fname=joinpath(@__DIR__, "input", "day08.txt"))
    patterns, outs = day08_get_input(input_fname)
    return day08_part1(patterns, outs), day08_part2(patterns, outs)
end
