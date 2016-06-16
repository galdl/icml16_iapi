function modifiedMpcase=setCaseParams(caseName,generatorData,generatorTypeVector,generatorBusVector,loads,caseParams)
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
if(~strcmp(caseName,'case24_ieee_rts')) % for all except case24 - no longer deciding on loads on my own, just rescaling
    loadToGenRatio=0.8; %change 1.2 to 0.8
    loadRescaleFactor=getLoadRescaleFactor(loadToGenRatio,modifiedMpcase,caseParams);
    modifiedMpcase.bus=scale_load(loadRescaleFactor,modifiedMpcase.bus);
else
    modifiedMpcase.bus(:,3)=loads;
end