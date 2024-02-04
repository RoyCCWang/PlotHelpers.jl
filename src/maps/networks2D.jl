# for use with PlotlyLight.jl

"""
    getedgecoord(
        srcs::Vector{Int},
        dests::Vector{Int},
        X::Vector{AV},
        d::Integer,
        ) where {T, AV <: AbstractVector{T}}

For use with PlotlyLight.jl.
Returns a `Vector` of coordinates for axis `d`, taking numeric or `nothing` values.
The `nothing` values signify the end of a line segment to PlotlyJS, and gets translated to `null` in JavaScript.
"""
function getedgecoord(
    srcs::Vector{Int},
    dests::Vector{Int},
    X::Vector{AV},
    d::Integer,
    ) where {T, AV <: AbstractVector{T}}
    
    # parse & checks.
    @assert !isempty(X)
    @assert 1 <= d <= length(X[begin])

    
    @assert length(srcs) == length(dests)
    
    # 
    k = 0
    #out = zeros(T, length(srcs)*3)
    out = Vector{Any}(undef, length(srcs)*3)
    for j in eachindex(srcs)

        k += 1
        out[k] = X[srcs[j]][begin+d-1]

        k += 1
        out[k] = X[dests[j]][begin+d-1]

        # we need a `null` JavaScript value to break up each line segment.
        k+=1
        #out[k] = "something"
        #out[k] = "null"
        out[k] = nothing # forces the generated HTML or JSON to use a null value.
    end
    resize!(out, k)

    return out
end

"""
    convertcompactdomain(x::T, a::T, b::T, c::T, d::T)::T

converts compact domain x ∈ [a,b] to compact domain out ∈ [c,d].
"""
function convertcompactdomain(x::T, a::T, b::T, c::T, d::T)::T where T <: Real

    return (x-a)*(d-c)/(b-a)+c
end

# option 2: multiple traces. Larger file size.
"""
    get2Dedgetraces_variablewidth(
        PLY,
        srcs::Vector{Int},
        dests::Vector{Int},
        ws::Vector,
        X::Vector;
        width_lb = 0.5,
        width_ub = 3.5,
        edge_color = "rgba(136,136,136,0.8)",
        x1_is_horizontal_dir = false,
        mid_pts_trace_title = "Edge midpoint",
    )

For use with PlotlyLight.jl. A PlotlyJS data trace is a `Vector` of `PlotlyLight.Config`s.
The first return is a data trace for edges. The line width is linearly proportional to the edge weights in `ws`.
The second return is a data trace for the midpoint of edges, with weights as the midpoint (invisible) marker hover labels.
"""
function get2Dedgetraces_variablewidth(
    PLY,
    srcs::Vector{Int},
    dests::Vector{Int},
    ws::Vector,
    X::Vector;
    width_lb = 0.5,
    width_ub = 3.5,
    edge_color = "rgba(136,136,136,0.8)",
    x1_is_horizontal_dir = false,
    mid_pts_trace_title = "Edge midpoint",
    )
    
    @assert width_lb <= width_ub
    @assert length(srcs) == length(dests) == length(ws)
    w_lb, w_ub = minimum(ws), maximum(ws)
    
    # 
    out = Vector{Any}(undef, length(srcs))

    for j in eachindex(srcs)

        edge_x1 = [
            X[srcs[j]][begin];
            X[dests[j]][begin];
        ]

        edge_x2 = [
            X[srcs[j]][begin+1];
            X[dests[j]][begin+1];
        ]

        edge_v = edge_x1
        edge_h = edge_x2
        if x1_is_horizontal_dir
            edge_h, edge_v = edge_v, edge_h
        end

        out[j] = PLY.Config(
            name = "", # empty string forces hover to display nothing for trace name.
            type = "scatter",
            mode = "lines",
            x = edge_h,
            y = edge_v,

            line = PLY.Config(
                width = convertcompactdomain(
                    ws[j],
                    w_lb, w_ub,
                    width_lb, width_ub,
                ),
                color = edge_color,
            ),
        )
    end

    # mid point of edges.
    mid_pts = collect(
        (X[srcs[j]] + X[dests[j]]) ./ 2
        for j in eachindex(srcs)
    )

    x_v = map(xx->xx[begin], mid_pts)
    x_h = map(xx->xx[begin+1], mid_pts)
    if x1_is_horizontal_dir
        x_h, x_v = x_v, x_h
    end

    mid_pts_trace = PLY.Config(
        name = mid_pts_trace_title,
        x = x_h,
        y = x_v,
        mode = "markers",
        text = [
            "Weight: $(ws[n])"
            for n in eachindex(ws)
        ],
        marker = PLY.Config(
            color = "rgba(0,0,0,0)",
            size = 10,
        ),
    )

    return out, mid_pts_trace
end
