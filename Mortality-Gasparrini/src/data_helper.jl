
function load_daily_temps(n=365)

    temps = zeros(5,9,n)

    for r in 1:9
        temps[:,:,:] = 20
    end 
    
    return temps 

end 