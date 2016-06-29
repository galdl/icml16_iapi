%% initialize program
sets_global_constants()
run('get_global_constants.m')
prefix_num = 1;
%% build directory structure
[PSI_DIRNAME_PREFIX,fullLocalParentDir,fullRemoteParentDir,tempFilesDir,...
    GENERAL_PSI_FILENAME,job_output_filename] = build_dirs_compare(prefix_num);
%% hermes job configuration
jobArgs = set_job_args_compare_solutions(prefix_num);

%% load case params
% load file!
params.percentageTolerance = 50;

%% start by killing all current jobs
killRemainingJobs(jobArgs);
pause(1);
%% prepare string cell of heuristics to test
func_cell = {'fits_rand','fits_cheapest','fits_flexible','psi_policy_wrapper'};
params.psi = get_best_psi(CE_stats,i_CE-1);
% num_iter = i_CE-1;
N_func = length(func_cell);
i_func = 0;
concurrent = 244;
num_rounds = floor(concurrent/N_func);
%% optimization iterations - each w/ multiple solutions (N_psi)
while(i_func<N_func*num_rounds)
    try
        i_func=i_func+1;
        %% build iteration dir
        relativeIterDir=['/iteration_',num2str(i_func)];
        localIterDir=[fullLocalParentDir,relativeIterDir];
        remoteIterDir=[fullRemoteParentDir,relativeIterDir];
        mkdir(localIterDir);
        %% initialize iteration variables
        %% send jobs
        display([datestr(clock,'yyyy-mm-dd-HH-MM-SS'),' - ','Iteration ',num2str(i_func),' Sending new jobs...']);
        func_num = 1 + mod(i_func-1,N_func);
        func_handle = str2func(func_cell{func_num});
        
        
        [localPsiDir,argContentFilename,remotePsiDir]=...
            perparePsiDir_compare(i_func,localIterDir,remoteIterDir,GENERAL_PSI_FILENAME,PSI_DIRNAME_PREFIX,func_handle,s_da_0_cell,params);
        [funcArgs,jobArgs]=...
            perpareJobArgs(0,i_func,localPsiDir,argContentFilename,remotePsiDir,jobArgs);
        sendJob('compare_policy_job',funcArgs,jobArgs);
        
    catch ME
        warning(['Problem using compare_solutions_hermes for iteration = ' num2str(i_func)]);
        msgString = getReport(ME);
        display(msgString);
    end
end
mostFinished=0;
c=1;
jobsWaitingToFinish=concurrent;
display(['Waiting for ',num2str(jobsWaitingToFinish),' jobs...']);
timeOutCounter=0;
numFinishedFiles=0;
fractionOfFinishedJobs=1;
previousIterationsJobs=0;
%% wait for enough jobs to finish
while(~mostFinished && timeOutCounter<=timeOutLimit)
    pause(pauseDuration);
    [mostFinished,numFinishedFiles]= ...
        checkIfMostFinished(fractionOfFinishedJobs,jobsWaitingToFinish,previousIterationsJobs,fullLocalParentDir,job_output_filename);
    c=c+1;
    timeOutCounter=timeOutCounter+pauseDuration;
end
deleteUnnecessaryTempFiles(tempFilesDir);
%% extract and plot
rollouts = extractVIData_compare(fullLocalParentDir,concurrent,PSI_DIRNAME_PREFIX,job_output_filename,params);
% extract and plot - histogram - make sure
overall_reward = [];
value = [];
row = 1;
rollout_vec_length = params.da_horizon*params.num_of_days;
rollout_results_mat = nan(concurrent*rollout_vec_length,N_func);
for i_func = 1:concurrent
    func_index = 1 + mod(i_func-1,N_func);
    rollouts_vec = get_rollouts_vec(rollouts{i_func},rollout_vec_length);
    idx = 1 + (row-1)*rollout_vec_length:row*rollout_vec_length;
    rollout_results_mat(idx,func_index) = rollouts_vec;
    row = row+1;
end

figure(9);
clf;
min_x = min(min(rollout_results_mat));
max_x = max(max(rollout_results_mat));
color_cell = {'r','b','g','k','y','m'};
mu = zeros(N_func,1);
s = zeros(N_func,1);
num = -1;
for i_func_index = 1:N_func
    all_rollouts = rollout_results_mat(:,i_func_index);
    all_succeseeded_rollouts = all_rollouts(~isnan(all_rollouts));
    mu(i_func_index) = mean(all_succeseeded_rollouts(all_succeseeded_rollouts>num));
    s(i_func_index) = std(all_succeseeded_rollouts(all_succeseeded_rollouts>num));
    subplot(4,1,i_func_index);
    hist(all_succeseeded_rollouts(all_succeseeded_rollouts>num),rollout_vec_length);
    xlim([min_x,max_x]);
    ylim([0,800]);
end
figure(10);
clf;
boxplot(rollout_results_mat,'labels',{'Random','Cost','Elesticity','IAPI'})
set(findobj(gca,'Type','text'),'FontSize',20,'fontweight','bold')
% errorbar(mu,s,'.');

%
%
% figure(7);
% plot(overall_reward);
% legend({'random','cheapest','felxible','learned policy - best'});
% fontSize=17;
% set(gca,'fontsize',20);
% title('Compare policies','FontSize', 17);
% xlabel('CE iteration Count', 'FontSize', fontSize);
% ylabel('Rollouts sum', 'FontSize', fontSize);
%
% figure(8);
% plot(value);
% legend({'random','cheapest','felxible','learned policy - best'});
% fontSize=17;
% set(gca,'fontsize',20);
% title('Compare policies','FontSize', 17);
% xlabel('CE iteration Count', 'FontSize', fontSize);
% ylabel('Estimtated value', 'FontSize', fontSize);
%


%
% save(['comparing_runs_',datestr(clock,'yyyy-mm-dd-HH-MM-SS')]);
% figure(7);
% plot(rollouts);
% legend({'random','fits minimum demand','fits maximum demand','fits cheapest','learned policy - best','learned policy - median'});
% fontSize=17;
% set(gca,'fontsize',20);
% title('Compare policies','FontSize', 17);
% xlabel('CE iteration Count', 'FontSize', fontSize);
% ylabel('Rollout value', 'FontSize', fontSize);