## Notes on needed inputs

Internal model parameters:
- daily mean temperature (vector of length 365 for each region and each year)

External parameters from Gasparrini research:
- coefficients for the cubic relative risk functions for each region
- mortality levels (number of deaths) at optimal temperature for each region 

Other external parameters needed:
- VSL for all regions and years (in order to do economic valuation)


## Notes on "days" index

In addition to the region and time indices, this component also requires a "days" index.

The time index in the model reflects the yearly timesteps, but this component requires
daily mean temperature values, which is the level at which the relative risk function
is calculated for excess mortality (in %). This then gets summed to an annual/regional 
level for number of deaths. 


## Outstanding questions

- Is the step from excess mortality (in percent) to total number of deaths done correctly? deaths = RR x (expected # of deaths under optimal temperature)
- How do we get the expected number of deaths under optimal temperature for each region, and should it scale with population growth?
- Related to the above two, is this the correct formula for economic valuation: econ_damages = (number of deaths) x (vsl) ? Or is there a way to go from excess mortality (in % above optimal mortality) to economic damages?
- How can adaptation be incorporated?