## Component description

The RegionalAggregation component is defined in "src/RegionalAggregation.jl". It has three dimensions: time, regions, and countries. It takes in input data at the country level and outputs the data aggregated to the region level.

Parameters needed to run this component:
- 'weights': these weights are defined at the country level to be used in aggregation (i.e. population)
- 'mapping': this is a vector the length of the number of countries that maps each country to the region it belongs to
- 'div_flag': a boolean for whether or not the weights should also be used in the denominator (TODO: is this the best way to represent the option of summing or averaging during aggregation?)
- 'input': this is the actual input data at the country level to be aggregated

## Notes/outstanding questions

- currently the 'mapping' must be numeric, and can't use the string or symbol labels of the regions
- for this to be a generic-use component, what are the different ways of aggregation we want to support?