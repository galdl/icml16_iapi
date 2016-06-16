function [state_next] = sampleTransition(state, action, params)
if(nargin==0)
    % unittest mode
    params = getProblemParamsForCase('case5')
    w = zeros(params.ng, 1); w(params.windBuses) = 20;
    e = ones(params.nl, 1);
    g = rand(params.ng, 1); g = g/sum(g);
    d = rand(params.nb, 1)*100;
    state = struct('g', ones(params.ng, 1)/params.ng, 'b', 100, 'w', w, 't', 0, 'e', e, 'd', d);
    gnext = rand(params.ng, 1); gnext = gnext/sum(gnext);
    dg = gnext - g;
    action = struct('dg',dg); 
end
isStochastic = true;
state_next = state;
state_next.g = state.g+action.dg;
state_next.b = max(state.b - calcRedispatchCost(action.dg, state.d, state.w, params.ci), 0);

state_next.t = timeOfDay(state.t+1);

[w, Pr] =  generateWind(state_next.t, params, state, isStochastic);
state_next.w = w;

[d, Pr] =  generateDemand(state_next.t, params, state, isStochastic);
state_next.d = d;

state_next.e = max(state.e-1,0);   % dec counter, 0 is functional
r = rand(size(state_next.e));
isFunctional = ~state_next.e;
drawnContingencies = r < isFunctional.*params.Pcont;
% if contingency then start cotingency counter
state_next.e(drawnContingencies) = params.contingencyCounter;
end


function c = calcRedispatchCost(dg, d, w, ci)
genAmp = max(sum((d-w)), 0);
c = genAmp*sum(ci.*abs(dg));
end

function t = timeOfDay(T)
    t = mod(T,24);
end