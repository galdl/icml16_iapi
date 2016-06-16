function da_action = fits_maximum_rand(s_da_td,params)
permuation = randperm(params.ng);
da_action = meet_max_demand(permuation,s_da_td,params);

