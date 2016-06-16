function initialState = initializeState(da_market,params,s_da_td)
run('get_global_constants.m');
t=1;
initialState.t=t;
isStochastic=0;dev_w=0;
initialState.w = generateWind(t, params, isStochastic,dev_w);
initialState.e = zeros(params.nl, 1);

initialState.d = params.mpcase.bus(:,PD)*getHourlyDemandFactor(t);
% da_market=getDailyGenerationPrediction(params);
initialState.g =  da_market(:,t);
initialState.b=params.initialBudget;
initialState.wind_curtailment = false;
initialState.commited_generators = ones(params.nb,1);

if(nargin>2)
    i_d=randsample(1:length(params.dev_d_vec),1);
    initialState.eff_d_deviation = s_da_td.demand(:,1).*params.dev_d_vec(i_d);
    initialState.d = s_da_td.demand(:,1) + initialState.eff_d_deviation;
    initialState.w = s_da_td.wind(:,1);
end
