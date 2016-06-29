function modifiedMpcase=setCaseParams_opfonly(modifiedMpcase,generatorData,generatorTypeVector,generatorBusVector,loads)
modifiedMpcase.gencost=[];
modifiedMpcase.gen=[];
for g=1:length(generatorTypeVector)
    modifiedMpcase.gencost=[modifiedMpcase.gencost;buildCostRow(generatorData{generatorTypeVector(g)})];
    modifiedMpcase.gen=[modifiedMpcase.gen;generatorBusVector(g) generatorData{generatorTypeVector(g)}.PMAX	0	30	-30	 1	100	1	generatorData{generatorTypeVector(g)}.PMAX	generatorData{generatorTypeVector(g)}.PMIN 	0	0   	0	0	0	0	0	0	0	0	0];
end
modifiedMpcase.bus(:,3)=loads;

% 
% modifiedMpcase.bus=[modifiedMpcase.bus;modifiedMpcase.bus(14,:)];
% modifiedMpcase.bus(15,1)=15;
% modifiedMpcase.bus(14,3)=0;

% modifiedMpcase.bus=[modifiedMpcase.bus;modifiedMpcase.bus(5,:)];
% modifiedMpcase.bus(7,1)=7;
% modifiedMpcase.bus(7,3)=0;

% modifiedMpcase.branch=[modifiedMpcase.branch;modifiedMpcase.branch(4,:)];
% modifiedMpcase.branch(7,1)=14;
% modifiedMpcase.branch(7,2)=15;
% 
% modifiedMpcase.branch=[modifiedMpcase.branch;modifiedMpcase.branch(4,:)];
% modifiedMpcase.branch(8,1)=4;
% modifiedMpcase.branch(8,2)=7;






%case5_mod_=setCaseParams(case5,generatorData,[1,1,1,1,1],[1,1,3,4,5])