function jobName=buildJobName(i_CE,i_psi,jobNamePrefix)
jobName=[jobNamePrefix , '-' , num2str(i_CE) , '-' , num2str(i_psi) ];