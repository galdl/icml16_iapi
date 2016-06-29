function [w, Pr] =  generateWind(timesOfDay, params, isStochastic,dev_w)
if(nargin<=3)
    dev_w=0;
end

N = length(timesOfDay);
w = zeros(params.nb,N);
Pr = ones(params.nb,N);
buses = params.windBuses;
num_buses = length(buses);

if(~isempty(buses))
    mu = zeros(params.nb,N);
    mu(buses,:) = params.windHourlyForcast(timesOfDay,1:num_buses)';
    if(isfield(params,'windScaleRatio') && ~isempty(params.windScaleRatio))
        mu = mu/params.windScaleRatio;
    end
    
    
    if(exist('isStochastic','var') && isStochastic)
        if(isfield(params,'muStdRatio') && ~isempty(params.muStdRatio))
            muStdRatio=params.muStdRatio;
        else
            muStdRatio = 0.15;
        end
%         [w, Pr] = drawSample(mu, params, muStdRatio);
        w = max(mu.*(1+dev_w), 0);
    else w = mu;
    end
end
w = max(0,w);


