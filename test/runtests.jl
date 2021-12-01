using AdventOfCode2021
using Test

@testset "Day 1" begin
    part1, part2 = day01()
    @test part1 == 1162
    @test part2 == 1190
end
