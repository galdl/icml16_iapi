function params = getProblemParamsForCase(caseName)

%% seperate the edited cases (which include dynamic parameters for UC,
%% s.a min up/down times, initial state, etc.) and the non-edited, classic matpower cases
if(sum(strcmp(caseName,{'case5','case9','case14','case24'}))>0)
    params.caseName=caseName;
    caseParams=getSpecificCaseParams(caseName);
    generatorTypeVector=caseParams.generatorTypeVector;
    generatorBusVector=caseParams.generatorBusVector;
    params.initialGeneratorState=caseParams.initialGeneratorState;
    loads=caseParams.loads; 
    params.windScaleRatio=caseParams.windScaleRatio; %%wind generation mean will be devided by this factor
    
    generatorData=getGeneratorData();
    mpcase=setCaseParams(caseName,generatorData,generatorTypeVector,generatorBusVector,loads,caseParams);
%     if(strcmp(caseName,'case5'))
%         mpcase.branch=[mpcase.branch;mpcase.branch(5,:)];
%         mpcase.branch(7,1)=3;  %add line between bus 3 and 5 with no rating limits
%         mpcase.branch(7,2)=5;
%     end
    unitsInfo=[];
    for g=generatorTypeVector
        unitsInfo=[unitsInfo;generatorData{g}.PMIN,generatorData{g}.PMAX,generatorData{g}.MD,generatorData{g}.MU];
    end
    params.MD=3; %column enum, not value!
    params.MU=4;
    params.unitsInfo=unitsInfo;
    
    params.generatorTypeVector=generatorTypeVector;
    params.generatorBusVector=generatorBusVector;
    params.generatorData=generatorData;
else
    funcHandle=str2func(caseName);
    mpcase=funcHandle();
end
params.mpcase=mpcase;
params.verbose=0;
params.horizon=24;
%% data dimensions
params.nb   = size(mpcase.bus, 1);    %% number of buses
params.nl   = size(mpcase.branch, 1); %% number of branches
params.ng   = size(mpcase.gen, 1);    %% number of dispatchable injections
%% wind params
params.windBuses = caseParams.windBuses;
params.windHourlyForcast = caseParams.windHourlyForcast;
params.windCurtailmentPrice=100; %[$/MW]
%% VOLL
params.VOLL = 1000;
%% fine payment escalation cost 
params.finePayment = 3*sum(mpcase.bus(:,3))*params.VOLL; %multiple of the full LS cost
params.fixDuration=24;
%% simulation length parameters
%in case5, 4 months, 75 plans , 2x10 - finished in 40 mins
%in case9, 4 months, 75 plans , 2x25 - finished in 4 hours
%in case9, 8 months, 75 plans , 3x25 - in 7 hours t.o, 280 out of 600
%reached
% in case24, 4 months, 75 plans, params.numOfDaysPerMonth=2;
% params.dynamicSamplesPerDay=15; - in 7 hours timeout, 100 of 300 plans
% finished
params.numOfDaysPerMonth=3;
params.dynamicSamplesPerDay=5;
% params.numOfDaysPerMonth=2;
% params.dynamicSamplesPerDay=6;
params.N_plans=75;
params.numOfMonths=8;
params.myopicUCForecast=1;
%% contingency 
params.Pcont = 0.001*ones(params.nl, 1);    %probability of contingency (maybe length dependent)
params.contingencyCounter = 8; 

%% redispatch budget
params.ci = 100*ones(size(mpcase.gen, 1), 1);   %TODO: need to make case specific

%% demand parameters
params.demandStdFraction = 0.02;
%% optimization settings
% params.optimizationSettings =  sdpsettings('solver','mosek','mosek.MSK_DPAR_MIO_MAX_TIME',200,'verbose',params.verbose); %gurobi,sdpa,mosek
% params.optimizationSettings =  sdpsettings('solver','mosek','verbose',params.verbose);
% params.optimizationSettings = sdpsettings('solver','cplex','cplex.timelimit',5,'verbose',params.verbose); %gurobi,sdpa,mosek

params.optimizationSettings = sdpsettings('solver','cplex','verbose',params.verbose);

% ops = sdpsettings('solver','cplex');

