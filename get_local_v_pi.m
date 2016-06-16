function v_pi_local = get_local_v_pi(theta_psi,phi_hist_united,finished_idx,phi_hist_single_size)
v_pi_local = zeros(length(finished_idx),1);
for i=1:length(finished_idx)
    theta = theta_psi(:,finished_idx(i));
    relevant_phi_history = phi_hist_united(:,(i-1)*phi_hist_single_size+1:i*phi_hist_single_size);
    v_pi_local(i)  = mean(theta'*relevant_phi_history,2);
end