function coloring_vec = get_coloring_vec(CE_stats,i_column,s_da_0_cell,params,rho,show_actions)
psi_vec = CE_stats{1,i_column};
coloring_vec = ones(size(psi_vec,2),1);
if(show_actions)
    %% return actions chosen for coloring
    actions = cell2mat(arrayfun(@(x)(get_da_action(psi_vec(:,x),s_da_0_cell{1},params)),1:size(psi_vec,2),'UniformOutput',false));
    for x=1:size(params.action_set,2)
        idx=find(sum(abs(actions-repmat(params.action_set(:,x),[1,size(actions,2)])))==0);
        coloring_vec(idx) = x;
    end
else
    %% return actions chosen for coloring
    vals = CE_stats{3,i_column};
    [sorted_vals,sorted_idx] = sort(vals,'descend');
    top_idx = sorted_idx(1:ceil(rho*length(sorted_idx)));
    coloring_vec(top_idx) = 0;
end