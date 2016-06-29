function [mostFinished,numFinishedFiles]= ... 
    checkIfMostFinished(fractionOfFinishedJobs,jobsWaitingToFinish,previousIterationsJobs,localIterDir,job_output_filename)
%% get num of finished months jobs
cmd=['find ',localIterDir,' -type f |grep ',job_output_filename,'|wc -l'];
[~,finishedFiles]=unix(cmd);
numFinishedFiles=str2double(finishedFiles);

%% check whether most jobs are finished
mostFinished = ( numFinishedFiles-previousIterationsJobs >= fractionOfFinishedJobs*jobsWaitingToFinish);