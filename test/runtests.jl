using AdventOfCode2021DJI
using Test

@testset "Day 1" begin
    @testset "vanilla" begin
        part1, part2 = day01()
        @test part1 == 1162
        @test part2 == 1190
    end

    @testset "transducers" begin
        part1, part2 = day01_transducers()
        @test part1 == 1162
        @test part2 == 1190
    end
end
