function color_mat = build_color_mat(n)

nums = 1:5;
powers_of_nums = nums.^3;
bigger = (n<=powers_of_nums);
round_to = find(bigger,1,'first');
vals = linspace(0,1,round_to);
[x,y,z] = meshgrid(vals,vals,vals);
color_mat=[x(:),y(:),z(:)];
%row 6 and 3 are very much alike
color_mat(3,:) = [0.2,0.3,0.7];