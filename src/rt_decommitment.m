function [needed_g,altered_gen,state,action] = rt_decommitment(state,tot_min_gen,altered_gen,min_gen,action,params)

% while less (effective) demand than minimal generation, and not all
    % generators turned off - switch off generators
    while(params.allow_gen_switchoff && tot_min_gen > sum(state.d - state.w) && length(altered_gen)<params.ng) %cosider changing GEN_STATUS instead
        [val,smallest_gen] = min(min_gen);
        chosen_gen = smallest_gen(1);
        altered_gen = [altered_gen;chosen_gen];
        action.dg(chosen_gen) = -state.g(chosen_gen);
        tot_min_gen = tot_min_gen - val;
        min_gen(smallest_gen) = inf;
    end
    needed_g = sum(state.d - state.w) - sum(state.g + action.dg);