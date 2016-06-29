%% Configuration file is used for setting environment params, such as paths

% set run mode - optimize and find optimal plan, or compare to other
%algorithms
config.run_mode = 'optimize'; %'compare'
config.remote_cluster = true;
%% Local paths - on the machine running main
config.LOCAL_DIR_ROOT  = '~/mount/ICML16/';
config.JOB_DATA_FILENAME = 'psi_content';
config.JOB_OUTPUT_FILENAME = [config.run_mode,'-job_output.mat'];

%% Remote paths - on the server running the jobs 
% (setting whether such server is used is done with 'remote_cluster' variable)
config.REMOTE_DIR_ROOT = '/u/gald/ICML16/';

% relative dir is shared among the local and remote dirs. 
config.RELATIVE_DIR_OPTIMIZE    = 'proxy_mdp_latest/saved_runs/Optimize/';
config.RELATIVE_DIR_COMPARE = 'proxy_mdp_latest/saved_runs/Compare/';

config.JOB_DIRNAME_PREFIX = 'job_data_';
config.CLUSTER_OUTPUT_DIRNAME = 'output';
config.CLUSTER_ERROR_DIRNAME = 'error';
config.TEMPFILES_DIR = '/tempJobFiles';
config.JOB_NAME_PREFIX = 'psi';
% the portions of the jobs that returned from the server, to 
config.fraction_of_finished_jobs=0.95;
