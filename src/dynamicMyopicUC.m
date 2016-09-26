function [totalObjective,finalOnoff,deviationCost,deviationTime,state,escalateLevelVec,allContingenciesHappened,totalWindSpilled,totalLoadLost] = ...
    dynamicMyopicUC(originalPg,originalOnoff,params,state)
%% initialization
deviate=0;
k=1;
paramsCopy=params;
paramsCopy.horizon=1;
deviationCost=0;
totalObjective=0;
finalOnoff=zeros(params.ng,params.horizon);
deviationTime=0;
dynamicUCParams.enforceOnoff=1;
stateAlreadyUpdated=1;
escalateLevelVec=zeros(params.horizon,1);
totalWindSpilled=0;
totalLoadLost=0;
loadLost=0;
allContingenciesHappened=zeros(params.nl,1);
%% while UC haven't deveiated from the original plan, follow original plan.
%% if it has deviated, remove originalOnoff constraint
for k=1:params.horizon
    dynamicUCParams.externalStartTime=k;
    dynamicUCParams.originalPg=originalPg(:,k);
    dynamicUCParams.originalOnoff=originalOnoff(:,k);
    %% first try to follow commitment plan
    if(~deviate)
        %% stage one - try n-1
        [~,objective,onoff,y,~,success,windSpilled] = generalSCUC('n1',paramsCopy,state,dynamicUCParams);
        [state,contingenciesHappened] = updateState(params,state); %possible take stress levels as input
        escalateLevel=0;
        %% if failed or contingencies - stage two - try without n-1
        if(~success || (sum(contingenciesHappened)>0)) %%TODO: return escalation integer here - to later know what happened
            %             display(['dynamicMyopicUC: solutionObtained: ',num2str(success),' contingenciesHappened: ',num2str(contingenciesHappened),...
            %                 ' - escalated to without n-1, still following commitment']);
            [~,objective,onoff,y,~,success,windSpilled] = generalSCUC('not-n1',paramsCopy,state,dynamicUCParams);
            escalateLevel=1;
        end
        %% if couldn't follow original commitment - remove this constraint and start escalation process for all remaining hours
        if (~success) % indication of infeasibility - this block runs at most once. don't advance time here since it was already done
            display('DEVIATION!');
            deviate=1;
            deviationTime=k;
            dynamicUCParams.enforceOnoff=0;
            %q: if this is run, use stateCopy since the updated state is irelevant
            %a: no, use state, since we tried the original plan and its stresss led
            %to contingecies (or haven't, but age did), so thats our
            %current topology. state.currTime still hasn't advanced.
            [~,objective,onoff,y,~,state,escalateLevel,contingenciesHappened,windSpilled,loadLost] = escalateUC(paramsCopy,state,dynamicUCParams,stateAlreadyUpdated);
        end
    else
        dynamicUCParams.enforceOnoff=0; %don't think its needed but let it be...
        [~,objective,onoff,y,~,state,escalateLevel,contingenciesHappened,windSpilled,loadLost] = escalateUC(paramsCopy,state,dynamicUCParams,~stateAlreadyUpdated);
    end
    allContingenciesHappened=allContingenciesHappened+contingenciesHappened;
    state.currTime = state.currTime+1;
    escalateLevelVec(k)=escalateLevel;
    totalWindSpilled=totalWindSpilled+sum(sum(windSpilled));
    totalLoadLost=totalLoadLost+loadLost;
    finalOnoff(:,k)=onoff;
    totalObjective=totalObjective+objective;
    if(escalateLevel < 3)
        deviationCost = deviationCost + pgDeviationCost(originalPg(:,k),originalOnoff(:,k),value(y),params.mpcase.gencost);
    end
    state.initialGeneratorState = getInitialGeneratorState_oneStep(onoff,state.initialGeneratorState,params);
end