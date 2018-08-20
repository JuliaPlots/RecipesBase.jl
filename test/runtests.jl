using RecipesBase
using Test, Random

const KW = Dict{Symbol, Any}

RecipesBase.is_key_supported(k::Symbol) = true

for t in [Symbol(:T, i) for i in 1:4]
    @eval struct $t end
end


@testset "@recipe" begin


"""
make sure the attribute dictionary was populated correctly,
and the returned arguments are as expected
"""
function check_apply_recipe(T::DataType, expect)
    # this is similar to how Plots would call the method
    plotattributes = KW(:customcolor => :red)

    data_list = RecipesBase.apply_recipe(plotattributes, T(), 2)
    @test data_list[1].args == (Random.seed!(1); (rand(10,2),))
    @test plotattributes == expect
end


@testset "simple parametric type" begin
    @test_throws MethodError RecipesBase.apply_recipe(KW(), T1())

    @recipe function plot(t::T1, n::N = 1; customcolor = :green) where N <: Integer
        :markershape --> :auto, :require
        :markercolor --> customcolor, :force
        :xrotation --> 5
        :zrotation --> 6, :quiet
        rand(10, n)
    end

    Random.seed!(1)
    check_apply_recipe(T1, KW(
        :customcolor => :red,
        :markershape => :auto,
        :markercolor => :red,
        :xrotation => 5,
        :zrotation => 6))
end


@testset "parametric type with where" begin
    @test_throws MethodError RecipesBase.apply_recipe(KW(), T2())

    @recipe function plot(t::T2, n::N = 1; customcolor = :green) where {N <: Integer}
        :markershape --> :auto, :require
        :markercolor --> customcolor, :force
        :xrotation --> 5
        :zrotation --> 6, :quiet
        rand(10, n)
    end

    Random.seed!(1)
    check_apply_recipe(T2, KW(
        :customcolor => :red,
        :markershape => :auto,
        :markercolor => :red,
        :xrotation => 5,
        :zrotation => 6))
end


@testset "parametric type with double where" begin
    @test_throws MethodError RecipesBase.apply_recipe(KW(), T3())

    @recipe function plot(t::T3, n::N = 1, m::M = 0.0;
                          customcolor = :green) where {N <: Integer} where {M <: Float64}
        :markershape --> :auto, :require
        :markercolor --> customcolor, :force
        :xrotation --> 5
        :zrotation --> 6, :quiet
        rand(10, n)
    end

    Random.seed!(1)
    check_apply_recipe(T3, KW(
        :customcolor => :red,
        :markershape => :auto,
        :markercolor => :red,
        :xrotation => 5,
        :zrotation => 6))
end


@testset "manual access of plotattributes" begin
    @recipe function plot(t::T4, n = 1; customcolor = :green)
        :markershape --> :auto, :require
        :markercolor --> customcolor, :force
        :xrotation --> 5
        :zrotation --> 6, :quiet
        plotattributes[:hello] = "hi"
        plotattributes[:world] = "world"
        rand(10,n)
    end
    Random.seed!(1)
    check_apply_recipe(T4, KW(
    :customcolor => :red,
    :markershape => :auto,
    :markercolor => :red,
    :xrotation => 5,
    :zrotation => 6,
    :hello => "hi",
    :world => "world"
   ))
end

end  # @testset "@recipe"
