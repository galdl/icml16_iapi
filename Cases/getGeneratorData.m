function generatorData= getGeneratorData( )
%generation cost pwl, thus is calculated in the following way:
%there are 3 segments w/ 3 slopes. all segments are the same length
%cost=noLoad + location on the appropriate segment times the slope + all
%costs up to that point
%start-up costs have 8 levels, for 8 different time blocks
generatorData=cell(1,9);
generatorData{1}.PMAX=12;
generatorData{1}.PMIN=5.4;
generatorData{1}.RU=60;
generatorData{1}.RD=70;
generatorData{1}.MU=2;
generatorData{1}.MD=1;
generatorData{1}.cost.noLoad=365.46;
generatorData{1}.cost.segmentLength=2.2;
generatorData{1}.cost.segmentSlopes=[29.453;30.12;30.856];
generatorData{1}.cost.startUpBlocksCosts=[20;22.85714286;25.71428571;28.57142857;31.42857143;34.28571429;37.14285714;40];
generatorData{1}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

generatorData{2}.PMAX=20;
generatorData{2}.PMIN=8;
generatorData{2}.RU=90;
generatorData{2}.RD=100;
generatorData{2}.MU=2;
generatorData{2}.MD=1;
generatorData{2}.cost.noLoad=454.572;
generatorData{2}.cost.segmentLength=4;
generatorData{2}.cost.segmentSlopes=[28.967;29.243;29.703];
generatorData{2}.cost.startUpBlocksCosts=[25;28;31;34;37;40;43;46];
generatorData{2}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

generatorData{3}.PMAX=50;
generatorData{3}.PMIN=26;
generatorData{3}.RU=120;
generatorData{3}.RD=120;
generatorData{3}.MU=2;
generatorData{3}.MD=1;
generatorData{3}.cost.noLoad=626.106;
generatorData{3}.cost.segmentLength=8;
generatorData{3}.cost.segmentSlopes=[28.313;29.256;30.498];
generatorData{3}.cost.startUpBlocksCosts=[30;34.28571429;38.57142857;42.85714286;47.14285714;51.42857143;55.71428571;60];
generatorData{3}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

generatorData{4}.PMAX=76;
generatorData{4}.PMIN=40;
generatorData{4}.RU=120;
generatorData{4}.RD=120;
generatorData{4}.MU=3;
generatorData{4}.MD=2;
generatorData{4}.cost.noLoad=263.409;
generatorData{4}.cost.segmentLength=12;
generatorData{4}.cost.segmentSlopes=[18.413;19.218;20.092];
generatorData{4}.cost.startUpBlocksCosts=[44;50.85714286;57.71428571;64.57142857;71.42857143;78.28571429;85.14285714;92];
generatorData{4}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

generatorData{5}.PMAX=100;
generatorData{5}.PMIN=40;
generatorData{5}.RU=420;
generatorData{5}.RD=420;
generatorData{5}.MU=4;
generatorData{5}.MD=2;
generatorData{5}.cost.noLoad=306.617;
generatorData{5}.cost.segmentLength=20;
generatorData{5}.cost.segmentSlopes=[17.6904;18.3804;19.0658];
generatorData{5}.cost.startUpBlocksCosts=[60;68.57142857;77.14285714;85.71428571;94.28571429;102.8571429;111.4285714;120];
generatorData{5}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

generatorData{6}.PMAX=155;
generatorData{6}.PMIN=54.24;
generatorData{6}.RU=70;
generatorData{6}.RD=80;
generatorData{6}.MU=24;
generatorData{6}.MD=16;
generatorData{6}.cost.noLoad=415.541;
generatorData{6}.cost.segmentLength=33.58;
generatorData{6}.cost.segmentSlopes=[23.8096;24.5249;25.2402];
generatorData{6}.cost.startUpBlocksCosts=[562;775.7142857;989.4285714;1203.142857;1416.857143;1630.571429;1844.285714;2058];
generatorData{6}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

generatorData{7}.PMAX=197;
generatorData{7}.PMIN=104;
generatorData{7}.RU=310;
generatorData{7}.RD=310;
generatorData{7}.MU=4;
generatorData{7}.MD=3;
generatorData{7}.cost.noLoad=482.862;
generatorData{7}.cost.segmentLength=31;
generatorData{7}.cost.segmentSlopes=[17.1925;17.7077;18.2252];
generatorData{7}.cost.startUpBlocksCosts=[110;127.1428571;144.2857143;161.4285714;178.5714286;195.7142857;212.8571429;230];
generatorData{7}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

generatorData{8}.PMAX=350;
generatorData{8}.PMIN=140;
generatorData{8}.RU=140;
generatorData{8}.RD=140;
generatorData{8}.MU=8;
generatorData{8}.MD=5;
generatorData{8}.cost.noLoad=303.72;
generatorData{8}.cost.segmentLength=70;
generatorData{8}.cost.segmentSlopes=[24.74511063;24.74976876;24.75442688];
generatorData{8}.cost.startUpBlocksCosts=[5170;6154.857143;7139.714286;8124.571429;9109.428571;10094.28571;11079.14286;12064];
generatorData{8}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

generatorData{9}.PMAX=400;
generatorData{9}.PMIN=100;
generatorData{9}.RU=280;
generatorData{9}.RD=280;
generatorData{9}.MU=168;
generatorData{9}.MD=24;
generatorData{9}.cost.noLoad=188.3079;
generatorData{9}.cost.segmentLength=70;
generatorData{9}.cost.segmentSlopes=[6.960789;7.229889;7.498989];
generatorData{9}.cost.startUpBlocksCosts=[35000;35714.28571;36428.57143;37142.85714;37857.14286;38571.42857;39285.71429;40000];
generatorData{9}.cost.startUpBlocks=[1;2;3;4;5;6;7;8];

end

