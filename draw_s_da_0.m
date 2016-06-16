function s_da_0 = draw_s_da_0(params,dev_w_da)
% run('get_global_constants.m');
% 
% mpc = params.mpcase;
% demand=mpc.bus(:,PD);
% isStochastic=false;
% demand_factor_mat = repmat(getHourlyDemandFactor(1:params.da_horizon)',[params.nb,1]);
% s_da_0.demand = repmat(demand,[1,params.da_horizon]).*demand_factor_mat;
% s_da_0.wind = generateWind(1:params.da_horizon, params, isStochastic);
run('get_global_constants.m');
%% draw DA demand
mpc = params.mpcase;
lowering_factor = 0.15;
if(strcmp('case6ww',params.caseName))
    lowering_factor=0.5;
end
demand=mpc.bus(:,PD)*lowering_factor; %demand will start low
isStochastic=false;
demand_factor_mat = repmat(getHourlyDemandFactor(1:params.da_horizon)',[params.nb,1]);
s_da_0.demand = repmat(demand,[1,params.da_horizon]).*demand_factor_mat;
%% draw DA wind
if(nargin==1)
    i_w_da = randsample(1:length(params.dev_w_vec_da),1);
    dev_w_da = params.dev_w_vec_da(i_w_da);
end
% dev_w_da=-1;
w = generateWind(1:params.da_horizon, params, isStochastic)*(1+dev_w_da);
w = max(w,0);

s_da_0.wind = w;
%% quick fix for drawing demand as well
s_da_0.demand = s_da_0.demand*(1-dev_w_da);
%% print for debug
sum(s_da_0.demand-s_da_0.wind)
