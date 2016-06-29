function psi_0 = get_psi_initial_iCE(s_da_0_cell,params,i_CE) %<-last parameter is for DEBUG!
%A good initial psi will equalize all values for the different actions in
%our action-set. This can be solved by finding an orthogonal vector to the
%matrix of feature differences (of size dx(length(action-set)-1) )
phi_da = get_da_features(s_da_0_cell{1},params);
diff_mat = phi_da(:,1:end-1) - phi_da(:,2:end);
psi_0 = null(diff_mat'); 
psi_0 = psi_0(:,1);

%% DEBUG!
psi_0 = phi_da(:,i_CE);
