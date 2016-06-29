num_iter = i_CE-1;
rollouts = [];

da_policy = @random_policy;
val = evaluate_policy(da_policy,s_da_0_cell,params);
rollouts = [rollouts,val*ones(num_iter,1)];

da_policy = @fits_minimum;
val = evaluate_policy(da_policy,s_da_0_cell,params);
rollouts = [rollouts,val*ones(num_iter,1)];

da_policy = @fits_maximum;
val = evaluate_policy(da_policy,s_da_0_cell,params);
rollouts = [rollouts,val*ones(num_iter,1)];

da_policy = @fits_cheapest;
val = evaluate_policy(da_policy,s_da_0_cell,params);
rollouts = [rollouts,val*ones(num_iter,1)];

psi_out = zeros(num_iter,1);
da_policy = @psi_policy_wrapper;
for i_iter=1:num_iter
    params.psi = get_best_psi(CE_stats,i_iter);
    psi_out(i_iter) = evaluate_policy(da_policy,s_da_0_cell,params);
end
rollouts = [rollouts,psi_out];

psi_out = zeros(num_iter,1);
da_policy = @psi_policy_wrapper;
for i_iter=1:num_iter
    params.psi = get_med_psi(CE_stats,i_iter);
    psi_out(i_iter) = evaluate_policy(da_policy,s_da_0_cell,params);
end
rollouts = [rollouts,psi_out];

save(['comparing_runs_',datestr(clock,'yyyy-mm-dd-HH-MM-SS')]);
figure(7);
plot(rollouts);
legend({'random','fits minimum demand','fits maximum demand','fits cheapest','learned policy - best','learned policy - median'});
fontSize=17;
set(gca,'fontsize',20);
title('Compare policies','FontSize', 17);
xlabel('CE iteration Count', 'FontSize', fontSize);
ylabel('Rollout value', 'FontSize', fontSize);