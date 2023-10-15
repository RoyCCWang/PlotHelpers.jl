
# https://cs.stackexchange.com/questions/64549/convert-hsv-to-rgb-colors
function hsv2rgb(H::T, S::T, V::T)::Vector{T} where T
    @assert 0 <= H < 360
    @assert 0 <= S <= 1
    @assert 0 <= V <= 1
    
    high = V
    C = S*V
    low = high - C

    H1 = (H-360)/60
    if H < 300
        H1 = H/60
    end

    R = convert(T, NaN)
    G = convert(T, NaN)
    B = convert(T, NaN)
    if -1 <= H1 < 1
        
        R = high
        B = low
        G = B + H1*C
        if H1 < 0
            R = high
            G = low
            B = G - H1*C
        end
    
    elseif 1 <= H1 < 3

        R = low
        G = high
        B = R + (H1-2)*C
        if H1 - 2 < 0
            G = high
            B = low
            R = B - (H1-2)*C
        end
    
    elseif 3 <= H1 < 5

        G = low
        B = high
        R = G + (H1-4)*C
        if H1 - 4 < 0
            R = low
            B = high
            G = R - (H1-4)*C
        end
    end

    return [R; G; B;]
end

# COLORS is Colors.jl, tested on v0.12.10.
function generatecolours(COLORS, N::Int)
    # oversample since the HSV starts from red, and ends at red.
    M = round(Int, 1.3*N)

    colours = range(COLORS.HSV(0,1,1), stop = COLORS.HSV(-360,1,1), length = M)
    colours = convert(Vector{COLORS.RGB}, colours)
    colours = collect( [colours[n].r; colours[n].g; colours[n].b] for n = 1:N )

    return colours
end

function generatecolours(::Type{T}, N::Int) where T
    # oversample since the HSV starts from red, and ends at red.
    M = round(Int, 1.3*N)

    H = LinRange(zero(T), one(T), M) # range(COLORS.HSV(0,1,1), stop = COLORS.HSV(-360,1,1), length = M)
    colours = collect( hsv2rgb(H[n], one(T), one(T)) for n in eachindex(H) )# convert(Vector{COLORS.RGB}, H)
    #colours = collect( [colours[n].r; colours[n].g; colours[n].b] for n = 1:N )

    return colours
end