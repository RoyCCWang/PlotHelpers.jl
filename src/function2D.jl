
# plot 2D functions

function getaspectratio(sz::Tuple; matrix_mode = true)
    if matrix_mode
        return 1, sz[1]/sz[2]
    end
    return sz[1]/sz[2], 1
end

# x1 is the horizontal axis.
function plotmeshgrid2D(
    PLT, # PythonPlot
    x_ranges_inp::Vector{RT},
    Y::Matrix{T},
    marker_locations::Vector,
    marker_symbol::String,
    fig_num::Int,
    title_string::String;
    horizontal_title::String = "",
    vertical_title::String = "",
    cmap = "Greys_r", # see https://matplotlib.org/stable/gallery/color/colormap_reference.html
    vmin = minimum(Y), # color bar range's minimum.
    vmax = maximum(Y), # color bar range's maximum.
    matrix_mode::Bool = false, # flip the vertical axis.
    color_bar_shrink = Inf,
    display_color_bar = true,
    fig_size = getaspectratio(size(Y)),
    dpi = 96,
    symmetric_color_range = false,
    ) where {T <: Real, RT <: AbstractRange}

    if symmetric_color_range
        z = max(abs(minimum(Y)), abs(maximum(Y)))
        vmin = -z
        vmax = z
    end

    x_ranges = x_ranges_inp
    markers = marker_locations
    if matrix_mode
        # first dimension is row, which should be the second (i.e. the veritical) dimension for pcolormesh().
        x_ranges = reverse(x_ranges_inp)
        markers = reverse.(marker_locations)
    end

    #
    @assert length(x_ranges) == 2
    x_coords = collect( collect(x_ranges[d]) for d = 1:2 )

    PLT.figure(fig_num; figsize = fig_size, dpi = dpi)
    fig_num += 1
    PLT.pcolormesh(x_coords[1], x_coords[2], Y, cmap = cmap, shading = "auto", vmin = vmin, vmax = vmax)
    PLT.xlabel(horizontal_title)
    PLT.ylabel(vertical_title)
    PLT.title(title_string)

    for i in eachindex(markers)
        #pt = reverse(marker_locations[i])
        pt = markers[i]
        PLT.annotate(marker_symbol, xy=pt, xycoords="data")
    end

    if display_color_bar
        if !isfinite(color_bar_shrink)
            PLT.colorbar()
        else
            PLT.colorbar(shrink = color_bar_shrink)
        end
    end

    PLT.axis("scaled")

    if matrix_mode
        PLT.gca().invert_yaxis()
    end

    return fig_num
end

function getgridranges(::Type{T}, Nr::Integer, Nc::Integer) where T <: Real
    #
    v_range = LinRange(1, Nr, Nr)
    h_range = LinRange(1, Nc, Nc)
    

    x_ranges = Vector{LinRange{T,Int}}(undef, 2)
    x_ranges[1] = h_range
    x_ranges[2] = v_range

    return x_ranges
end