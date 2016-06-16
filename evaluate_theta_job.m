% runs from distant node. Therefore - generates params itself, and reads
% arguemnts from local file
function []=evaluate_theta_job_compare(argeumentFileDir,argeumentFilename)
if(strcmp('/u/gald/ICML16/proxy_mdp_latest',eval('pwd')))
    addpath(genpath('/u/gald/Asset_Management/matlab/matpower5.1/'));
    sets_global_constants;
end
rng('shuffle');
addHermesPaths;
%% load arguments
loaded_arguments =load([argeumentFileDir,'/',argeumentFilename]);
%% call evaluate_theta
[theta,phi_hist] = evaluate_theta_pi(loaded_arguments.psi,loaded_arguments.s_da_0_cell,loaded_arguments.params);
sz = size(phi_hist);
if(length(sz)>2)
    phi_hist = reshape(phi_hist,[sz(1),sz(2)*sz(3)]);
end
%% save output to file
save([argeumentFileDir , '/evaluate_theta_job_output.mat'],'theta','phi_hist');