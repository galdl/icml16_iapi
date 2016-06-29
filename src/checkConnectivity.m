function connected = checkConnectivity(mpcase,params)
%define_constants;
run('get_global_constants.m')

branch = mpcase.branch;
s1=sparse(branch(:,F_BUS),branch(:,T_BUS),branch(:,BR_STATUS),params.nb,params.nb);
s2=full((s1+s1')>0);
connected=checkc(s2);