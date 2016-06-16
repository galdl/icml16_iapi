function s_da_tdp1 = transition_da(s_da_td,params)
    s_da_tdp1 = s_da_td;
%% draw wind
i_w_da = randsample(1:length(params.dev_w_vec_da),1);
dev_w_da = params.dev_w_vec_da(i_w_da);
w = s_da_td.wind*(1+dev_w_da);
w = max(w,0);
s_da_tdp1.wind = w;
%% quick demand draw 
s_da_tdp1.demand = s_da_tdp1.demand*(1-dev_w_da);
