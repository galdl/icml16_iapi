function da_action = fits_cheapest(s_da_td,params)
run('get_global_constants.m')

effectiveDemand = sum(s_da_td.demand-s_da_td.wind,1);
suitable_action_found = false;
num_actions = size(params.action_set,2);
maxD = max(effectiveDemand);
minD = min(effectiveDemand);
avgD = mean(effectiveDemand);
max_g_mat = repmat(params.mpcase.gen(:,PMAX),[1,num_actions]);
max_g = sum(params.action_set.*max_g_mat,1);

min_g_mat = repmat(params.mpcase.gen(:,PMIN),[1,num_actions]);
min_g = sum(params.action_set.*min_g_mat,1);

cost_mat = repmat(params.ci,[1,num_actions]);
cost = sum(params.action_set.*cost_mat,1);
cost = cost./max_g;

action_index = find(minD < min_g);
if(isempty(action_index))
    action_index = randsample(num_actions,1);
end
[~,cheapest] = min(cost(action_index));
da_action = params.action_set(:,action_index(cheapest(1)));
