function ph = getFeatures(state,params)
run('get_global_constants.m');
epsilon=1e-6;
norm_d = state.d./(params.mpcase.bus(:,PD)+epsilon);
isStochastic=0;
norm_w = state.w./(generateWind(state.t, params, state, isStochastic)+epsilon);
norm_g = state.g./(params.mpcase.gen(:,PMAX)+epsilon);
norm_b = state.b./(params.initialBudget+epsilon);

ph = [1;norm_d;norm_w;norm_g;(state.e > 0);norm_b;state.t];