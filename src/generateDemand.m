function [d, Pr] =  generateDemand(hour, params, isStochastic,dev_d)
if(nargin<=3)
    dev_d=0;
end
d=getHourlyDemand(hour,params);
Pr = ones(size(d));
if(isStochastic)
%     d = max(d + randn(size(d)).*params.demandStdFraction.*d, 0);
%     deviation = randn.*params.demandStdFraction;
    d = max(d.*(1+dev_d), 0);

end

end

function hourlyDemand=getHourlyDemand(hour,params)
    hourlyDemand=getHourlyDemandFactor(hour)*getMaxDemand(params);
end

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
end

function maxDemand = getMaxDemand(params)
    run('get_global_constants.m');
    maxDemand = params.mpcase.bus(:,PD); 
end