function jobArgs = set_job_args_compare_solutions(prefix_num)
jobArgs.ncpus=1;
jobArgs.memory=2; %in GB
jobArgs.queue='new_q'; %all_q,new_q
jobArgs.jobNamePrefix=['compare',num2str(prefix_num)];
jobArgs.userName='gald';
