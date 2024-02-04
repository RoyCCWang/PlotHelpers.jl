module VisualizationBag


include("./colours/convert.jl")
include("./colours/generate.jl")

include("function2D.jl")
include("maps/plotly_maps.jl")
include("maps/networks2D.jl")

export generatecolors, plotmeshgrid2D, hsv2rgb, getgridranges,

get2Dedgetraces_variablewidth, getedgecoord,

spatialnetworkcanada, getlayoutmap, getlayoutcanada, MapLayoutConfig,
getscattergeo, createcolorscale, scatter2scattergeo!, scatter2scattergeolist!

end # module VisualizationBag
