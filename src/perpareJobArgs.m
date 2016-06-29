function    [funcArgs,jobArgs]=perpareJobArgs(i_psi,i_CE,localPsiDir,argContentFilename,remotePsiDir,jobArgs)
funcArgs.remotePsiDir=remotePsiDir;
funcArgs.argContentFilename=argContentFilename;
funcArgs.localPsiDir=localPsiDir;
jobArgs.jobName=buildJobName(i_CE,i_psi,jobArgs.jobNamePrefix);
