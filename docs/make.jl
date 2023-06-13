using Documenter
using NeuralNetworkLearning

makedocs(
    sitename = "NeuralNetworkLearning",
    format = Documenter.HTML(),
    modules = [NeuralNetworkLearning]
)

# Documenter can also automatically deploy documentation to gh-pages.
# See "Hosting Documentation" and deploydocs() in the Documenter manual
# for more information.
#=deploydocs(
    repo = "<repository url>"
)=#
