function [action,needed_g] =curtail_wind(state,action,needed_g)

%first, if there's more wind than demand - we have to throw it away.
%dirty heuristic: throw away all wind
if(sum(state.d - state.w) < 0)
    action.wind_curtailment = true;
    state.w =0 ; % for the rest of the equations to be correct from now on
    needed_g = sum(state.d) - sum(state.g);
end