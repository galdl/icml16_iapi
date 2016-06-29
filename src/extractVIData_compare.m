function rollouts = extractVIData_compare(iterationDir,N_func,PSI_DIRNAME_PREFIX,job_output_filename,params)
rollouts = cell(1,N_func);
for i_func=1:N_func
    try 
        lsPath=[iterationDir,'/iteration_',num2str(i_func),'/',PSI_DIRNAME_PREFIX,num2str(i_func)];
        outputFolder=what(lsPath);
        numOfExistingMatFiles=length(outputFolder.mat);
        if(numOfExistingMatFiles>0) %if job finished and there's an output
            fileList=what(lsPath);
            outputFileList=fileList.mat;
            for i_matFile=1:length(outputFileList)
                outputFileName = outputFileList{i_matFile};
                if(strcmp(outputFileName,job_output_filename))
                    loaded_file = load([fileList.path,'/',outputFileName]);
                   rollouts{i_func} = loaded_file.rollout_value;
                end
            end
        end
    catch ME
        warning(['Problem using extractVIData_case24 for iteration = ' num2str(i_func)]);
        msgString = getReport(ME);
        display(msgString);
    end
end
