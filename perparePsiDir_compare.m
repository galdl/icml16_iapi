function  [localPsiDir,argContentFilename,remotePsiDir] = ... 
    perparePsiDir_compare(i_func,localIterDir,remoteIterDir,GENERAL_PSI_FILENAME,PSI_DIRNAME_PREFIX,func_handle,s_da_0_cell,params)
%% create psi dir. 'local' referes to local mount, 'remote' is the local path on the node itself
relativePsiPath=['/',PSI_DIRNAME_PREFIX,num2str(i_func)];
localPsiDir  = [localIterDir,relativePsiPath];
remotePsiDir = [remoteIterDir,relativePsiPath];
mkdir(localPsiDir);

%% write psi content file
argContentFilename=[GENERAL_PSI_FILENAME,'_p_',num2str(i_func)];
save([localPsiDir,'/',argContentFilename],'func_handle','s_da_0_cell','params');

