# build a random mask se with extra symmetricity constraint
function rand_se_mask(r, N; symmetric=false)
    se = centered(rand(Bool, ntuple(_ -> r, N)))
    symmetric || return se
    dual_se = copy(se)
    for i in CartesianIndices(dual_se)
        dual_se[i] = se[-i]
    end

    out = @. (Int(dual_se) + Int(se)) ÷ 2
    out[OffsetArrays.center(out)...] = 1
    return Bool.(out)
end

# function to run Julia in an isolated session to test different "restart" behaviours
# based on https://github.com/JuliaPlots/Plots.jl/blob/dd98bc0aa300bdf12dc85687e45c3968587fabc9/PlotsBase/test/test_preferences.jl
function test_in_new_julia_session(script::String, proj_dir::String, io = devnull)
    pkg_dir = escape_string(pkgdir(ImageMorphology))
    file = tempname()
    write(file, """
    using Pkg, Test
    Pkg.activate("$proj_dir"; io = $io)
    Pkg.develop(; path = "$pkg_dir", io = $io)
    Pkg.add("LoopVectorization"; io = $io)
    $script
    """)
    @test run(`$(Base.julia_cmd()) $file`) |> success
end