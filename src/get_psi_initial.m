function psi_0 = get_psi_initial(s_da_0_cell,params,N_psi)
%% null-space psi's
%A good initial psi will equalize all values for the different actions in
%our action-set. This can be solved by finding an orthogonal vector to the
%matrix of feature differences (of size dx(length(action-set)-1) )
psi_0 = [];
for i_s0 = 1:params.N_s_da_0
    phi_da = get_da_features(s_da_0_cell{i_s0},params);
    diff_mat = phi_da(:,1:end-1) - phi_da(:,2:end);
    psi_0 = [psi_0,null(diff_mat')];
end
% psi_0 = psi_0(:,1);
% psi_0 = randn(size(psi_0));
%% DEBUG!
% psi_0 = phi_da(:,i_CE);
%% random psi's
psi_length = length(phi_da(:,1));
rand_psi = randn([psi_length,round(N_psi/2)]);
%% make sure its half null, half random
num_of_psi_0_dups = ceil(N_psi/(2*size(psi_0,2)));
psi_0 = repmat(psi_0,[1,num_of_psi_0_dups]);
%% unite the two
psi_0 = [psi_0,rand_psi];
