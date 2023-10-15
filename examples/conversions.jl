
R = [
1
0.75
0
0.5
0.5
0.75
0.628
0.255
0.116
0.941
0.704
0.931
0.998
0.099
0.211
0.495
]

G = [
    0
    0.75
    0.5
    1
    0.5
    0.25
    0.643
    0.104
    0.675
    0.785
    0.187
    0.463
    0.974
    0.795
    0.149
    0.493
]

B = [
    0
    0
    0
    1
    1
    0.75
    0.142
    0.918
    0.255
    0.053
    0.897
    0.316
    0.532
    0.591
    0.597
    0.721
]

H = [ # degrees.
    0.0;
    60.0;
    120.0;
    180.0;
    240.0;
    300.0;
    61.8;
    251.1;
    134.9;
    49.5;
    283.7;
    14.3;
    56.9;
    162.4;
    248.3;
    240.5;
]

S = [
    1
    1
    1
    0.5
    0.5
    0.667
    0.779
    0.887
    0.828
    0.944
    0.792
    0.661
    0.467
    0.875
    0.75
    0.316
]

V = [
    1
    0.75
    0.5
    1
    1
    0.75
    0.643
    0.918
    0.675
    0.941
    0.897
    0.931
    0.998
    0.795
    0.597
    0.721
]

HSV = collect( [H[n]; S[n]; V[n]] for n in eachindex(H))
RGB_oracle = collect( [R[n]; G[n]; B[n]] for n in eachindex(R))

RGB = collect( PH.hsv2rgb(HSV[n]...) for n in eachindex(HSV) )
rounded_RGB = collect( round.(RGB[n], digits = 3) for n in eachindex(RGB) )

@show norm( rounded_RGB - RGB_oracle)

# use relative discrepancy.
@assert norm( rounded_RGB - RGB_oracle)/norm(RGB_oracle) < 0.01



colours = PH.generatecolors(Float64, 11)

nothing
