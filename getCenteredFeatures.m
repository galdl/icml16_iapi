function ph = getCenteredFeatures(state,params,da_market)
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
% if(isnan(dev_w) ||  sum(state.w)==0)
%     dev_w=0;
% end
if(isnan(dev_d))
    dev_d=0;
end 
max_wind_gen = max(generateWind(1:params.da_horizon, params, state, isStochastic),[],2);
centered_d = (state.d-generateDemand(state.t, params, state, isStochastic))./(params.mpcase.bus(:,PD)+epsilon);
% isStochastic=0;
centered_w = (state.w-generateWind(state.t, params, state, isStochastic))./(max_wind_gen+epsilon);
max_gen = max(da_market,[],2);
centered_g = (state.g - da_market(:,state.t))./(max_gen+epsilon);
norm_b = state.b./(params.initialBudget+epsilon);

% ph_hat = [1;dev_w;dev_w^2;dev_w^3;dev_d;dev_d^2;dev_d^3];%centered_d;centered_d.^2;centered_w;centered_w.^2;centered_g;centered_g.^2;(state.e > 0);norm_b];
ph_hat = [1;dev_d;dev_d^2;dev_d^3];%centered_d;centered_d.^2;centered_w;centered_w.^2;centered_g;centered_g.^2;(state.e > 0);norm_b];

ph= ph_hat*ph_hat';
% ph=ph(:);
% ph=[centered_d;centered_d.^2;centered_g;centered_g.^2;(state.e > 0);norm_b];
ph=[1;centered_d;centered_w;centered_g];