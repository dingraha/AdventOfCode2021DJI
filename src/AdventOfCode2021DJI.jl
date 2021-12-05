module AdventOfCode2021DJI

using DelimitedFiles: readdlm
using Transducers
using LinearAlgebra: det
using OffsetArrays: OffsetArray

include("day01.jl")
export day01, day01_transducers

include("day02.jl")
export day02, day02_transducers

include("day03.jl")
export day03

include("day04.jl")
export day04

include("day05.jl")
export day05

end # module
