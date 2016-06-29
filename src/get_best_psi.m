function psi = get_best_psi(CE_stats,i_iter)
vals = CE_stats{3,i_iter};
[~,best_idx] = max(vals);
psi_vec = CE_stats{1,i_iter};
psi = psi_vec(:,best_idx);