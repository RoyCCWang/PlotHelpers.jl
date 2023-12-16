module VisualizationBag


include("./colours/convert.jl")
include("./colours/generate.jl")

include("function2D.jl")

export generatecolors, plotmeshgrid2D, hsv2rgb, getgridrange

end # module VisualizationBag
