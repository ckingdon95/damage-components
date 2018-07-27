using Mimi

include(joinpath(@__DIR__, "../src/RegionalAggregation.jl"))

data_dir = joinpath(@__DIR__, "../data/")

m = Model()
set_dimension!(m, :time, 2010:10:2030)      # Three years
set_dimension!(m, :regions, ["A", "B"])     # Two regions
set_dimension!(m, :countries, 1:4)          # Four countries

addcomponent(m, RegionalAggregation, :regagg)
set_parameter!(m, :regagg, :weights, readcsv(joinpath(data_dir, "population.csv"))[2:end, 2:end])
# set_parameter!(m, :regagg, :mapping, ["A", "A", "B", "B"])    # TODO: see if we can access actual region labels within run_timestep to avoid implicit numbering of regions when setting this parameter
set_parameter!(m, :regagg, :mapping, [1, 1, 2, 2])
set_parameter!(m, :regagg, :input, readcsv(joinpath(data_dir, "gdp_cap.csv"))[2:end, 2:end])

run(m)

m[:regagg, :input]
m[:regagg, :output]