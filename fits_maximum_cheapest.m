function da_action = fits_maximum_cheapest(s_da_td,params)
[~,permuation] = sort(params.ci);
da_action = meet_max_demand(permuation,s_da_td,params);