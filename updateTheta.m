function [theta,bellman_err,value_diff] = updateTheta(s_t,s_tp1,da_market,r_t,theta,stepSize,params,i_d_t,i_w_t,value_matrix,value_matrix_approx)
bellman_err=0;
value_diff=inf;
    
if(isnan(r_t))
    return;
end

ph_t = getDWFeatures(s_t,params,da_market);
ph_tp1 = getDWFeatures(s_tp1,params,da_market);
bellman_err = r_t + (params.gamma*ph_tp1-ph_t)'*theta;
theta = theta + stepSize*bellman_err*ph_t;
if(nargin > 7)
    value_matrix_approx(i_d_t,i_w_t) = ph_t'*theta;
    if(sum(size(value_matrix)-size(value_matrix_approx))==0)
        value_diff = sum(sum(abs(value_matrix-value_matrix_approx)));
    end
end