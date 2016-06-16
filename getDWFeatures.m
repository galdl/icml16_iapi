function ph = getDWFeatures(state,params,da_market)
%define_constants;
run('get_global_constants.m')
epsilon = 1e-6;
max_gen = sum(params.mpcase.gen(:,PMAX));
net_d = max(state.d-state.w,0)/max_gen; %make sure we dont get negative here. times 5 so its always less than 1
sum_d = max(min(sum(net_d),1),epsilon);
norm_net_d = net_d./sum(net_d);
norm_g = state.g./max(sum(state.g),epsilon);
ent_d = entropy(norm_net_d)/length(norm_net_d);
ent_g = entropy(norm_g)/length(norm_g);
ph = calculate_feature_vector(sum_d,ent_d,ent_g);

% ph = [ph;(state.e>0)]; didn't work well...
