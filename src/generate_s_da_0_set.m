function s_da_0_vec = generate_s_da_0_set(params)
% Generate a set of day-ahead demand-wind forecasts (DA s0 state) with 
% varying intensity. Each such day has a different forecast mean. 
% The number of the different days is params.N_s_da_0.
% These days are crafted to push the network to the limits, with numbers
% changing from extremly low demand and strong wind, to extermly high
% demand and low wind.

s_da_0_vec = cell(params.N_s_da_0,1);
for i_s0 = 1:length(s_da_0_vec)
    if(strcmp('case24_ieee_rts',params.caseName))
        dev_w_da = -1.9*(i_s0-1);
    elseif(strcmp('case96',params.caseName))
        dev_w_da = -1.9*(i_s0-1); %1.9
    else
        dev_w_da = -1*(i_s0-1)/2;
    end
    s_da_0_vec{i_s0} = draw_s_da_0(params,dev_w_da);
end
