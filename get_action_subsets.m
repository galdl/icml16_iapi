function action_set = get_action_subsets(idx,n,params)
action_set = [];
locs = round(linspace(1,params.ng,n));
combos = combntns(locs,2);
for i_c=1:length(combos)
    curr_action = zeros(params.ng,1);
    curr_action(idx(combos(i_c,1):combos(i_c,2)))=1;
    action_set = [action_set,curr_action];
end
    