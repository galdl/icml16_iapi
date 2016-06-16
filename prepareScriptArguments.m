function [tempPythonLocalFilePath,logDir,matlabInnerCode,MATLAB_PATH,tempPyhonRemotePath]=prepareScriptArguments(funcName,funcArgs,jobArgs)
%% function arguments - struct
remotePsiDir=funcArgs.remotePsiDir;
argContentFilename=funcArgs.argContentFilename;
localPsiDir=funcArgs.localPsiDir;
jobName=jobArgs.jobName;

funcArgsStr=[ '''' , remotePsiDir , '''' , ',' , '''' , argContentFilename , '''' ];

%% matlab call string
MATLAB_PATH = '/usr/local/bin/matlab';
WORK_PATH = '/u/gald/ICML16/proxy_mdp_latest';
logDir = [remotePsiDir , '/../..'];
tempJobsFileLocalPath= [localPsiDir , '/../../tempJobFiles/'];
tempPyhonRemotePath= [remotePsiDir , '/../../tempJobFiles/'];

matlabInnerCode=[ ' "cd(''' , WORK_PATH , ''');,warning off,' , funcName , '(' , funcArgsStr , ');"' ];
tempPythonFilename    = [ jobName , '.py'];
tempPythonLocalFilePath = [ tempJobsFileLocalPath , tempPythonFilename ];
tempPyhonRemotePath = [ tempPyhonRemotePath , tempPythonFilename ];
