%% Parameters configuration file for the test-cases, algorithm, distributions and simulation

%% case params
if(sum(strcmp(caseName,{'case5','case9','case14','case24','case24_ieee_rts','case96'}))>0)
    caseParams=getSpecificCaseParams(caseName);
else
    caseParams.windBuses=[5,6];
    caseParams.windHourlyForcast = getWindHourlyForcast(caseParams.windBuses);
    caseParams.windScaleRatio=10;
end
%% horizon params
params.da_horizon=24;
%% general params
params.mpcase=mpcase;
% small corrections needed for RTS96 network
if(strcmp('case96',params.caseName))
    case24_copy = case24_ieee_rts;
    case24_pmin = case24_copy.gen(:,PMIN);
    params.mpcase.gen(:,PMIN) = repmat(case24_pmin,[3,1]);
end
% in case we include budget in the future
params.initialBudget=inf;
% std of the demand process, as fraction of the mean
params.demandStdFraction = 0.02;
% how long it takes to fix a line
params.contingencyCounter = 5;
% different probabilities of failures ('contingencies') for different
% networks
if(strcmp('case24_ieee_rts',params.caseName))
    params.Pcont = 5e-5;
elseif(strcmp('case96',params.caseName))
    params.Pcont = 1e-5;
else
    params.Pcont = 5e-3; 
end
% TD algorithm step size
params.TD_step_size = 0.1;
% MDP discount factor
params.gamma = 0.95;

%% generator params
%percentage of max to be used as upper and lower margin for generator redispatch policy
params.margin = 0;
% if ture, while (effective) demand is less than minimal generation - switch off generators
params.allow_gen_switchoff = true;
params.ci = getGeneratorPrices(mpcase);

% generator production cost is just a constant currently, that determines
% the real-time dispatch policy. Other than that, it plays no role.
params.mpcase.gencost(:,MODEL)=2; %polynomial cost type
params.mpcase.gencost(:,NCOST)=1; %0-degree polynomial
params.mpcase.gencost(:,COST) = params.ci;
%% wind params
params.windBuses = caseParams.windBuses;
params.windHourlyForcast = caseParams.windHourlyForcast;
params.windScaleRatio=caseParams.windScaleRatio; %%wind generation mean will be devided by this factor
%% possbile deviations of wind and demand
params.dev_w_vec = linspace(0.05,-0.05,10);
params.dev_w_vec_da = linspace(0.1,-0.1,3);
params.dev_d_vec = linspace(-0.02,0.02,10);
% day-ahead demand-wind forecast (DA s0 state) realizations are drawn out
%of a number of possible days with varying intensity. Each such day has a
%different forecast mean. The number of the different days is N_s_da_0
params.N_s_da_0 = 5;
%% RT simulation length params
if(strcmp('case24_ieee_rts',params.caseName))
    params.N_episode = 2; %10
elseif(strcmp('case96',params.caseName))
    params.N_episode = 5; %10
else
    params.N_episode = 1;
end
params.num_of_days=3; %3
