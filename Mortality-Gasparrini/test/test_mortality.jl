using Mimi

include("../src/MortalityComponent.jl")
include("../src/data_helper.jl")

num_days = 365

m = Model()
setindex(m, :time, 2010:10:2050)
setindex(m, :region, ["North America", 
                    "Central America", 
                    "South America", 
                    "North Europe", 
                    "Central Europe",
                    "South Europe",
                    "East Asia",
                    "South East Asia",
                    "Australia"])
setindex(m, :days, 1:num_days)

addcomponent(m, Mortality)
setparameter(m, :Mortality, :daily_mean_temp, load_daily_temps(num_days))
setparameter(m, :Mortality, :optimal_mort, 100*ones(9))

cubic_coeffs = readcsv("data/cubic_coefficients.csv")[2:end,2:end]
setparameter(m, :Mortality, :a, cubic_coeffs[:,1])
setparameter(m, :Mortality, :b, cubic_coeffs[:,2])
setparameter(m, :Mortality, :c, cubic_coeffs[:,3])
setparameter(m, :Mortality, :d, cubic_coeffs[:,4])

setparameter(m, :Mortality, :vsl, ones(5,9))

run(m)

m[:Mortality, :mortality_damages]