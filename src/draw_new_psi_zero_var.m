function new_psi = draw_new_psi_zero_var(top_psi,N_psi)
% duplicate each top_psi vector a few times, and noramlly pertube each dup
new_psi = [];
min_std = 0.01;
length_psi = size(top_psi,1);
num_top_psi = size(top_psi,2);
num_duplicates_per_psi = ceil(N_psi/num_top_psi);
batch_size = [1,num_duplicates_per_psi];
%the range of values of elements of psi will be this element's standard deviation
range = max(top_psi,[],2) - min(top_psi,[],2)/4;
element_std = max(range,min_std);
element_std=zeros(size(element_std)); %DEBUG!
for i_batch=1:num_top_psi
    batch = repmat(top_psi(:,i_batch),batch_size) + ...
        repmat(element_std,batch_size).*randn(length_psi,num_duplicates_per_psi);
    new_psi = [new_psi,batch];
end
new_psi = new_psi(:,1:N_psi);