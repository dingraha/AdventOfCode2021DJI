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

@testset "Day 2" begin
    @testset "vanilla" begin
        part1, part2 = day02()
        @test part1 == 1427868
        @test part2 == 1568138742
    end
    @testset "transducers" begin
        part1, part2 = day02_transducers()
        @test part1 == 1427868
        @test part2 == 1568138742
    end
end

@testset "Day 3" begin
    @testset "vanilla" begin
        part1, part2 = day03()
        @test part1 == 2724524
        @test part2 == 2775870
    end
end

@testset "Day 4" begin
    @testset "vanilla" begin
        part1, part2 = day04()
        @test part1 == 23177
        @test part2 == 6804
    end
end

@testset "Day 5" begin
    @testset "vanilla" begin
        part1, part2 = day05()
        @test part1 == 7473
        @test part2 == 24164
    end
end
