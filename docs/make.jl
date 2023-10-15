using Documenter
using PlotHelpers

makedocs(
    sitename = "PlotHelpers",
    format = Documenter.HTML(),
    modules = [PlotHelpers]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
