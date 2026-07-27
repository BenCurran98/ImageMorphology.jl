module ImageMetadataExt
    using ImageMorphology, ImageMetadata

    # morphological operations for ImageMeta
    function ImageMorphology.dilate(img::ImageMetadata.ImageMeta; kwargs...)
        out = dilate!(similar(ImageMetadata.arraydata(img)), img; kwargs...)
        return ImageMetadata.shareproperties(img, out)
    end
    function ImageMorphology.erode(img::ImageMetadata.ImageMeta; kwargs...)
        out = erode!(similar(ImageMetadata.arraydata(img)), img; kwargs...)
        return ImageMetadata.shareproperties(img, out)
    end
end