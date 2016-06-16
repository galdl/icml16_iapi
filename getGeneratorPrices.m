function ci = getGeneratorPrices(mpcase)
run('get_global_constants.m');
M=1e5;
pmax = mpcase.gen(:,PMAX);
ci = min(max(pmax)./pmax,M);

