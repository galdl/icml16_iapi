function     killRemainingJobs(jobArgs)
jobNamePrefix = jobArgs.jobNamePrefix;
userName      = jobArgs.userName;
killCmd =['qstat -u ',userName,' | grep ',jobNamePrefix ,' | grep "',userName,'" | cut -d"." -f1 | xargs qdel -W force'];
sendSSHCommand(killCmd);
%killCmd =['qstat -u ',userName,' | grep ',jobNamePrefix,' | grep STDIN',' | grep "',userName,'" | cut -d"." -f1 | xargs qdel -W force'];