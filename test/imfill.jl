@testset "imfill" begin
    #2 Dimensional case
    image = Bool[
        0 0 0 0 0 0 1 0 0 0
        0 1 1 1 1 1 0 0 0 0
        0 1 0 0 1 1 0 0 0 0
        0 1 1 1 0 1 0 0 0 0
        0 1 1 1 1 1 0 0 0 0
        0 0 0 0 0 0 0 1 1 1
        0 0 0 0 0 0 0 1 0 1
        0 0 0 0 0 0 0 1 1 1
        0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0
    ]
    answer = Bool[
        0 0 0 0 0 0 1 0 0 0
        0 1 1 1 1 1 0 0 0 0
        0 1 1 1 1 1 0 0 0 0
        0 1 1 1 1 1 0 0 0 0
        0 1 1 1 1 1 0 0 0 0
        0 0 0 0 0 0 0 1 1 1
        0 0 0 0 0 0 0 1 1 1
        0 0 0 0 0 0 0 1 1 1
        0 0 0 0 0 0 0 0 0 0
        0 0 0 0 0 0 0 0 0 0
    ]
    @test imfill(.!image, (0, 2)) == (.!answer)

    # verify with a specified connectivity
    imfill(.!image, (0, 5), strel_box((3, 3))) == .!answer

    # and make sure we throw errors correctly
    msg = "Interval must be non-negative and in format (min_range,max_range)"
    @test_throws DomainError((0, -1), msg) imfill(.!image, (0, -1), strel_box((3, 3)))

    #3 Dimensional case
    A = zeros(Bool, 3, size(image)[1], size(image)[2])
    A[1, :, :] = image
    A[2, :, :] = image
    A[3, :, :] = image
    B = zeros(Bool, 3, size(answer)[1], size(answer)[2])
    B[1, :, :] = answer
    B[2, :, :] = answer
    B[3, :, :] = answer
    @test imfill(.!A, (0, 8)) == (.!B)

    # Complete white image and complete black image case
    img = zeros(Bool, 10, 10)
    @test imfill(img, (0, 10)) == img
    @test imfill(.!img, (0, 99)) == .!img
    # Miscellaneous case
    img[5, 5] = true
    @test imfill(.!img, (0, 10)) == .!img
    @test imfill(.!img, (0, 99)) == zeros(Bool, 10, 10)
end
