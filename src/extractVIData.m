function [theta_psi,phi_hist_united,finished_idx,phi_hist_single_size] =  extractVIData(iterationDir,N_psi,PSI_DIRNAME_PREFIX,job_output_filename,params)
finished_idx = [];
da_market_null = nan(params.nb,params.da_horizon);
s = initializeState(da_market_null,params);
theta_length = length(getDWFeatures(s,params,da_market_null));
theta_psi = nan(theta_length,N_psi);
% 'theta','phi_hist'
phi_hist_united = [];
for i_psi=1:N_psi
    try
        lsPath=[iterationDir,'/',PSI_DIRNAME_PREFIX,num2str(i_psi)];
        outputFolder=what(lsPath);
        numOfExistingMatFiles=length(outputFolder.mat);
        if(numOfExistingMatFiles>0) %if job finished and there's an output
            fileList=what([iterationDir,'/',PSI_DIRNAME_PREFIX,num2str(i_psi)]);
            outputFileList=fileList.mat;
            for i_matFile=1:length(outputFileList)
                outputFileName = outputFileList{i_matFile};
                if(strcmp(outputFileName,job_output_filename))
                    loaded_file = load([fileList.path,'/',outputFileName]);
                    theta_psi(:,i_psi) = loaded_file.theta;
                    phi_hist_united = [phi_hist_united,loaded_file.phi_hist];
                    finished_idx = [finished_idx,i_psi];
                    phi_hist_single_size = size(loaded_file.phi_hist,2);
                end
            end
        end
    catch ME
        warning(['Problem using extractVIData for iteration = ' num2str(i_psi)]);
        msgString = getReport(ME);
        display(msgString);
    end
end
