function [ da_action ] = psi_policy_wrapper( s_da_td,params )
%Wrapper for get_da_action, when in evaluation mode
da_action = get_da_action(params.psi,s_da_td,params);


end

