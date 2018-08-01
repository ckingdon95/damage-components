using Mimi

@defcomp GDP begin

    regions   = Index()

    # Input parameters
    gdp_path_num    = Parameter(default = 1) # Which of the 2000 paths is used
    gdp_cap         = Parameter(index = [time, regions]) # GDP per capita (set in pre_trial_func based on MCS generated gdp_path_num)
    # population      = Parameter(index = [time, regions]) # Regional population

    # Variables to calculate
    gdp_cap_growth          = Variable(index = [time, regions]) # GDP per capita growth rate
    global_gdp_cap          = Variable(index = [time]) # Global gdp per capita
    global_gdp_cap_growth   = Variable(index = [time]) # Global gdp per capita growth rate

    # gdp         = Variable(index = [time, regions]) # Total regional GDP
    # global_gdp  = Variable(index = [time]) # Total global GDP


    # Define run_timestep function
    function run_timestep(p, v, d, t)

        if !isfirst(t)
            v.gdp_cap_growth[t, :] = (p.gdp_cap[t, :] - p.gdp_cap[t - 1, :]) / p.gdp_cap[t - 1, :]
        end

    end 
end 