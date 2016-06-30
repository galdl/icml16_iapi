function [ params ] = get_testCase_params( caseName , config )
run('get_global_constants.m')
%need matpower for that
funcHandle=str2func(caseName);
mpcase=funcHandle();
params.caseName=caseName;
%% data dimensions
params.nb   = size(mpcase.bus, 1);    %% number of buses
params.nl   = size(mpcase.branch, 1); %% number of branches
params.ng   = size(mpcase.gen, 1);
parameters
end
%% paratmeres that worked:
% for 3 days with 7 outer iterations, step size 0.2 and gamma 1, we get
% good convergence when doing only s0 regression (GD)