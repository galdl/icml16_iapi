function hourlyDemandFactor=getHourlyDemandFactor(hourOfDay)
fullVector=[0.67;0.63;0.6;0.59;0.59;0.6;0.74;0.86;0.95;0.96;0.96;0.95;0.95;0.95;0.93;0.94;0.99;1;1;0.96;0.91;0.83;0.73;0.63];
if nargin>0
    if(hourOfDay==0)
        hourlyDemandFactor=fullVector(end);
    else
        hourlyDemandFactor=fullVector(hourOfDay);
    end
else
    hourlyDemandFactor=fullVector;
end
