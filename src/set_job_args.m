function jobArgs = set_job_args(prefix_num,config)
% Sets arguemnts for jobs that on the server cluster. Used when running
% locally as well, since the machanism is the same for both.
jobArgs.ncpus=1;
jobArgs.memory=2; %in GB
jobArgs.queue='new_q'; %all_q
jobArgs.jobNamePrefix=[config.JOB_NAME_PREFIX,num2str(prefix_num)];
jobArgs.userName='gald';