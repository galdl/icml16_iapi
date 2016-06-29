function psi = get_med_psi(CE_stats,i_iter)
vals = CE_stats{3,i_iter};
[~,idx] = sort(vals);
med_idx = idx(round(length(vals)/2));
psi_vec = CE_stats{1,i_iter};
psi = psi_vec(:,med_idx(1));