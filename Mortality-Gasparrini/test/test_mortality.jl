using Mimi

include("../src/MortalityComponent.jl")
include("../src/data_helper.jl")

num_days = 365

m = Model()
set_dimension!(m, :time, 2010:10:2050)
set_dimension!(m, :region, ["North America", 
                    "Central America", 
                    "South America", 
                    "North Europe", 
                    "Central Europe",
                    "South Europe",
                    "East Asia",
                    "South East Asia",
                    "Australia"])
set_dimension!(m, :days, 1:num_days)

addcomponent(m, Mortality)
set_parameter!(m, :Mortality, :daily_mean_temp, load_daily_temps(num_days))
set_parameter!(m, :Mortality, :RR_preind, readcsv(joinpath(@__DIR__, "../data/RR_preind.csv"))[:,2])
set_parameter!(m, :Mortality, :opt_mortality, readcsv(joinpath(@__DIR__, "../data/opt_mortality.csv"))[:,2])

cubic_coeffs = readcsv(joinpath(@__DIR__, "../data/cubic_coefficients.csv"))[2:end,2:end]
set_parameter!(m, :Mortality, :a, cubic_coeffs[:,1])
set_parameter!(m, :Mortality, :b, cubic_coeffs[:,2])
set_parameter!(m, :Mortality, :c, cubic_coeffs[:,3])
set_parameter!(m, :Mortality, :d, cubic_coeffs[:,4])

set_parameter!(m, :Mortality, :vsl, readcsv(joinpath(@__DIR__, "../data/vsl.csv"))[2:6,2:10])

run(m)

m[:Mortality, :mortality_damages]