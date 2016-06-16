function  [localPsiDir,argContentFilename,remotePsiDir] = ... 
    perparePsiDir(localIterDir,remoteIterDir,i_psi,X,s_da_0_cell,GENERAL_PSI_FILENAME,PSI_DIRNAME_PREFIX,params)
%% create psi dir. 'local' referes to local mount, 'remote' is the local path on the node itself
relativePsiPath=['/',PSI_DIRNAME_PREFIX,num2str(i_psi)];
localPsiDir  = [localIterDir,relativePsiPath];
remotePsiDir = [remoteIterDir,relativePsiPath];
mkdir(localPsiDir);

%% write psi content file
psi=X(:,i_psi);
argContentFilename=[GENERAL_PSI_FILENAME,'_p_',num2str(i_psi)];
% columnPsi=psi(:);
save([localPsiDir,'/',argContentFilename],'psi','s_da_0_cell','params');
% fid = fopen([localPsiDir,'/',argContentFilename], 'w');
% fprintf(fid,'%d ',columnPsi);
% fclose(fid);

