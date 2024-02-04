module VisualizationBag


include("./colours/convert.jl")
include("./colours/generate.jl")

include("function2D.jl")
include("network2D.jl")

export generatecolors, plotmeshgrid2D, hsv2rgb, getgridranges,
get2Dedgetraces_variablewidth, getedgecoord

end # module VisualizationBag
