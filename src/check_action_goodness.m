actions = triu(ones(params.ng));
num_actions = size(actions,2);
pfResults = zeros(2,num_actions);
s_da_td = s_da_0_cell{1};
for i_action = 1:num_actions
      current_pf_res= getDailyGenerationPrediction_testing(actions(:,i_action),s_da_td,params);
      pfResults(:,i_action) = mean(current_pf_res,1)';
end
