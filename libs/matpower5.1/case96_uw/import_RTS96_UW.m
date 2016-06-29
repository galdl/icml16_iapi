horizon=24;
generatorMap=xlsread('input_UC_ii(1)','g_map');
generatorCapacities=xlsread('input_UC_ii(1)','generators_c','A3:B98');
ng=length(generatorCapacities);
generatorData=getGeneratorData();
generatorTypes=generatorMap(:,end); %verified that it corresponds with other data from the xls file
generatorBuses=zeros(ng,1);
for i=1:ng
    generatorBuses(i)=find(generatorMap(i,1:end-1));
end
dailyLoads=xlsread('input_UC_ii(1)','load','L27:CF50');
offTimes=xlsread('input_UC_ii(1)','generators_c','E3:E98');
onTimes=xlsread('input_UC_ii(1)','generators_c','H3:H98');
initialState=min(onTimes,horizon)-min(offTimes,horizon);
hourlyFraction=xlsread('input_UC_ii(1)','load','G27:G50');
%% cheking whether we need to take the full table or extrapolation is enough
[peakLoad,peakHour]=max(sum(dailyLoads,2));
peakHourLoads=dailyLoads(peakHour,:);
extrapolatedLoads=kron(peakHourLoads,hourlyFraction);
diff=dailyLoads-extrapolatedLoads;
%diff turns out to be 0, looks like they extrapolated themselves. No need
%for the full table
save('ieee_RTS96_UW');