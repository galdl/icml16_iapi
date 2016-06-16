function dailyGenerationPrediction = getDailyGenerationPrediction(da_action,s_da_td,params)
run('get_global_constants.m');

dailyGenerationPrediction=zeros(params.ng,params.da_horizon);
mpopt = mpoption('out.all', 0,'verbose', 0);
mpc = params.mpcase;
mpc.gen(:,GEN_STATUS) = da_action;
hourlyMpcase=mpc;
for t=1:24
%     hourlyMpcase.bus(:,PD) =  demand*getHourlyDemandFactor(t) - generateWind(t, params, isStochastic) ;
%s_da is suppose to contain both demand and wind predictions, so replace
%both with its predictions
    hourlyMpcase.bus(:,PD) =  s_da_td.demand(:,t) - s_da_td.wind(:,t);
    %% get optimal generation for no-contingency case, and set it for PF runs
    dcPfRes = rundcopf(hourlyMpcase,mpopt);
    hourlyMpcase.gen(:,PG) = dcPfRes.gen(:,PG);
    pfRes=runpf(hourlyMpcase,mpopt);  
    dailyGenerationPrediction(:,t)=pfRes.gen(:,PG);
end