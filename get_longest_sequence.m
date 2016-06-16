function num_groups = get_longest_sequence(gen_group)
c = 1;
num_groups=0;
for i=1:(length(gen_group)-1)
    if(gen_group(i) == gen_group(i+1))
        c=c+1;
    else 
        c=1;
    end
    if(c>num_groups)
        num_groups = c;
    end
end
