function modifiedMpcase=setCaseParams(caseName,generatorData,generatorTypeVector,generatorBusVector,loads)
if(strcmp(caseName,'case24'))
    caseName='case24_ieee_rts';
end
funcHandle=str2func(caseName);
modifiedMpcase=funcHandle();
modifiedMpcase.gencost=[];
modifiedMpcase.gen=[];
for g=1:length(generatorTypeVector)
    modifiedMpcase.gencost=[modifiedMpcase.gencost;buildCostRow(generatorData{generatorTypeVector(g)})];
    modifiedMpcase.gen=[modifiedMpcase.gen;generatorBusVector(g) generatorData{generatorTypeVector(g)}.PMAX	0	30	-30	 1	100	1	generatorData{generatorTypeVector(g)}.PMAX	generatorData{generatorTypeVector(g)}.PMIN 	0	0   	0	0	0	0	0	0	0	0	0];
end
modifiedMpcase.bus(:,3)=loads;
