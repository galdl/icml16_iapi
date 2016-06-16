function action_set = get_bus_grouping(params)
run('get_global_constants.m')

[~,felxibility_order] = sort(params.mpcase.gen(:,PMAX)./max(params.mpcase.gen(:,PMIN),1),'descend');
% [~,permuation] = sort(felxibility,'descend');
permuation = params.mpcase.gen(felxibility_order,BUS_I);
group = zeros(params.ng,1);
action_set = [];
orig = 1:length(permuation);
while(length(permuation)>0)
    [bus_id,gen_bus,gen_group] = unique(permuation);
    idx = gen_bus;
    permuation(idx)=[];
    group(orig(idx)) = 1;
    orig(idx)=[];
    action_set = [action_set,group];
end
% 
%     [bus_id,gen_bus,gen_group] = unique(params.mpcase.gen(:,BUS_I));
%     num_groups = get_longest_sequence(gen_group);
%     groups = [];
%     for i_group = 1:num_groups
%         current_group = [];
%         for i_gen = 1:length(gen_group)
%             next_ones = unique(gen_group);
%             for i_inner = 1:length(next_ones)
% %             arrayfun(@(x)find(next_ones(x)==gen_group),1:length(gen_group),'UniformOutput',false)
%               found = find(gen_group==next_ones(i_inner))
%               current_group = [current_group,found(1)];
%             end
%             gen_group(current_group) = nan;
%         end
%     end