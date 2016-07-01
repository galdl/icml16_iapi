%% initialize program
warning off
configuration
set_global_constants()
run('get_global_constants.m')
prefix_num = 1;
%% build directory structure
[job_dirname_prefix,full_localRun_dir,job_data_filename,job_output_filename...
    ,full_remoteRun_dir,full_tempFiles_dir] = build_dirs(prefix_num,config);
%% cluster job configuration
jobArgs = set_job_args(prefix_num,config);
%% set test case params
caseName = 'case96'; %case5,case9,case14,case24
params=get_testCase_params(caseName,config);
params.action_set = generate_da_action_set(params);
s_da_0_cell = generate_s_da_0_set(params);
%% meta-optimizer iterations
N_IAPI=15;
N_jobs = 202; %244
maxConcurrentJobs=202; %244
%% meta-optimizer parameters
epsilon=0.005;
rho = 0.2;
pauseDuration=40; %seconds
timeOutLimit=60*pauseDuration*3;
%% %% meta-optimizer initialization
i_IAPI=1;
top_psi = get_psi_initial(s_da_0_cell,params,N_jobs);
CE_stats = cell(3,N_IAPI);
N_CE_inner=ceil(N_jobs/maxConcurrentJobs);
%% start by killing all current jobs
if(config.remote_cluster)
    killRemainingJobs(jobArgs);
    pause(3);
end
%% optimization iterations - each w/ multiple solutions (N_psi)
while(i_IAPI<=N_IAPI) % && ~convergenceObtained(p,epsilon)
    try
        %% build iteration dir
        relativeIterDir=['/iteration_',num2str(i_IAPI)];
        localIterDir=[full_localRun_dir,relativeIterDir];
        remoteIterDir=[full_remoteRun_dir,relativeIterDir];
        mkdir(localIterDir);
        %% initialize iteration variables
        theta_psi = [];
        phi_hist_full = [];
        %% draw new DA psi's
        X = draw_new_psi(top_psi,N_jobs,double(i_IAPI));
        X=X(:,randperm(size(X,2)));
        %% evaluate RT theta per each psi and save united history of states
        %% prepere jobs and send all of them to cluster
        previousIterationsJobs=0;
        for i_CE_inner=1:N_CE_inner
            display([datestr(clock,'yyyy-mm-dd-HH-MM-SS'),' - ','Iteration ',num2str(i_IAPI),' Sending new jobs...']);
            
            innerPsiRange=(i_CE_inner-1)*maxConcurrentJobs+1:min(i_CE_inner*maxConcurrentJobs,N_jobs);
            for i_psi=innerPsiRange
                [localPsiDir,argContentFilename,remotePsiDir]=...
                    perparePsiDir(localIterDir,remoteIterDir,i_psi,X,s_da_0_cell,job_data_filename,job_dirname_prefix,params);
                [funcArgs,jobArgs]=...
                    perpareJobArgs(i_psi,i_IAPI,localPsiDir,argContentFilename,remotePsiDir,jobArgs);
                if(config.remote_cluster)
                    sendJob('evaluate_theta_job',funcArgs,jobArgs);
                else
                    loaded_arguments =load([localPsiDir,'/',argContentFilename]);
                    [theta,phi_hist] = evaluate_theta_pi(loaded_arguments.psi,loaded_arguments.s_da_0_cell,loaded_arguments.params);
                    save([localPsiDir , '/',config.JOB_OUTPUT_FILENAME'],'theta','phi_hist');
                end

            end
            mostFinished=0;
            c=1;
            jobsWaitingToFinish=length(innerPsiRange);
            display([datestr(clock,'yyyy-mm-dd-HH-MM-SS'),' - ','Iteration ',num2str(i_IAPI),' (inner iteration ',num2str(i_CE_inner),')',...
                ':waiting for at least ',num2str(ceil(config.fraction_of_finished_jobs*jobsWaitingToFinish)),' of ',num2str(jobsWaitingToFinish),' jobs...']);
            timeOutCounter=0;
            numFinishedFiles=0;
            newJobsFinished=false;
            %% wait for enough jobs to finish
            while((~mostFinished && timeOutCounter<=timeOutLimit) || newJobsFinished)
                jobsBefore = numFinishedFiles;
                pause(pauseDuration);
                [mostFinished,numFinishedFiles]= ...
                    checkIfMostFinished(config.fraction_of_finished_jobs,jobsWaitingToFinish,previousIterationsJobs,localIterDir,job_output_filename);
                c=c+1;
                timeOutCounter=timeOutCounter+pauseDuration;
                newJobsFinished = ((numFinishedFiles-jobsBefore)>0);
            end
            %% after enough jobs finished - destroy remaining
            previousIterationsJobs=numFinishedFiles;
            display([num2str(timeOutCounter),' seconds passed. ','Num of finished files: ',num2str(numFinishedFiles)]);
            killRemainingJobs(jobArgs);
        end
        deleteUnnecessaryTempFiles(full_tempFiles_dir);
        %% evaluate v^pi per each psi
        [theta_psi,phi_hist_united,finished_idx,v_pi_local] = extractVIData_case24(localIterDir,N_jobs,job_dirname_prefix,job_output_filename,params);
%         v_pi = mean(theta_psi(:,finished_idx)'*phi_hist_united,2);
%         v_pi_local = get_local_v_pi(theta_psi,phi_hist_united,finished_idx,phi_hist_single_size);
        CE_stats{1,i_IAPI} = X(:,finished_idx);
        CE_stats{2,i_IAPI} = theta_psi(:,finished_idx);
        CE_stats{3,i_IAPI} = v_pi_local(finished_idx); %v_pi
%         v_pi
%         CE_stats{4,i_CE} = v_pi_local;
        
        [~,I] = sort(v_pi_local,'descend');
        %% get best psi's
        topI = I(1:ceil(length(I)*rho));
        top_psi = X(:,topI);
    catch ME
        warning(['Problem using main_CE_API_hermes_24 for iteration = ' num2str(i_IAPI)]);
        msgString = getReport(ME);
        display(msgString);
    end
    i_IAPI=i_IAPI+1;
    save([full_localRun_dir,'/CE_run_96_partial.mat']);
end
%% eliminate nan's and zeros
CE_stats(:,i_IAPI:end)=[];
for j=1:i_IAPI-1
    v_pi_local = CE_stats{3,j};
    v_pi_local=v_pi_local(~isnan(v_pi_local));
    CE_stats{3,j}=v_pi_local;
    psi = CE_stats{1,j};
    phi = CE_stats{2,j};
    v_pi_local = CE_stats{3,j};
    locs = find(v_pi_local);
    CE_stats{1,j}=psi(:,locs);
    CE_stats{2,j}=phi(:,locs);
    CE_stats{3,j}=v_pi_local(locs);
end
%% save final file and plot the results
save([full_localRun_dir,'/CE_run_96.mat']);
plot_results

% i_CE = i_CE -1;
% v_pi=CE_stats{3,i_CE};
% size(v_pi)
%   [~,I] = sort(v_pi,'descend');
% topI = I(1:ceil(length(I)*rho));
% X = CE_stats{1,i_CE};
%  top_psi = X(:,topI);