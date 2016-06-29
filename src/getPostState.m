function [pState] = getPostState(state, action, params) 
%TODO: consider wind curtaliment affect
pState = state;
%% update generation according to action
pState.g = pState.g+action.dg;
pState.wind_curtailment = action.wind_curtailment;
%% update budget according to action
pState.b = max(pState.b - calcRedispatchCost(action.dg, pState.d, pState.w, params.ci), 0);
end

function c = calcRedispatchCost(dg, d, w, ci)
genAmp = max(sum((d-w)), 0);
c = genAmp*sum(ci.*abs(dg));
end
