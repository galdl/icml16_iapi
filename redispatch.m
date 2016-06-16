function [action] = redispatch(state,altered_gen,needed_g,action,params)
run('get_global_constants.m')

gen_cost = params.mpcase.gencost(:,COST);
gen_cost(altered_gen)=inf;
c=0;

while(length(altered_gen)<params.ng && needed_g ~= 0)
    c=c+1;
    [~,cheapest_gen] = min(gen_cost);
    chosen_gen = cheapest_gen(1);
    altered_gen = [altered_gen;chosen_gen];
    updated_g = state.g(chosen_gen) + needed_g; %new generation, not difference
    margin = params.mpcase.gen(chosen_gen,PMAX)*params.margin;
    max_g = params.mpcase.gen(chosen_gen,PMAX) - margin;
    min_g = params.mpcase.gen(chosen_gen,PMIN) + margin;
    if(updated_g > max_g)
        delta_g = max_g - state.g(chosen_gen);
        action.dg(chosen_gen) = delta_g;
        needed_g = needed_g - delta_g; %same expression as bellow, in a more explainable way
    elseif(updated_g < min_g)
        delta_g = min_g - state.g(chosen_gen);
        action.dg(chosen_gen) = delta_g;
        needed_g = needed_g - delta_g;
    else
        action.dg(chosen_gen) = needed_g;
        needed_g = 0;
    end
    gen_cost(altered_gen)=inf;
end