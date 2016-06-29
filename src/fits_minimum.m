function da_action = fits_minimum(s_da_td,params)
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

action_index = find(minD > min_g);
if(isempty(action_index))
    action_index = 1;
end
action_index = randsample(action_index,1);
da_action = params.action_set(:,action_index);
