using Mimi

@defcomp RegionalAggregation begin

    # Define additional indices
    countries   = Index()
    regions     = Index()

    # Define input parameters
    weights     = Parameter(index = [time, countries])  # Multiplicative weighting to use in regional averages, i.e. population
    div_flag    = Parameter(default = true)   # TODO: type as boolean? # flag for whether you divide by weights after taking the weighted sum
    mapping     = Parameter(index = [countries])        # A mapping of countries to regions
    input       = Parameter(index = [time, countries])  # Data originally at the country level to be aggregated

    # Define variables to calculate
    output    = Variable(index = [time, regions])

    # Define run timestep function
    function run_timestep(p, v, d, t)

        # Weight the original data
        weighted = p.weights[t, :] .* p.input[t, :]

        for r in d.regions 
            if p.div_flag 
                v.output[t, r] = sum(weighted .* (p.mapping .== r)) / sum(p.weights[t, :] .* (p.mapping .== r))
            else 
                v.output[t, r] = sum(weighted .* (p.mapping .== r))
            end
        end
        
    end 
end