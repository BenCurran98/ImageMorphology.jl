@testset "SIMD Preferences" begin
    # begin by removing the LocalPreferences file if it exists
    preference_file = joinpath(@__DIR__, "..", "LocalPreferences.toml")
    rm(preference_file, force = true)

    # note - to test preferences here, we'll simulate restarting Julia
    mktempdir() do tmp
        test_in_new_julia_session("""
            using ImageMorphology
            # to start, our SIMD preference should be false
            @test !ImageMorphology.USE_SIMD
            # if we turn it on, we should get a warning since we haven't included LoopVectorization in the environment
            @test_warn ImageMorphology.LV_MISSING_WARNING set_simd_use!(true)
        """, tmp)

        # now if we reload Julia and use ImageMorphology, we should see that it's set, but it should throw a warning if LV isn't loaded
        test_in_new_julia_session("""
            Pkg.precompile("ImageMorphology")
        """, tmp)

        # if we restart Julia and use LoopVectorization, we should get no warning
        test_in_new_julia_session("""
            using LoopVectorization
            using ImageMorphology
            @test ImageMorphology.USE_SIMD
            @test_nowarn extreme_filter(max, rand(1:10, 7, 7))
            # unset the flag in this session
            set_simd_use!(false)
        """, tmp)
        
        # now we've unset the flag, it should be visible in the next session
        test_in_new_julia_session("""
            using LoopVectorization
            using ImageMorphology
            @test !ImageMorphology.USE_SIMD
            # turn it back on now
            set_simd_use!(true)
        """, tmp)

        # now we should have the flag set in a new session
        test_in_new_julia_session("""
            using LoopVectorization
            using ImageMorphology
            @test ImageMorphology.USE_SIMD
        """, tmp)
    end

end