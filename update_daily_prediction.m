function s_t = update_daily_prediction(s_da_td,s_t,params)
i_d=randsample(1:length(params.dev_d_vec),1);
s_t.eff_d_deviation = s_da_td.demand(:,1).*params.dev_d_vec(i_d);

s_t.d = s_da_td.demand(:,1) + s_t.eff_d_deviation;
s_t.w = s_da_td.wind(:,1);