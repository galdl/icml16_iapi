function ph = calculate_feature_vector(d,e_d,e_g)
ph_hat = [1;d;d.^2;e_d;e_g];
ph=ph_hat*ph_hat';
lower_traingle_indices = (tril(ones(size(ph)))>0);
ph_l=ph(lower_traingle_indices);
ph=ph_l(:);