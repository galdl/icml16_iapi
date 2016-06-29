function rollouts_vec = get_rollouts_vec(current_rollout_mat,rollouts_vec_length)
rollouts_vec = nan(rollouts_vec_length,1);
if(~isempty(current_rollout_mat))
    sz = size(current_rollout_mat);
    c=1;
%         for i_s0 = 1:sz(3)

    for i_s0 = 1:5
        for i_episode = 1:sz(2)
            rollouts_vec(c) = sum(current_rollout_mat(:,i_episode,i_s0));
            c = c+1;
        end
    end
end