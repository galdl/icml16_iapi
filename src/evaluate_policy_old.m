function rollout_value = evaluate_policy(da_policy,s_da_0_cell,params)
%% initialize variables
N_stpes = params.da_horizon*params.num_of_days;
warning off
da_market_null = nan(params.ng,params.da_horizon);
rollout_value = 0;

%% obtain samples for estimating RT theta given DA policy theta_pi
for i_s0 = 1:length(s_da_0_cell)
    s_da_td = s_da_0_cell{i_s0};
    %% value iteration initialization
    td=0;
    %% run value iteration
    for i_episode=1:params.N_episode
        display(['Episode ',num2str(i_episode)]);tic;
        s_t = initializeState(da_market_null,params);
        for t = 1:N_stpes
            if(mod(s_t.t,24)==1) %beginning of the day
                td=td+1;
                da_action = da_policy(s_da_td,params);
                da_action'
                s_t = update_commited_generators(da_action,s_t);
                da_market = getDailyGenerationPrediction(da_action,s_da_td,params);
                s_t.g = da_market(:,1); %first hour updated here, all others in 'transition'
            end
            %% SARSA
            %--take action--
            a_t = getAction(s_t,params);
            
            %--observe reward--
            s_t_post = getPostState(s_t,a_t,params); % update budget
            Wc_t = drawContingency(s_t_post,params);
            r_t_post = calcReliability(s_t_post, Wc_t,params); %after action and contingency
%             r_t_post = max(r_t_post,0.1);
            rollout_value = rollout_value+r_t_post;
            %--get next state--
            s_tp1 = transition(s_t_post, Wc_t, da_market,s_da_td,params); %draw demand and wind, fix lines,time, da market on new day
            
           
            s_t = s_tp1;
            if(mod(s_t.t,24)==0) %last hour of the day ended
                s_da_td = transition_da(s_da_td,params);
            end
            
        end
        display(['Outer iter: ',num2str(i_episode),' / ',num2str(params.N_episode)]);
%         save([params.save_dir,params.filename,'.mat'],'theta_post','params')
        toc;
    end
end