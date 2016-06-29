%-- initialization --
s_tm1_post =  initializeState();
Wc_tm1=null;
for t = 1:params.horizon
    %-- start interval --
    s_t=transition(s_tm1_post, Wc_tm1, get_da_market); %draw demand and wind, fix lines,time, da market on new day
    a_t=getAction(s_t);
    s_t_post=getPostState(s_t,a_t); % update budget
    Wc_t = drawContingency(s_t);
    %-- run --
    r_t=calcReliability(s_t_post, Wc_t);
    %-- end interval
end
