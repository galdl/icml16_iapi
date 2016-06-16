function [ params ] = getParams( caseName,gamma )
run('get_global_constants.m')
funcHandle=str2func(caseName);
mpcase=funcHandle();
params.caseName=caseName;
%% data dimensions
params.nb   = size(mpcase.bus, 1);    %% number of buses
params.nl   = size(mpcase.branch, 1); %% number of branches
params.ng   = size(mpcase.gen, 1);
%% case params
if(sum(strcmp(caseName,{'case5','case9','case14','case24','case24_ieee_rts','case96'}))>0)
    caseParams=getSpecificCaseParams(caseName);
    %     caseParams.windScaleRatio=10;
else
    caseParams.windBuses=[5,6];
    %     caseParams.windBuses=[];
    caseParams.windHourlyForcast = getWindHourlyForcast(caseParams.windBuses);
    caseParams.windScaleRatio=40;
end
%% horizon params
params.da_horizon=24;
%% general params
params.mpcase=mpcase;
if(strcmp('case96',params.caseName))
    case24_copy = case24_ieee_rts;
    case24_pmin = case24_copy.gen(:,PMIN);
    params.mpcase.gen(:,PMIN) = repmat(case24_pmin,[3,1]);
end
params.initialBudget=inf;
params.demandStdFraction = 0.02;
params.contingencyCounter = 5;
if(strcmp('case24_ieee_rts',params.caseName))
    params.Pcont = 5e-3;
elseif(strcmp('case96',params.caseName))
    params.Pcont = 1e-5;
else
    params.Pcont = 5e-3; %worked nice with 5e-3 for case6ww
end
params.TD_step_size = 0.1;
if(nargin>1)
    params.gamma = gamma;
else
    params.gamma = 0.95;
end
%% generator params
params.margin = 0; %percentage of max to be used as upper and lower margin for generator redispatch policy
params.allow_gen_switchoff = true;
params.ci = getGeneratorPrices(mpcase);
params.mpcase.gencost(:,MODEL)=2; %polynomial cost type
params.mpcase.gencost(:,NCOST)=1; %0-degree polynomial
params.mpcase.gencost(:,COST) = params.ci;
%% wind params
params.windBuses = caseParams.windBuses;
params.windHourlyForcast = caseParams.windHourlyForcast;
params.windScaleRatio=caseParams.windScaleRatio; %%wind generation mean will be devided by this factor
%% deviation of wind and demand
params.dev_w_vec = linspace(0.05,-0.05,10);
params.dev_w_vec_da = linspace(0.1,-0.1,3);
params.dev_d_vec = linspace(-0.05,0.05,10);
%% DA params
params.N_s_da_0 = 5;%5
%% RT value iteration params
if(strcmp('case24_ieee_rts',params.caseName))
    params.N_episode = 5; %10
elseif(strcmp('case96',params.caseName))
    params.N_episode = 3; %10
else
    params.N_episode = 2;
end
params.num_of_days=2;%3

end
%% paratmeres that worked:
% for 3 days with 7 outer iterations, step size 0.2 and gamma 1, we get
% good convergence when doing only s0 regression (GD)