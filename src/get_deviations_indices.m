function [i_d,i_w] = get_deviations_indices(state,params)

%define_constants;
run('get_global_constants.m')

epsilon=1e-6;
isStochastic=0;
w_t=generateWind(state.t, params, isStochastic);
d_t=generateDemand(state.t, params, isStochastic);
loc_w=find(w_t);
loc_w=loc_w(1);

loc_d=find(d_t);
loc_d=loc_d(1);

dev_w = mean((state.w(loc_w) - w_t(loc_w))./w_t(loc_w));
dev_d = mean((state.d(loc_d) - d_t(loc_d))./d_t(loc_d));
i_d = find(params.dev_d_vec >= dev_d-epsilon & params.dev_d_vec <= dev_d+epsilon);
i_w = find(params.dev_w_vec >= dev_w-epsilon & params.dev_w_vec <= dev_w+epsilon);