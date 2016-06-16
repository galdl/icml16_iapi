function pfResults = getDailyGenerationPrediction_testing(da_action,s_da_td,params)
run('get_global_constants.m');
pfResults = zeros(24,2);
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
    pfResults(t,1) = dcPfRes.success;
    pfRes=runpf(hourlyMpcase,mpopt);  
     pfResults(t,2) = pfRes.success;
end