function [ updatedMpcase ] = stateToMpcase( state, Wc, params ,voltage_setpoints )
%% initialize
run('get_global_constants.m');
mpcase = params.mpcase;
updatedMpcase = mpcase;

%% remove objective
updatedMpcase.gencost(:,2:end)=zeros(size(mpcase.gencost(:,2:end)));

%% set net demand
if(state.wind_curtailment)
    netDemand = state.d;
else
    netDemand = state.d - state.w;
end
updatedMpcase.bus(:,PD) = max(netDemand,0);

%% set generation commitment and levels
updatedMpcase.gen(:,GEN_STATUS) = state.commited_generators;
updatedMpcase.gen(:,PG)=state.g;
%% set voltage set points for case of runopf day-ahead plan - currently just for case96
if(~isempty(voltage_setpoints))
    updatedMpcase.gen(:,VG)=voltage_setpoints(:,state.t);
end
%% set topology
currentOutages = (state.e>0);
newOutages = Wc.drawnContingencies;
allOutage = (currentOutages | newOutages);
updatedMpcase.branch(allOutage,BR_STATUS)=0;

