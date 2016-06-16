function [theta_post,phi_hist_post] = evaluate_theta_pi(psi,s_da_0_cell,params)
%% initialize variables
N_stpes = params.da_horizon*params.num_of_days;
warning off
da_market_null = nan(params.ng,params.da_horizon);
s = initializeState(da_market_null,params);
theta_length = length(getDWFeatures(s,params,da_market_null));
phi_hist_post = zeros(theta_length,N_stpes,length(s_da_0_cell));

%% obtain samples for estimating RT theta given DA policy theta_pi
for i_s0 = 1:length(s_da_0_cell)
    s_da_td = s_da_0_cell{i_s0};
    %% value iteration initialization
    theta_post = zeros(theta_length,1);
    c=0;
    td=0;
    %% run value iteration
    for i_episode=1:params.N_episode
        display(['Episode ',num2str(i_episode)]);tic;
        s_t = initializeState(da_market_null,params);
        s_tm1_post = s_t;
        r_tm1_post = nan;
        for t = 1:N_stpes
            if(mod(s_t.t,24)==1) %beginning of the day
                td=td+1;
                da_action = get_da_action(psi,s_da_td,params);
                da_action'
                s_t = update_commited_generators(da_action,s_t);
                da_market = getDailyGenerationPrediction_opf(da_action,s_da_td,params);
                s_t.g = da_market(:,1); %first hour updated here, all others in 'transition'
            end
            %% SARSA
            c = c+1;
            
            %--take action--
            a_t = getAction(s_t,params);
            
            %--observe reward--
            s_t_post = getPostState(s_t,a_t,params); % update budget
            Wc_t = drawContingency(s_t_post,params);
            r_t_post = calcReliability(s_t_post, Wc_t,params); %after action and contingency
%             r_t_post = max(r_t_post,0.1);
            
            %--get next state--
            s_tp1 = transition(s_t_post, Wc_t, da_market,s_da_td,params); %draw demand and wind, fix lines,time, da market on new day
            
            %% update theta
            stepSize = 0.1*c^(-0.3); %0.1, (1*c^(-0.5))
            print_vars=[];
            
            [theta_post,bellman_err_post] = updateTheta(s_tm1_post,s_t_post,da_market,r_tm1_post,theta_post,stepSize,params);
%             print_vars = [print_vars,bellman_err_post];
            
            ph_t_post = getDWFeatures(s_t_post,params,da_market);
            val_post_approx = ph_t_post'*theta_post;
            phi_hist_post(:,c,i_s0) = ph_t_post;
            print_vars = [print_vars,val_post_approx]
%             print_vars
            
            
            s_t = s_tp1;
            s_tm1_post = s_t_post; %st->at->st(a)->Wt->r(st(a),Wt)->W,D->stp1->atp1->stp1(ap1)->Wtp1->r(stp1(ap1),Wtp1)->Wp1,Dp1
            r_tm1_post = r_t_post;
            if(mod(s_t.t,24)==0) %last hour of the day ended
                s_da_td = transition_da(s_da_td,params);
            end
            
        end
        display(['Outer iter: ',num2str(i_episode),' / ',num2str(params.N_episode)]);
%         save([params.save_dir,params.filename,'.mat'],'theta_post','params')
        toc;
    end
end