using Mimi

include("../src/Mortality.jl")
include("../src/data_helper.jl")

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
setindex(m, :days, 1:10)

addcomponent(m, Mortality)
setparameter(m, :Mortality, :daily_mean_temp, load_daily_temps(length(getindexvalues(m, :days))))
setparameter(m, :Mortality, :optimal_mort, 100*ones(9))

cubic_params = readcsv("data/cubic_parameters.csv")[2:end,2:end]
setparameter(m, :Mortality, :a, cubic_params[:,1])
setparameter(m, :Mortality, :b, cubic_params[:,2])
setparameter(m, :Mortality, :c, cubic_params[:,3])
setparameter(m, :Mortality, :d, cubic_params[:,4])

setparameter(m, :Mortality, :vsl, ones(5,9))

run(m)