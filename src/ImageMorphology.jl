module ImageMorphology

using DataStructures: Queue
using ImageCore
using ImageCore: GenericGrayImage, MappedArrays, FixedPointNumbers
using OffsetArrays
using OffsetArrays: centered
using LinearAlgebra
using Preferences
using TiledIteration: EdgeIterator, SplitAxis, SplitAxes

const _docstring_se = """
`se` is the structuring element that defines the neighborhood of the image. See
[`strel`](@ref) for more details. If `se` is not specified, then it will use the
[`strel_box`](@ref) with an extra keyword `dims` to control the dimensions to filter,
and half-size `r` to control the diamond size.
"""
include("StructuringElements/StructuringElements.jl")
using .StructuringElements

# flag indicating if we have LoopVectorization available in the current environment - indicates if we have the option of using SIMD or not
const LV_PRESENT = Ref(false)
const LV_MISSING_WARNING = "LoopVectorization.jl is required to be loaded in order to use SIMD acceleration. Run `using LoopVectorization` to enable this feature."

"""
    set_simd_use!(to_use::Bool)

Set a preference in the current environment indicating whether or not to use SIMD acceleration as a backend for 
[`extreme_filter`](@ref) calls.

Note that this will be turned off by default. Additionally, LoopVectorization.jl must be loaded for this feature to take
effect.
"""
function set_simd_use!(to_use::Bool)
    # add a warning here if a user requests SIMD use but LoopVectorization isn't loaded
    if to_use && !LV_PRESENT[]
        @warn LV_MISSING_WARNING
    end
    # still set the flag to their preference in case they load LV later
    @set_preferences!("use_simd" => to_use)
end

function will_use_simd()
    # check if the user has explicitly requested to use SIMD
    user_preference = @load_preference("use_simd", false)
    # verify that we actually have LoopVectorization available to use SIMD
    if user_preference && !LV_PRESENT[]
        @warn LV_MISSING_WARNING
        return false
    else
        return user_preference
    end
end

include("convexhull.jl")
include("connected.jl")
include("clearborder.jl")
include("extreme_filter.jl")
include("extremum.jl")
include("ops/dilate.jl")
include("ops/erode.jl")
include("ops/closing.jl")
include("ops/opening.jl")
include("ops/tophat.jl")
include("ops/bothat.jl")
include("ops/mgradient.jl")
include("ops/mlaplacian.jl")
include("ops/mreconstruct.jl")
include("ops/underbuild.jl")
include("ops/overbuild.jl")
include("isboundary.jl")
include("thinning.jl")
include("imfill.jl")
include("maxtree.jl")
include("leveling.jl")

include("feature_transform.jl")
include("utils.jl")
using .FeatureTransform

include("deprecations.jl")

export
    # structuring_element.jl
    centered, # from OffsetArrays
    strel,
    strel_chain,
    strel_product,
    strel_type,
    strel_size,
    strel_diamond,
    strel_box,

    # operations
    dilate,
    dilate!,
    erode,
    erode!,
    extreme_filter,
    extreme_filter!,
    opening,
    opening!,
    closing,
    closing!,
    tophat,
    tophat!,
    bothat,
    bothat!,
    mgradient,
    mgradient!,
    mlaplacian,
    mlaplacian!,
    mreconstruct,
    mreconstruct!,
    underbuild,
    underbuild!,
    overbuild,
    overbuild!,

    # connected.jl
    label_components,
    label_components!,
    component_boxes,
    component_lengths,
    component_indices,
    component_subscripts, # deprecated (v0.4)
    component_centroids,
    label_flatzones,
    label_flatzones!,
    label_lambdaflatzones,
    label_lambdaflatzones!,

    # convexhull.jl
    convexhull,

    # isboundary.jl
    isboundary,
    isboundary!,

    # thinning.jl
    thinning,
    GuoAlgo,
    imfill,

    # maxtree.jl
    MaxTree,
    areas,
    boundingboxes,
    diameters,
    area_opening,
    area_opening!,
    area_closing,
    area_closing!,
    diameter_opening,
    diameter_opening!,
    diameter_closing,
    diameter_closing!,
    local_maxima!,
    local_maxima,
    local_minima!,
    local_minima,

    #feature_transform.jl
    feature_transform,
    distance_transform,
    clearborder,

    #leveling
    low_leveling,
    low_leveling!,
    high_leveling,
    high_leveling!,
    leveling,
    leveling!,
    #extremum
    hmaxima,
    hmaxima!,
    hminima,
    hminima!,
    regional_maxima,
    regional_maxima!,
    regional_minima,
    regional_minima!,

    # SIMD preferences
    set_simd_use!

end # module
