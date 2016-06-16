function da_action = fits_maximum_ratio(s_da_td,params)
run('get_global_constants.m')
felxibility = params.mpcase.gen(:,PMAX)./params.mpcase.gen(:,PMIN);
[~,permuation] = sort(felxibility,'descend');
da_action = meet_max_demand(permuation,s_da_td,params);