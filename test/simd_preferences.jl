@testset "SIMD Preferences" begin
    # to start, our SIMD preference should be false
    @test !ImageMorphology.will_use_simd()

    # if we turn it on, we should get a warning since we haven't included LoopVectorization in the environment
    @test_warn ImageMorphology.LV_MISSING_WARNING set_simd_use!(true)

    # the flag should still be false
    @test !ImageMorphology.will_use_simd()

    # now if we use LoopVectorization, the flag should be toggled on
    using LoopVectorization
    @test ImageMorphology.will_use_simd()

    # make sure we can still turn it off if we want
    set_simd_use!(false)
    @test !ImageMorphology.will_use_simd()
end