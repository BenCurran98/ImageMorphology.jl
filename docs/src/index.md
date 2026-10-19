# ImageMorphology.jl

This package provides morphology operations for structure analysis and image processing.

!!! info "setup"
    ImageMorphology is a sub-package of the umbrella package Images.jl -- either `using
    Images` or `using ImageMorphology` will give you access to this functionality.

## Installation

Just like all normal Julia packages, you can use
[Pkg](https://pkgdocs.julialang.org/v1/getting-started/) to install it:

```julia
pkg> add ImageMorphology # hit ] to enter Pkg mode
```

## Learn

The perhaps quickest way to use this library is to find a set of useful operators from the
[gallery](@ref op_index) and build your own pipeline from it.

For any advanced usage, we recommend you to read the "Concept" part. For instance, many morphology
operation supports generic ["structuring element"](@ref concept_se).

## Overview

The following tables give an overview of ImageMorphology functionalities.

!!! note "🚧 work in progress"
    This overview is not yet finished and only contains a subset of exported functions. The missing
    functions will be added in the future. You might still need to check the heavy [reference](@ref
    reference_index) page to find out what you need. Contributions are welcome!

### Structuring Element (SE)

Structuring element is the key concept in morphology. If you're not familiar with this, please read
[concept: structuring element](@ref concept_se) first.

| name                          | summary |
| :---------------------------- | :------ |
| [`strel`](@ref)               | convert between different SE representations    |
| [`strel_type`](@ref)          | infer the SE type                               |
| [`strel_size`](@ref)          | get the minimal block size that contains the SE |
| [`strel_chain`](@ref) and [`strel_product`](@ref) | compose multiple SEs into a bigger one |
| [`strel_box`](@ref)           | construct a box-shaped SE, e.g., C8, C26 connectivity |
| [`strel_diamond`](@ref)       | construct a diamond-shaped SE, e.g., C4, C6 connectivity |
| [`centered`](@ref OffsetArrays.centered) | shift the array center to `(0, 0, ..., 0)`    |


### Basic morphological operations

| name                                                   | summary | examples |
| :----------------------------------------------------- | :------ | ---- |
| [`extreme_filter`](@ref) and [`extreme_filter!`](@ref) | iteratively apply a select function `f(x, y)` to each neighborhood | [`extreme_filter` operation](@ref op_extreme_filter) |
| [`dilate`](@ref) and [`dilate!`](@ref)                 | morphological max filter  | [`dilate` operation](@ref op_dilate)   |
| [`erode`](@ref) and [`erode!`](@ref)                   | morphological min filter  | [`erode` operation](@ref op_erode)     |
| [`opening`](@ref) and [`opening!`](@ref)               | fills white holes         | [`opening` operation](@ref op_opening) |
| [`closing`](@ref) and [`closing!`](@ref)               | fills black holes         | [`closing` operation](@ref op_closing) |
| [`bothat`](@ref) and [`bothat!`](@ref)                 | extract black details     | [`bothat` operation](@ref op_bothat)   |
| [`tophat`](@ref) and [`tophat!`](@ref)                 | extract white details     | [`tophat` operation](@ref op_tophat)   |
| [`mgradient`](@ref) and [`mgradient!`](@ref)           | morphological gradient    | [`mgradient` operation](@ref op_mgradient)|
| [`mlaplacian`](@ref) and [`mlaplacian!`](@ref)         | morphological Laplacian   | [`mlaplacian` operation](@ref op_mlaplacian) |

### Geodesic operations

| name                       | summary | examples |
| :--------------------------| :------ | ---- |
| [`underbuild`](@ref)       | morphological reconstruction by dilation, see also [`mreconstruct`](@ref) | [`underbuild` operation](@ref op_underbuild) and [`mreconstruct` operation](@ref op_mreconstruct)
| [`underbuild`](@ref)       | morphological reconstruction by erosion, see also [`mreconstruct`](@ref) | [`overbuild` operation](@ref op_overbuild) and [`mreconstruct` operation](@ref op_mreconstruct)

### SIMD Acceleration

ImageMorphology supports the use of SIMD-based acceleration techniques for the [`extreme_filter`](@ref) function by using 
functionality found in [LoopVectorization.jl](https://github.com/JuliaSIMD/LoopVectorization.jl).

You must opt-in to use this feature, which can be done either by setting your the package preference `use_simd` to `true`, 
or via the function [`set_simd_use!`](@ref). 

Note that you must also have LoopVectorization.jl loaded in your current environment, otherwise the default methods will be used.

E.g. 

```julia
using ImageMorphology
using LoopVectorization

set_simd_use!(true)
```