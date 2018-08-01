using Mimi

include("GDPComponent.jl")
include(joinpath(@__DIR__, "../../Regional-Aggregation/src/RegionalAggregation.jl"))

include("defmcs.jl")

gdp_dir = joinpath(@__DIR__, "../data/mws-gdp")

function _run(; trials = 10)

    m = Model()
    set_dimension!(m, :time, 1915:2300)
    set_dimension!(m, :countries, ["a","b","c","d"])#readcsv())
    set_dimension!(m, :regions, ["A","B"])#readcsv())

    # addcomponent(m, GDPcap, :gdp)
    add_comp!(m, RegionalAggregation, :regagg)
    add_comp!(m, GDP, :gdp)

    set_param!(m, :regagg, :weights, ones(386,4))#readcsv("data/population.csv"))
    set_param!(m, :regagg, :mapping, [1,1,2,2,])#readcsv("data/region_mapping.csv"))
    set_param!(m, :regagg, :input, ones(386,4)) # dummy default so model can be built; then this value is actually set in pre_trial_func
    
    connect_param!(m, :gdp, :gdp_cap, :regagg, :output)

    function pre_trial_func(mcs::MonteCarloSimulation, trialnum::Int, ntimesteps::Int, tup::Union{Tuple, Void})

        # Get current model instance
        m = mcs.models[1]

        # Get gdp path number from trial data?
        i = m[:gdp, :gdp_path_num]
        # i = Mimi.external_param(m, :gdp_path_num)
        println(i)

        # Read GDP values for this draw and set the parameter
        gdp_data = readcsv(joinpath(gdp_dir, "$i.csv"))
        set_parameter!(m, :regagg, :input, gdp_data)

    end 

    # generate_trials!(mcs, trials)
    run_mcs(mcs, m, trials; pre_trial_func = pre_trial_func)

end