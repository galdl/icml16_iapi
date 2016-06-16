%% load file and fix length
% while(isempty(CE_stats{1,size(CE_stats,2)}))
% CE_stats=CE_stats(:,4:6);
i_CE = 9;
CE_stats(:,i_CE:end)=[];


vi_pi_concatenated = [];
vi_pi_concatenated_top = [];
vi_pi_local_concatenated = [];
N_CE_stats_c = size(CE_stats,2);
N_CE_stats_r = size(CE_stats,1);
% remove extreme values
% for i_column=1:N_CE_stats_c
%     current_values = CE_stats{3,i_column};
%     current_values = current_values(~isnan(current_values));
%     
%     extereme_val_loc = (current_values>100 | current_values<-10);
%     current_values = current_values(find(1-extereme_val_loc));
%     
%     med = median(current_values(current_values>0));
%     extereme_med_loc = (current_values>4*med | current_values<-3*med);
%     current_values = current_values(find(1-extereme_med_loc));
%     mu = mean(current_values(current_values>0));
%     s = std(current_values(current_values>0));
%     extereme_std_loc = (current_values>mu+3*s | current_values<mu-3*s);
%     sum(extereme_std_loc);
%     current_values = current_values(find(1-extereme_std_loc));
%     %stop condition: (current_values>100 | current_values<-100)
%     CE_stats{3,i_column} = current_values;
% end
%% 1 - plot action separation
min_length = min(arrayfun(@(x)(length(CE_stats{3,x})),1:length(CE_stats(3,:))));
for i_column=1:N_CE_stats_c
    current_column = CE_stats(:,i_column);
    for i_row=1:N_CE_stats_r
        if(min(size(current_column{i_row}))>1) % if matrix and not vector
            current_column{i_row} = current_column{i_row}(:,1:min_length);
        else
            current_column{i_row} = current_column{i_row}(1:min_length);
        end
    end
    CE_stats(:,i_column)=current_column;
    [values,idx] = sort(CE_stats{3,i_column},'descend');
        top_values = values(1:10);
    vi_pi_concatenated = [vi_pi_concatenated,values];
    vi_pi_concatenated_top = [vi_pi_concatenated_top,top_values];
    %     vi_pi_local_concatenated = [vi_pi_local_concatenated,CE_stats{4,i_column}];
    
end
clf;

figure(2);
m=mean(vi_pi_concatenated);
e=std(vi_pi_concatenated);
% errorbar(m,e,'r');

hold on;
m=mean(vi_pi_concatenated_top);
e=std(vi_pi_concatenated_top);
errorbar(m,e,'b');
fontSize=17;
set(gca,'fontsize',20);
title('Mean and standard deviation of CE solutions - case24','FontSize', 17);
xlabel('Iteration Count', 'FontSize', fontSize)
ylabel('Expected RT value', 'FontSize', fontSize)



hold off;
% since local and united are the same, we learn that the transition in RT
% is degenerate
% m=mean(vi_pi_local_concatenated);
% e=std(vi_pi_local_concatenated);
% errorbar(m,e,'r');
% hold off;

%% 2 - plot theta
% figure(3);
% for i_column=1:N_CE_stats_c
%     subplot(1,N_CE_stats_c,i_column);
%     m=mean(CE_stats{2,i_column}');
%     e=std(CE_stats{2,i_column}');
%     errorbar(m,e);
% end
%
%  m=mean(CE_stats{2,end}');
%  bar(m);
% fontSize=17;
% set(gca,'fontsize',20);
% title('RT feature weights - case24','FontSize', 17);
% xlabel('Features', 'FontSize', fontSize)
% ylabel('Feature weight', 'FontSize', fontSize)
%% show actions chosen
% for i_column = 1:N_CE_stats_c
%     psi_vec = CE_stats{1,i_column};
%     actions = cell2mat(arrayfun(@(x)(get_da_action(psi_vec(:,x),s_da_0_cell{1},params)),1:size(psi_vec,2),'UniformOutput',false));
%     arrayfun(@(x)sum(sum(abs(actions-repmat(params.action_set(:,x),[1,size(actions,2)])))==0),1:size(params.action_set,2),'UniformOutput',false);
% end



%% 3 - plot psi
psi_samples = [];
color_cell = {'r','b','g','k','y','m'};
for i_column = 1:N_CE_stats_c
    psi_samples = [psi_samples,CE_stats{1,i_column}];
end
[pc,score,latent,tsquare] = pca(psi_samples');
projected_samples = psi_samples'*pc(:,1:2);
x_range = [min(projected_samples(:,1)),max(projected_samples(:,1))];
y_range = [min(projected_samples(:,2)),max(projected_samples(:,2))];
cumVar=cumsum(latent)./sum(latent);
figure;
clf;
xyfontSize=16;
for i_column = 1:N_CE_stats_c
    coloring_vec = get_coloring_vec(CE_stats,i_column,s_da_0_cell,params,rho,false);
    projected_psi = CE_stats{1,i_column}'*pc(:,1:2);
    ax1=subplot(4,2,i_column);
    
    scatter(projected_psi(:,1),projected_psi(:,2),[],coloring_vec);
    colormap(ax1,winter);
    if(i_column>1)
        set(ax1,'xtick',[],'ytick',[],'fontsize',xyfontSize);
    else
        xlabel('PC 1','FontSize', xyfontSize);
        ylabel('PC 2','FontSize', xyfontSize);
    end
    title(['Iteration ',num2str(i_column)],'FontSize',16);
    
    xlim(x_range); ylim(y_range);
    %     legend('1','2','3','4','5','6');
end

%
% fontSize=17;
% set(gca,'fontsize',20);
% title('CE convergence of DA policy parameters (PCA)- case24','FontSize', 17);
% legend({'best percentile','samples'});
% xlabel('Features', 'FontSize', fontSize)
% ylabel('Feature weight', 'FontSize', fontSize)
%% plot day profiles and their choices
color_cell = {'r','b','g','k','y','m'};
color_mat = build_color_mat(size(params.action_set,2));
num_pert = 3;
best_psi = top_psi(:,1);
figure(5);
clf;
hold on;
factor = (0.6+i_pert*(4/num_pert));
for i_day = 1:params.N_s_da_0
    current_day = sum(s_da_0_cell{i_day}.demand - s_da_0_cell{i_day}.wind);
    for i_pert=1:num_pert
        current_day_pertubed = current_day + 0.05*mean(current_day)*randn([1,24]);
        artificial_da.demand = current_day_pertubed;
        artificial_da.wind = zeros([1,24]);
        action = get_da_action(best_psi,artificial_da,params);
        action_index = find(sum(abs(params.action_set - repmat(action,[1,size(params.action_set,2)])))==0);
        %         action_color = de2bi(action_index,3);
        %         if(strcmp('case24_ieee_rts',params.caseName))
        %             action_index = 1+ mod(action_index-1,length(color_cell)); %need to change to unique actions
        %         end
        %         plot(current_day_pertubed,color_cell{action_index});
        plot(current_day_pertubed,'Color',color_mat(action_index,:));
        
    end
end

%% plot day profiles and their choices
color_cell = {'r','b','g','k','y','m'};
color_mat = build_color_mat(size(params.action_set,2));
num_plots = 50;
best_psi = top_psi(:,1);
figure(5);
clf;
hold on;
range = sum(s_da_0_cell{params.N_s_da_0}.demand - s_da_0_cell{params.N_s_da_0}.wind)-...
    sum(s_da_0_cell{1}.demand - s_da_0_cell{1}.wind);
start_day = sum(s_da_0_cell{1}.demand - s_da_0_cell{1}.wind);
end_day = sum(s_da_0_cell{params.N_s_da_0}.demand - s_da_0_cell{params.N_s_da_0}.wind);
all_days = [];
for i_t = 1:1:length(end_day)
    all_days = [all_days,linspace(start_day(i_t),end_day(i_t),num_plots)'];
end
for i_plot=1:num_plots
    current_day_pertubed = all_days(i_plot,:) + 0.05*mean(all_days(round(num_plots/2),:))*randn([1,24]);
    artificial_da.demand = current_day_pertubed;
    artificial_da.wind = zeros([1,24]);
    action = get_da_action(best_psi,artificial_da,params);
    action_index = find(sum(abs(params.action_set - repmat(action,[1,size(params.action_set,2)])))==0)
    plot(current_day_pertubed,'Color',color_mat(action_index,:));
    
end


%% plot day  - continuous
color_cell = {'r','b','g','k','y','m'};
num_pert = 50;
best_psi = top_psi(:,1);
figure(6);
clf;
hold on;
current_day = sum(s_da_0_cell{1}.demand - s_da_0_cell{1}.wind);
for i_pert=1:num_pert
    current_day_pertubed = (0.6+i_pert*(4/num_pert))*current_day;
    artificial_da.demand = current_day_pertubed + 0.05*mean(current_day_pertubed).*randn([1,24]);
    artificial_da.wind = zeros([1,24]);
    action = get_da_action(best_psi,artificial_da,params);
    action_index = find(sum(abs(params.action_set - repmat(action,[1,size(params.action_set,2)])))==0);  %need to change to unique actions
    %     if(strcmp('case24_ieee_rts',params.caseName))
    %         action_index = 1+ mod(action_index-1,length(color_cell));
    %     end
    %     plot(artificial_da.demand,color_cell{action_index});
    plot(artificial_da.demand,'Color',color_mat(action_index,:));
end
