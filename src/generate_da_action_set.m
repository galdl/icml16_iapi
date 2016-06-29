function action_set = generate_da_action_set(params)
% Generate the DA action set.
% DA action is a choice of a of subset of generators. This is to
% immitate the system operator's decision of interfering with the market
% outcome to impose his reliability constraints.
% Idealy, this set would be infered from data. Currently its just a fixed
% set of generator subsets, initially drawn in random, with varying sizes.

if(strcmp('case24_ieee_rts',params.caseName))
    n=5; % num of generator subgroups
    idx =  [20,30,7,29,11,33,32,5,25,22,27,12,23,13,14,18,21,2,26,16,24,10,9,8,3,17,4,15,28,6,19,31,1]; %output of randperm(33)
    action_set = get_action_subsets(idx,n,params);
    
elseif strcmp('case96',params.caseName)
    n=6;
    idx = [99,32,40,22,34,92,91,35,6,55,3,96,68,16,69,11,54,30,45,77,60,74,78,72,62,70,51,33,7,86,38,58,76,81,89,42,28,17,41,47,98,80,14,46,56,63,93,8,67,84,90,97,83,59,79,5,48,53,29,21,25,52,37,64,31,49,27,61,88,50,87,26,43,94,19,44,15,73,1,36,82,71,23,65,2,4,18,85,75,24,95,39,13,9,66,20,57,10,12];
    action_set = get_action_subsets(idx,n,params);
    
    
else
    num_actions = 6;
    action_set = zeros(params.ng,num_actions);
    
    action_set(:,1) = [1;1;0];
    action_set(:,2) = [1;0;1];
    action_set(:,3) = [0;1;1];
    action_set(:,4) = [1;1;1];
    action_set(:,5) = [1;0;0];
    action_set(:,6) = [0;1;0];
end