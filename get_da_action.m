function   da_action = get_da_action(psi,s_da_td,params)
phi_da = get_da_features(s_da_td,params); %multiple columns for multiple DA actions
action_values = psi'*phi_da;
[~,best_action] = max(action_values);
da_action = params.action_set(:,best_action);