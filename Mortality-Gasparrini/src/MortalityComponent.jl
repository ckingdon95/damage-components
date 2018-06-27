using Mimi

@defcomp Mortality begin

    # Define additional indices
    region  = Index()
    days    = Index()

    # Input parameters
    daily_mean_temp     = Parameter(index = [time, region, days])   # 365 mean daily temps for each region for each year
    a                   = Parameter(index = [region])               # Cubic coefficient
    b                   = Parameter(index = [region])               # Quadratic coefficient
    c                   = Parameter(index = [region])               # Linear coefficient
    d                   = Parameter(index = [region])               # constant
    optimal_mort        = Parameter(index = [region])               # Annual number of deaths under optimal temperature for each region
    vsl                 = Parameter(index = [time, region])         # Value of a Statistical Life for each region and year

    # Variables to calculate
    RR_daily            = Variable(index = [time, region, days])    # Relative Risk (or excess mortality) as a percent relative to mortality at optimal temperature for each day
    RR                  = Variable(index = [time, region])          # Average annual value of Relative Risk (excess mortality in %)
    deaths              = Variable(index = [time, region])          # Excess mortality (number of additional deaths)
    mortality_damages   = Variable(index = [time, region])          # Economic valuation of excess mortality

end

function run_timestep(s::Mortality, t::Int)

    v, p, d = s.Variables, s.Parameters, s.Dimensions

    temp = p.daily_mean_temp[t, :, :]   # 9x365 array of daily temps for this year

    v.RR_daily[t, :, :] = p.a .* temp.^3 .+ p.b .* temp.^2 .+ p.c .* temp .+ p.d    # calculate relative risk for each region for each day (vectorized)
    v.RR[t, :] = sum(v.RR_daily[t, :, :], 2) / length(d.days)   # Average to annual relative risk
    v.deaths[t, :] = v.RR[t, :] .* p.optimal_mort

    v.mortality_damages[t, :] = v.deaths[t, :] .* p.vsl[t, :]

end