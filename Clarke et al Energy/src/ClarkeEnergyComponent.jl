using Mimi

@defcomp ClarkeEnergy begin

    E_H     = Variable(index=[time, regions])   # per capita expenditures for space heating in buildings
    E_C     = Variable(index=[time, regions])   # per capita expenditures for space cooling in buildings
    E_total = Variable(index=[time, regions])   # per capita expenditures for space heating and cooling in buildings
    D_H     = Variable(index=[time, regions])   # per capita heating demand
    D_C     = Variable(index=[time, regions])   # per capita cooling demand
    d_H     = Variable(index=[time, regions])   # heating consumption per unit floorspace (TODO: area units?)
    d_C     = Variable(index=[time, regions])   # cooling consumption per unit floorspce
    P_H     = Variable(index=[time, regions])   # price for heating (TODO: units = dollars/energy ?)
    P_C     = Variable(index=[time, regions])   # price for cooling

    # Component-specific exogenous parameters
    f       = Parameter(index=[time, regions])  # floorspace per capita
    k_H     = Parameter(index=[regions])        # unitless heating calibration coefficient
    k_C     = Parameter(index=[regions])        # unitless cooling calibration coefficient
    eta     = Parameter(index=[time, regions])  # thermal conductance of the building as a whole (TODO: is this an average over all buildings weighted by floorspace?)
    R       = Parameter(index=[time, regions])  # unitless average surface-to-floor area ratio (translates floorspace into the total surface of a building that is in contact with the ambient atmosphere)
    IG      = Parameter(index=[time, regions])  # internal gain [GJ/m^2] from heat released by equipment operating in the building (TODO: calculated endogenously by Clarke et al, but exogenous here?)
    miu_H   = Parameter(index=[regions])        # degree of heating demand satiation given a level of service
    miu_C   = Parameter(index=[regions])        # degree of cooling demand satiation given a level of service
    # B_H     = Parameter(index=[time, regions])  # behavioral term that captures per capita energy service demand per unit of HDD
    # B_C     = Parameter(index=[time, regions])  # behavioral term that captures per capita energy service demand per unit of CDD

    # Socioeconomic parameters
    i       = Parameter(index=[time, regions])   # per capita income

    # Climate parameters
    HDD     = Parameter(index=[time, regions])   # Heating degree days
    CDD     = Parameter(index=[time, regions])   # Cooling degree days

    function run_timestep(p, v, d, t)
        for r in d.regions 
            # Calculate price (TODO: how?)
            v.P_H[t, r] = 
            v.P_C[t, r] = 

            # Calculate demand per unit floor space
            v.d_H[t, r] = p.k_H[r] * (p.HDD[t, r] * p.eta[t, r] * p.R[t, r] - p.IG[t, r]) * (1 - exp(-log(2) / p.miu_H[r] * p.i[t, r] / v.P_H[t, r]))
            v.d_C[t, r] = p.k_C[r] * (p.CDD[t, r] * p.eta[t, r] * p.R[t, r] + p.IG[t, r]) * (1 - exp(-log(2) / p.miu_C[r] * p.i[t, r] / v.P_C[t, r]))
            # v.d_H[t, r] = p.B_H[t, r] * p.HDD[t, r]   # simplified decomposition shown in eq. 7
            # v.d_C[t, r] = p.B_C[t, r] * p.CDD[t, r]   # simplified decomposition shown in eq. 8

            # Calculate demand
            v.D_H[t, r] = p.f[t, r] * v.d_H[t, r]
            v.D_C[t, r] = p.f[t, r] * v.d_C[t, r]

            # Calculate per capita expenditures
            v.E_H[t, r] = v.D_H[t, r] * v.P_H[t, r]
            v.E_C[t, r] = v.D_C[t, r] * v.P_C[t, r]
            v.E_total = v.E_H[t, r] + v.E_C[t, r]
        end
    end 
end