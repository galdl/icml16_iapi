function [state_next,i_d] = transition(pState, Wc, da_market ,s_da_td, params)

isStochastic = true;
state_next = pState;
state_next.wind_curtailment = false;
%% update time of day
state_next.t = timeOfDay(pState.t+1);

%% draw wind and demand
eps_t = 0.005*pState.d.*randn;
pState.eff_d_deviation = pState.eff_d_deviation + eps_t;
% i_w = randsample(1:length(params.dev_w_vec),1);
% dev_w = params.dev_w_vec(i_w);
% [w, Pr] =  generateWind(state_next.t, params, isStochastic,dev_w);
% w = s_da_td.wind(:,state_next.t)*(1+dev_w);
w = s_da_td.wind(:,state_next.t);
w = max(w,0);
state_next.w = w;

% i_d=randsample(1:length(params.dev_d_vec),1);
% dev_d = params.dev_d_vec(i_d);
% [d, Pr] =  generateDemand(state_next.t, params, isStochastic,dev_d);
% d = s_da_td.demand(:,state_next.t)*(1+dev_d);
d = s_da_td.demand(:,state_next.t) + pState.eff_d_deviation;
d = max(d,0);
state_next.d = d;

%% update generation to the day-ahead market prediction
state_next.g = da_market(:,state_next.t); %add explanation to change to a function
%when da_market is not stationary 

%% fix lines
state_next.e = max(pState.e-1,0);   % dec counter, 0 is functional

%% shut down lines that had contingencies in the last time-step
% if contingency then start cotingency counter
state_next.e(Wc.drawnContingencies) = params.contingencyCounter;

end

function t = timeOfDay(T)
t = mod(T,24);
if(t==0) 
    t = 24;
end
end