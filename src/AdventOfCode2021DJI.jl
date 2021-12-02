module AdventOfCode2021DJI

using DelimitedFiles: readdlm
using Transducers

include("day01.jl")
export day01, day01_transducers

include("day02.jl")
export day02, day02_transducers

end # module
