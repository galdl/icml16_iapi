% runs from distant node. Therefore - generates params itself, and reads
% arguemnts from local file
function []=compare_policy_job(argeumentFileDir,argeumentFilename)
if(strcmp('/u/gald/ICML16/proxy_mdp_latest',eval('pwd')))
    addpath(genpath('/u/gald/Asset_Management/matlab/matpower5.1/'));
    sets_global_constants;
end
rng('shuffle');
addHermesPaths;
%% load arguments
loaded_arguments =load([argeumentFileDir,'/',argeumentFilename]);
%% call evaluate_theta
rollout_value = evaluate_policy(loaded_arguments.func_handle,loaded_arguments.s_da_0_cell,loaded_arguments.params)

%% save output to file
save([argeumentFileDir , '/compare_policy_job_output.mat'],'rollout_value');