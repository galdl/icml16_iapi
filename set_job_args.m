function jobArgs = set_job_args(prefix_num)
jobArgs.ncpus=1;
jobArgs.memory=2; %in GB
jobArgs.queue='new_q'; %all_q
jobArgs.jobNamePrefix=['psi',num2str(prefix_num)];
jobArgs.userName='gald';
