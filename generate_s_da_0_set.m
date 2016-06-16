function s_da_0_vec = generate_s_da_0_set(params)
s_da_0_vec = cell(params.N_s_da_0,1);
for i_s0 = 1:length(s_da_0_vec)
    if(strcmp('case24_ieee_rts',params.caseName))
        dev_w_da = -1.9*(i_s0-1);
    elseif(strcmp('case96',params.caseName))
        dev_w_da = -1.9*(i_s0-1);
    else
        dev_w_da = -1.15*(i_s0-1);
    end
    s_da_0_vec{i_s0} = draw_s_da_0(params,dev_w_da);
end
