function [reliability,success] = calcReliability_externalOpf(pState,Wc,params)
%% first obtain mpcase struct to be able to calculate reliability
mpcase=stateToMpcase(pState,Wc,params);

%% initialize
%define_constants;
run('get_global_constants.m')
mpopt = mpoption('out.all', 0,'verbose', 0,'pf.alg','NR','pf.alg','NR'); %NR(def), FDXB, FDBX, GS
% mpopt = mpoption('out.all', 0,'verbose', 0,'pf.alg','NR','pf.alg','NR','pf.tol','1e-2','pf.nr.max_it','1'); %NR(def), FDXB, FDBX, GS
cont_list_length = params.nl+1;
pf_success = zeros(cont_list_length,1);
pf_violation = zeros(cont_list_length,1);
pg_prec_violation = zeros(cont_list_length,1);
%% N-1 criterion - N(=nl) possible single line outage
for i_branch = 1:cont_list_length
%     display(['i_branch value: ',num2str(i_branch)])
    newMpcase=mpcase;
    if(~checkConnectivity(newMpcase,params))
        display(['Not Connected for ',num2str(i_branch)]);
    end
    if(i_branch>1)
        %for i_branc==1, no contingencies.
        %for i_branc==2, 1st contingency, etc..
        newMpcase.branch(i_branch-1,BR_STATUS)=0;
    end
    if(sum(newMpcase.branch(:,BR_STATUS))==0)
        pfRes.success=0;
    else
        
        pfRes=runpf(newMpcase,mpopt);
    end
    pf_success(i_branch)=pfRes.success;
    if(pfRes.success)
        idx=find(pState.commited_generators);
        pg_prec_violation(i_branch)=sum(abs(pfRes.gen(idx,PG)-newMpcase.gen(idx,PG)))/sum(newMpcase.gen(idx,PG));
        pf_violation(i_branch)=pfConstraintViolation(pfRes,params);
    end
end

reliability=1-mean(pf_violation | (1-pf_success));
% reliability = min(exp(1/reliability)*(reliability~=1),10);
% OPF case: i think there has to be no violation in case there's success
noViolation=1-mean(pf_violation);
success=mean(pf_success);
end

%consider using matpower bult-in function:
%function [Fv, Pv, Qv, Vv] = checklimits(mpc, ac, quiet)
function violation = pfConstraintViolation(pfRes,params)
percentageTolerance=1; %how much of a percentage violation do we tolerate
[Fv, Pv] = checklimits(pfRes, 1, 1);
violation=1-(isempty(Fv.p) || max(Fv.p) <= percentageTolerance)*...
    (isempty(Pv.p) || max(Pv.p) <= percentageTolerance)*...
    (isempty(Pv.P) || max(Pv.P) <= percentageTolerance);
%Fv is flow violations, Fv.p is max flow percentage violations, Pv is
%generator violations (real power), Pv.p and Pv.P are upper and lower
%limit violations.
end