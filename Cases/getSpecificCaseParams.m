function [ caseParams ] = getSpecificCaseParams( caseName )

switch caseName
    case 'case5'
        generatorTypeVector=[1,3,5,7,9];
        generatorBusVector=[1,1,3,4,5];
        initialGeneratorState=[3;3;4;5;3]; %change -3 to 3
        loads=[5;13;10;10;21]; %peak load. Irrelevant currently for all
        %except case 24 - just rescaling original load according to generation
        windBuses = [1,2];
        windScaleRatio=20; %wind generation mean will be devided by this factor
        windHourlyForcast = getWindHourlyForcast(windBuses);
    case 'case9'
        generatorTypeVector=[2,2,1];
        generatorBusVector=[1,2,3];
        initialGeneratorState=[3;3;-3];
        loads=[0;6;2;0;0;10;5;0;7];
        windBuses = [1,2];
        windScaleRatio=30;
        windHourlyForcast = getWindHourlyForcast(windBuses);
    case 'case14'
        generatorTypeVector=[1,2,3,4,5];
        generatorBusVector=[1,2,3,6,8];
        initialGeneratorState=[3;3;-3;10;10];
        loads=[0;6;2;0;10;0;0;7;10;8;9;5;6;7];
        windBuses = [1,2];
        windScaleRatio=3;
        windHourlyForcast = getWindHourlyForcast(windBuses);
    case {'case24_ieee_rts','case24'}
        load 'Cases/ieee_RTS96_UW';
        IEEE_24_gen_range=1:32;
        generatorTypeVector=generatorTypes(IEEE_24_gen_range)';
        generatorBusVector=generatorBuses(IEEE_24_gen_range);
        initialGeneratorState=initialState(IEEE_24_gen_range);
        %         windBuses = mod(windBuses,100);changed to have wind only in buses
        %         with demand, so no negative demand is received.
        windBuses = 1:9;
        windScaleRatio=15;
        loads=peakHourLoads(1:24); %num of buses in this case
    case 'case96'
        load 'Cases/ieee_RTS96_UW';
        windBuses = 1:9;
        windScaleRatio=15;
        generatorTypeVector=generatorTypes';
        generatorBusVector=generatorBuses;
        initialGeneratorState=initialState;
        loads=peakHourLoads;
end
caseParams.generatorTypeVector=generatorTypeVector;
caseParams.generatorBusVector=generatorBusVector;
caseParams.initialGeneratorState=initialGeneratorState;
caseParams.loads=loads;

%% wind model parameters
caseParams.windBuses = windBuses;
caseParams.windHourlyForcast = windHourlyForcast;
caseParams.windScaleRatio=windScaleRatio;
end

