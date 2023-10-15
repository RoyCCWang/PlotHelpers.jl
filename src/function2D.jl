
# plot 2D functions

# x1 is the horizontal axis.
function plotmeshgrid2D(
    PLT, # PythonPlot
    x_ranges::Vector{LinRange{T,L}},
    Y::Matrix{T},
    marker_locations::Vector,
    marker_symbol::String,
    fig_num::Int,
    title_string::String;
    x1_title_string::String = "Dimension 1",
    x2_title_string::String = "Dimension 2",
    cmap = "Greens_r",
    ) where {T <: Real, L}

    #
    @assert length(x_ranges) == 2
    x_coords = collect( collect(x_ranges[d]) for d = 1:2 )

    PLT.figure(fig_num)
    fig_num += 1
    PLT.pcolormesh(x_coords[1], x_coords[2], Y, cmap = cmap, shading = "auto")
    PLT.xlabel(x1_title_string)
    PLT.ylabel(x2_title_string)
    PLT.title(title_string)

    for i = 1:length(marker_locations)
        #pt = reverse(marker_locations[i])
        pt = marker_locations[i]
        PLT.annotate(marker_symbol, xy=pt, xycoords="data")
    end

    PLT.colorbar()
    PLT.axis("scaled")

    return fig_num
end
