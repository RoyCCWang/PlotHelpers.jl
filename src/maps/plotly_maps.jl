"""
    scatter2scattergeolist!(edges_trace::Vector)

Batch version of `scatter2scattergeo!`
"""
function scatter2scattergeolist!(edges_trace::Vector)
    for m in eachindex(edges_trace)
        scatter2scattergeo!(edges_trace[m])
    end
    
    return nothing
end

"""
    scatter2scattergeo!(t)

Modifies PlotlyLight config `t` to be compatible for a `scattergeo` Plotly plot.
`t.y` is move to `t.lat`.
`t.x` is moved to `t.lon`.
"""
function scatter2scattergeo!(t)
    t.type = "scattergeo"
    t.lat = t.y
    t.lon = t.x

    # clean up.
    t.y = []
    t.x = []
    return nothing
end
        
"""
    createcolorscale(scheme)

Creates a color scale for Plotly plots from `scheme`.
`scheme` should be of type `ColorSchemes.ColorScheme` from the ColorSchemes.jl package.
"""
# 
function createcolorscale(scheme)

    ts = LinRange(0, 1, length(scheme))

    return collect( 
        (ts[i], scheme[i] .* 255) # ColorSchemes.jl uses [0,1] while plotly uses [0,255].
        for i in eachindex(ts)
    )
end

"""
    getscattergeo(
        PLY, name::String,
        latitudes, longitudes, values, color_scale;
        c_values = values,
        c_min = minimum(values),
        c_max = maximum(values),
        opacity = 0.3,
        marker_size = 5,
        color_tick_suffix = "",
        dtick = step(LinRange(c_min, c_max, 10)),
        reverse_scale = false,
        thickness = 15,
        marker_text_prefix = "Value: "
    )

Returns a `scattergeo`-type data config for use with PlotlyLight.jl.
`PLY` is the `PlotlyLight.jl` module variable.
"""
function getscattergeo(
    PLY, name::String,
    latitudes, longitudes, values, color_scale;
    c_values = values,
    c_min = minimum(values),
    c_max = maximum(values),
    opacity = 0.3,
    marker_size = 5,
    color_tick_suffix = "",
    dtick = step(LinRange(c_min, c_max, 10)),
    reverse_scale = false,
    thickness = 15,
    marker_text_prefix = "Value: "
    )

    plot_data = PLY.Config(
        name = name,
        type = "scattergeo",
        mode = "markers",
        lat = latitudes,
        lon = longitudes,
        text = collect("$marker_text_prefix $(values[n])" for n in eachindex(values)),
        marker = PLY.Config(
            color = c_values,
            colorscale = color_scale,
            reversescale = reverse_scale,
            cmin = c_min,
            cmax = c_max,
            opacity = opacity,
            size = marker_size,
            colorbar = PLY.Config(
                thickness = thickness,
                titleside = "right",
                outlinecolor = "rgba(68,68,68,0)",
                ticks = "outside",
                ticklen = 3,
                shoticksuffix = "last",
                ticksuffix = color_tick_suffix,
                dtick = dtick,
            ),
        ),
    )
    return plot_data
end

"""
    mutable struct MapLayoutConfig

Keyword struct. Default values:
    font_size = 12
    title_font_size = 16
    show_grid = true
    grid_width = 0.5
    show_rivers = true
    river_color = "#fff"
    show_lakes = true
    lake_color = "rgb(255,255,255)"
    show_land = true
    land_color = "rgb(212,212,212)"
    country_color = "rgb(255,255,255)"
    country_width = 1.5
    subunit_color = "rgb(255,255,255)"
    show_subunits = true
    show_countries = true
    resolution = 50
    projection_type = "conic conformal"
    font_family = "Droid Serif, serif"
    lon_axis_dtick = 5
    lat_axis_dtick = 5
"""
@kwdef mutable struct MapLayoutConfig
    font_size = 12
    title_font_size = 16
    show_grid = true
    grid_width = 0.5
    show_rivers = true
    river_color = "#fff"
    show_lakes = true
    lake_color = "rgb(255,255,255)"
    show_land = true
    land_color = "rgb(212,212,212)"
    country_color = "rgb(255,255,255)"
    country_width = 1.5
    subunit_color = "rgb(255,255,255)"
    show_subunits = true
    show_countries = true
    resolution = 50
    projection_type = "conic conformal"
    font_family = "Droid Serif, serif"

    lon_axis_dtick = 5
    lat_axis_dtick = 5
end

"""
    getlayoutcanada(PLY, title::String, width::Integer, height::Integer, config::MapLayoutConfig)

Returns a PlotlyLight.jl data config for Canada.
`PLY` is the `PlotlyLight.jl` module variable.
"""
function getlayoutcanada(PLY, title::String, width::Integer, height::Integer, config::MapLayoutConfig)
    lat_range = [39.0333, 86]
    lon_range = [-140.85, -50.75]
    return getlayoutmap(
        PLY, title, width, height, lat_range, lon_range, config,
    )
end

"""
    getlayoutmap(
        PLY,
        title::String,
        width::Integer,
        height::Integer,
        lat_range,
        lon_range,
        config::MapLayoutConfig
    )

Returns a PlotlyLight.jl data config for the world contained in `lat_range` and `lon_range`.
`lat_range` is a 2-element collection. The first entry is the lower value for latitude, the last entry is the upper value for latitude.
`lon_range` is similar to `lat_range`, but for longitude.
`PLY` is the `PlotlyLight.jl` module variable.
"""
function getlayoutmap(
    PLY,
    title::String,
    width::Integer,
    height::Integer,
    lat_range,
    lon_range,
    config::MapLayoutConfig
    )
    
    return PLY.Config(
        title = title,
        width = width,
        height = height,
        showlegend = false,
        showarrow = false,
        font = PLY.Config(
            family = config.font_family,
            size = config.font_size,
        ),
        titlefont = PLY.Config(
            size = config.title_font_size,
        ),
        geo = PLY.Config(
            #scope = config.scope,
            lonaxis = PLY.Config(
                showgrid = config.show_grid,
                gridwidth = config.grid_width,
                range = lon_range,
                dtick = config.lon_axis_dtick,
            ),
            lataxis = PLY.Config(
                showgrid = config.show_grid,
                gridwidth = config.grid_width,
                range = lat_range,
                dtick = config.lat_axis_dtick,
            ),
            showrivers = config.show_rivers,
            rivercolor = config.river_color,
            showlakes = config.show_lakes,
            lakecolor = config.lake_color,
            showland = config.show_land,
            landcolor = config.land_color,
            countrycolor = config.country_color,
            countrywidth = config.country_width,
            subunitcolor = config.subunit_color,
            showsubunits = config.show_subunits,
            showcountries = config.show_countries,
            resolution = config.resolution,
            projection = PLY.Config(
                type = config.projection_type,
                #rotation = config.projection_rotation,
            )
        )
    )
end

# front end.
"""
    spatialnetworkcanada(
        PLY,
        width::Integer,
        height::Integer,
        layout_config::MapLayoutConfig,
        color_scheme,
        X::Vector,
        node_values::Vector,
        srcs::Vector{Int},
        dests::Vector{Int},
        ws::Vector;
        marker_size = 5,
        opacity = 1.0,
        x1_is_longitude = false,
        node_marker_hover_text_prefix = "Value: "
    )

Return PlotlyLight.jl data/trace and layout configs.
- `node_values` correspond to the node location `X`
-  `srcs`, `dests`, `ws` describe the source nodes, destination nodes, and edge weights for the edges.
- `color_scheme` should be of type `ColorSchemes.ColorScheme` from the ColorSchemes.jl package.

Return objects:
- `ca_layout`: layout config.
- `edge_traces`: a `Vector` of data configs for each edge, as a separate trace. Separate traces are used to allow for different line thickness that is proportional to the edge weight.
- `mid_pts_trace`: a data config for the edge midpoints, where the midpoint markers are invisible. Include this trace to allow hover display for edge weights when the mouse cursor is around the midpoint of an edge.
- `station_trace`: a data config for the node locations and node values (represented as a color with respect to the `color_scheme` input).

"""
function spatialnetworkcanada(
    PLY,
    width::Integer,
    height::Integer,
    layout_config::MapLayoutConfig,
    color_scheme,
    X::Vector,
    node_values::Vector,
    srcs::Vector{Int},
    dests::Vector{Int},
    ws::Vector;
    marker_size = 5,
    opacity = 1.0,
    x1_is_longitude = false,
    node_marker_hover_text_prefix = "Value: "
    )

    lats = map(xx->xx[begin], X)
    lons = map(xx->xx[begin+1], X)
    if x1_is_longitude
        lats, lons = lons, lats
    end

    ca_layout = getlayoutcanada(
        PLY, "Canada", width, height, layout_config,
    )

    cs = createcolorscale(color_scheme)
    station_trace = getscattergeo(
        PLY, "Station", lats, lons, node_values, cs;
        marker_size = marker_size,
        opacity = opacity,
        marker_text_prefix = node_marker_hover_text_prefix
    )
    
    # edges.
    eds, mid_pts_trace = get2Dedgetraces_variablewidth(
        PLY, srcs, dests, ws, X;
        x1_is_horizontal_dir = x1_is_longitude,
    )
    scatter2scattergeolist!(eds)
    scatter2scattergeo!(mid_pts_trace)

    edge_traces = vcat(eds...)
    
    return ca_layout, edge_traces, mid_pts_trace, station_trace
end