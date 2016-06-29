function s_da_0 = draw_s_da_0(params,dev_w_da)
% Draw day-ahead demand-wind forecasts (DA s0 state) with varying intensity.

run('get_global_constants.m');
%% draw DA demand
mpc = params.mpcase;
demand=mpc.bus(:,PD)*0.15; %demand will start low - 0.15 of peak demand
isStochastic=false;
demand_factor_mat = repmat(getHourlyDemandFactor(1:params.da_horizon)',[params.nb,1]);
s_da_0.demand = repmat(demand,[1,params.da_horizon]).*demand_factor_mat;
%% draw DA wind
if(nargin==1)
    i_w_da = randsample(1:length(params.dev_w_vec_da),1);
    dev_w_da = params.dev_w_vec_da(i_w_da);
end
w = generateWind(1:params.da_horizon, params, isStochastic)*(1+dev_w_da);
w = max(w,0);

s_da_0.wind = w;
%% quick fix for drawing demand as well
s_da_0.demand = s_da_0.demand*(1-dev_w_da);
%% print for debug
% sum(s_da_0.demand-s_da_0.wind)
