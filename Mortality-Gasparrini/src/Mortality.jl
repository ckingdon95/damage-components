using Mimi

@defcomp Mortality begin

    # Regional index
    region  = Index()
    days    = Index()

    # Input parameters
    daily_mean_temp     = Parameter(index = [time, region, days])   # 365 mean daily temps for each region for each year
    optimal_mort        = Parameter(index = [region])               # Number of deaths under optimal temperature for each region
    a                   = Parameter(index = [region])               # Cubic coefficient
    b                   = Parameter(index = [region])               # Quadratic coefficient
    c                   = Parameter(index = [region])               # Linear coefficient
    d                   = Parameter(index = [region])               # constant
    vsl                 = Parameter(index = [time, region])         # Value of a Statistical Life for each region and year

    # Variables to calculate
    RR                  = Variable(index = [time, region, days])     # Relative Risk (or Excess mortality) as a percent relative to optimal temperature for each day
    deaths              = Variable(index = [time, region])          # Excess mortality (number of deaths)
    econ_damages        = Variable(index = [time, region])          # Economic valuation of excess mortality

end

function run_timestep(s::Mortality, t::Int)

    v, p, d = s.Variables, s.Parameters, s.Dimensions

    # for r in d.region 
    #     temp = p.daily_mean_temp[t, r, :]
    #     v.RR[t, r, :] = p.a[r] * temp.^3 + p.b[r] * temp.^2 + p.c[r] * temp + p.d 
    #     v.deaths[t, r] = sum(v.RR[t, r, :] * p.optimal_mort[r])
    #     v.econ_damages[t, r] = v.deaths[t, r] * p.vsl[t, r]
    # end

    temp = p.daily_mean_temp[t, :, :]

    v.RR[t, :, :] = p.a .* temp.^3 .+ p.b .* temp.^2 .+ p.c .* temp .+ p.d
    v.deaths[t, :] = sum(v.RR[t, :, :] .* p.optimal_mort, 2)
    v.econ_damages[t, :] = v.deaths[t, :] .* p.vsl[t, :]

end