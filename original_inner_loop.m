      c=c+1;
            ph = getCenteredFeatures(s_t_post,params,da_market); %ph(s)

        %theta_history(:,t) = theta;
%         display(['Time step: ',num2str(t)]);
        %     if(mod(t,params.da_horizon)==1)
        %         da_market = getDailyGenerationPrediction(params);

        
        %-- start interval --
        s_t=transition(s_t_post, Wc_tm1, da_market,params); %draw demand and wind, fix lines,time, da market on new day
        a_t=getAction(s_t,params);
%             a_t.dg=0;
        s_t_post=getPostState(s_t,a_t,params); % update budget
        Wc_t = drawContingency(s_t,params);
        %-- run --
        r_t = calcReliability(s_t_post, Wc_t,params);
        r_vec(c)=r_t;
%         r_t=1;
        %-- end interval
%         R=R+r_t;
phNext = getCenteredFeatures(s_t_post,params,da_market);
            theta_history_full(:,c) = theta;

    %% update value function
    currV=ph'*theta;
    nextV=phNext'*theta;

        delta=r_t+params.gamma*nextV-currV;

    step = (0.05*c^(-0.1))*delta*ph;
    step_history(:,t) = step;
    ph_history(:,t) = ph;
    norm(step);
    theta=theta+step;