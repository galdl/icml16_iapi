function [dailyGenerationPrediction,voltage_setpoints] = get_daily_generation_prediction(da_action,s_da_td,params)
run('get_global_constants.m');

dailyGenerationPrediction=zeros(params.ng,params.da_horizon);
mpopt = mpoption('out.all', 0,'verbose', 0);
mpc = params.mpcase;
mpc.gen(:,GEN_STATUS) = da_action;
hourlyMpcase=mpc;
voltage_setpoints = zeros(params.ng,params.da_horizon);
for t=1:24
    %     hourlyMpcase.bus(:,PD) =  demand*getHourlyDemandFactor(t) - generateWind(t, params, isStochastic) ;
    %s_da is suppose to contain both demand and wind predictions, so replace
    %both with its predictions
    hourlyMpcase.bus(:,PD) =  s_da_td.demand(:,t) - s_da_td.wind(:,t);
    %% get optimal generation for no-contingency case, and set it for PF runs
    if(strcmp(params.caseName,'case96'))
        pfRes = runopf(hourlyMpcase,mpopt);
        hourlyMpcase.gen(:,VG) = pfRes.gen(:,VG);
        voltage_setpoints(:,t) = pfRes.gen(:,VG);
    else
        pfRes = rundcopf(hourlyMpcase,mpopt);
    end
    hourlyMpcase.gen(:,PG) = pfRes.gen(:,PG);
    
    pfRes=runpf(hourlyMpcase,mpopt);
    dailyGenerationPrediction(:,t)=pfRes.gen(:,PG);
end
%% DB - testing power-flow results
% pfResults(t,1) = pfRes.success;
% pfResults(t,2) = pfRes.success;
