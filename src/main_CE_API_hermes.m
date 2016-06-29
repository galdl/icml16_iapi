fractionOfFinishedJobs=0.05;
%% initialize program
sets_global_constants()
run('get_global_constants.m')
prefix_num = 1;
%% build directory structure
[PSI_DIRNAME_PREFIX,fullLocalParentDir,fullRemoteParentDir,tempFilesDir,...
    GENERAL_PSI_FILENAME,job_output_filename] = build_dirs(prefix_num);
%% hermes job configuration
jobArgs = set_job_args(prefix_num);
%% set case params
caseName = 'case6ww'; %case5,case9,case14,case24
gamma = 0.95;
params=getParams(caseName,gamma);
%make things interesting (specific for case)
params.mpcase.branch(:,RATE_A:RATE_C)=75;
params.mpcase.gen(:,PMIN)=params.mpcase.gen(:,PMIN)/3;
s_da_0_cell = generate_s_da_0_set(params);
params.action_set = generate_da_action_set(params);
%% meta-optimizer iterations
N_CE=6;
N_psi = 100;
maxConcurrentJobs=200;
%% meta-optimizer parameters
epsilon=0.005;
rho = 0.2;
pauseDuration=60; %seconds
timeOutLimit=60*pauseDuration*3;
%% %% meta-optimizer initialization
i_CE=4;
top_psi = get_psi_initial_iCE(s_da_0_cell,params,i_CE);
CE_stats = cell(4,N_CE);
N_CE_inner=ceil(N_psi/maxConcurrentJobs);
%% start by killing all current jobs
killRemainingJobs(jobArgs);
pause(5);
%% optimization iterations - each w/ multiple solutions (N_psi)
while(i_CE<=N_CE) % && ~convergenceObtained(p,epsilon)
    try
        %% build iteration dir
        relativeIterDir=['/iteration_',num2str(i_CE)];
        localIterDir=[fullLocalParentDir,relativeIterDir];
        remoteIterDir=[fullRemoteParentDir,relativeIterDir];
        mkdir(localIterDir);
        %% initialize iteration variables
        theta_psi = [];
        phi_hist_full = [];
        %% draw new DA psi's
        top_psi = get_psi_initial_iCE(s_da_0_cell,params,i_CE);
        X = draw_new_psi_zero_var(top_psi,N_psi); 
        %% evaluate RT theta per each psi and save united history of states
        %% prepere jobs and send all of them to cluster
        previousIterationsJobs=0;
        for i_CE_inner=1:N_CE_inner
            innerPsiRange=(i_CE_inner-1)*maxConcurrentJobs+1:min(i_CE_inner*maxConcurrentJobs,N_psi);
            for i_psi=innerPsiRange
                [localPsiDir,argContentFilename,remotePsiDir]=...
                    perparePsiDir(localIterDir,remoteIterDir,i_psi,X,s_da_0_cell,GENERAL_PSI_FILENAME,PSI_DIRNAME_PREFIX,params);
                [funcArgs,jobArgs]=...
                    perpareJobArgs(i_psi,i_CE,localPsiDir,argContentFilename,remotePsiDir,jobArgs);
                sendJob('evaluate_theta_job',funcArgs,jobArgs);
            end
            mostFinished=0;
            c=1;
            jobsWaitingToFinish=length(innerPsiRange);
            display([datestr(clock,'yyyy-mm-dd-HH-MM-SS'),' - ','Iteration ',num2str(i_CE),' (inner iteration ',num2str(i_CE_inner),')',...
                ':waiting for at least ',num2str(ceil(fractionOfFinishedJobs*jobsWaitingToFinish)),' of ',num2str(jobsWaitingToFinish),' jobs...']);
            timeOutCounter=0;
            %% wait for enough jobs to finish
            while(~mostFinished && timeOutCounter<=timeOutLimit)
                pause(pauseDuration);
                [mostFinished,numFinishedFiles]=checkIfMostFinished(fractionOfFinishedJobs,jobsWaitingToFinish,previousIterationsJobs,localIterDir,job_output_filename);
                c=c+1;
                timeOutCounter=timeOutCounter+pauseDuration;
            end
            %% after enough jobs finished - destroy remaining 
            previousIterationsJobs=numFinishedFiles;
            display([num2str(timeOutCounter),' seconds passed. ','Num of finished files: ',num2str(numFinishedFiles)]);
            killRemainingJobs(jobArgs);
        end
        deleteUnnecessaryTempFiles(tempFilesDir);
        %% evaluate v^pi per each psi
        [theta_psi,phi_hist_united,finished_idx,phi_hist_single_size] = extractVIData(localIterDir,N_psi,PSI_DIRNAME_PREFIX,job_output_filename,params);
        v_pi = mean(theta_psi(:,finished_idx)'*phi_hist_united,2);
        v_pi_local = get_local_v_pi(theta_psi,phi_hist_united,finished_idx,phi_hist_single_size);
        CE_stats{1,i_CE} = X(:,finished_idx);
        CE_stats{2,i_CE} = theta_psi(:,finished_idx);
        CE_stats{3,i_CE} = v_pi;
        CE_stats{4,i_CE} = v_pi_local;
        
        [~,I] = sort(v_pi,'descend');
        %% get best psi's
        topI = I(1:ceil(length(I)*rho));
        top_psi = X(:,topI);
    catch ME
        warning(['Problem using main_CE_API_hermes for iteration = ' num2str(i_CE)]);
        msgString = getReport(ME);
        display(msgString);
    end
    i_CE=i_CE+1;
    save([fullLocalParentDir,'/CE_run_partial.mat']);
end

CE_stats(:,i_CE:end)=[];
save([fullLocalParentDir,'/CE_run.mat']);

plot_results
