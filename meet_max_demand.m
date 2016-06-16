function da_action = meet_max_demand(permuation,s_da_td,params)
run('get_global_constants.m')
num_gen = length(permuation);

effectiveDemand = sum(s_da_td.demand-s_da_td.wind,1);
maxD = max(effectiveDemand);
minD = min(effectiveDemand);
avgD = mean(effectiveDemand);

pmax_permuted = params.mpcase.gen(permuation,PMAX);
current_max_gen = 0;
i_gen = 0;
demand_met = false;
while(maxD>current_max_gen && i_gen<num_gen)
    i_gen = i_gen + 1;
    current_max_gen = current_max_gen + pmax_permuted(i_gen);
end
da_action = zeros(num_gen,1);
da_action(permuation(1:i_gen)) = 1;