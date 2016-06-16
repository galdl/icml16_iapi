function i_d = get_i_d(state,params)

run('get_global_constants.m');
epsilon=1e-6;
isStochastic=0;
% w_t=generateWind(state.t, params, state, isStochastic);
d_t=generateDemand(state.t, params, state, isStochastic);
% loc_w=find(w_t);
% loc_w=loc_w(1);

loc_d=find(d_t);
loc_d=loc_d(1);

% dev_w = mean((state.w(loc_w) - w_t(loc_w))./w_t(loc_w));
dev_d = mean((state.d(loc_d) - d_t(loc_d))./d_t(loc_d));
i_d = find(params.dev_d_vec >= dev_d-epsilon & params.dev_d_vec <= dev_d+epsilon);