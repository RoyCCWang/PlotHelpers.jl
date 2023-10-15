function generatecolours(::Type{T}, N::Int) where T
    # oversample since the HSV starts from red, and ends at red.
    M = ceil(Int, 1.3*N)

    r = LinRange(convert(T, 360), zero(T), M) # range(COLORS.HSV(0,1,1), stop = COLORS.HSV(-360,1,1), length = M)
    H = collect(r)
    H[1] = zero(T)

    colours = collect( hsv2rgb(H[n], one(T), one(T)) for n in eachindex(H) )# convert(Vector{COLORS.RGB}, H)
    #colours = collect( [colours[n].r; colours[n].g; colours[n].b] for n = 1:N )

    return colours[1:N]
end