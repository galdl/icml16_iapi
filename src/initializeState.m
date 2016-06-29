function initialState = initializeState(da_market,params)
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
