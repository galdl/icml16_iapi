function ci = getGeneratorPrices(mpcase)
%generator costs are constants and simply inversely proportional to their
%maximal output. They currently just determine the real-time dispatch 
%policy. Other than that, they play no role.
run('get_global_constants.m');
M=1e5;
pmax = mpcase.gen(:,PMAX);
ci = min(max(pmax)./pmax,M);

