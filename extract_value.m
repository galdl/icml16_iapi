function value = extract_value(rollout_mat,params)
value=0;
sz = size(rollout_mat);
for i_s0=1:sz(3)
    for i_episode=1:sz(2)
        curr_val=0;
        for t=1:sz(1)
            remaining = rollout_mat(t:sz(1),i_episode,i_s0);
            discount_vector = (params.gamma*ones(1,length(remaining))).^(0:(length(remaining)-1));
            curr_val = curr_val + remaining'*discount_vector';
        end
        value = value+curr_val;
    end
end
value = value/(sz(3)*sz(2));