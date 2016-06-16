function [fileName] = writeMPC(mpcase, fileName)

fid = fopen([fileName,'.m'],'wt');
fprintf(fid, 'function mpc = tempCase\n');
fprintf(fid, '%%CASE5  Power flow data for modified 5 bus, 5 gen case based on PJM 5-bus system\n');
fprintf(fid, '%%   Please see CASEFORMAT for details on the case file format.\n');
fprintf(fid, '%%\n');
fprintf(fid, '%%   Based on data from ...\n');
fprintf(fid, '%%     F.Li and R.Bo, "Small Test Systems for Power System Economic Studies",\n');
fprintf(fid, '%%     Proceedings of the 2010 IEEE Power & Energy Society General Meeting\n');
fprintf(fid, '\n');
fprintf(fid, '%%   Created by Rui Bo in 2006, modified in 2010, 2014.\n');
fprintf(fid, '%%   Distributed with permission.\n');
fprintf(fid, '\n');
fprintf(fid, '%%   MATPOWER\n');
fprintf(fid, '%%   $Id: case5.m 2408 2014-10-22 20:41:33Z ray $\n');
fprintf(fid, '\n');
fprintf(fid, '%%%% MATPOWER Case Format : Version 2\n');
fprintf(fid, 'mpc.version = ''2'';\n');
fprintf(fid, '\n');
fprintf(fid, '%%%%-----  Power Flow Data  -----%%%%\n');
fprintf(fid, '%%%% system MVA base\n');
fprintf(fid, 'mpc.baseMVA = 100;\n');
fprintf(fid, '\n');
fprintf(fid, '%%%% bus data\n');
fprintf(fid, '%%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin\n');
fprintf(fid, 'mpc.bus = [\n');
fprintf(fid,'\t%d\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f;\n',mpcase.bus');
fprintf(fid, '];\n');
fprintf(fid,'\n');
fprintf(fid,'%%%% generator data\n');
fprintf(fid,'%%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf\n');
fprintf(fid,'mpc.gen = [\n');
fprintf(fid,'\t%d\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f;\n',mpcase.gen');
fprintf(fid,'];\n');
fprintf(fid,'\n');
fprintf(fid,'%%%% branch data\n');
fprintf(fid,'%%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax\n');
fprintf(fid,'mpc.branch = [\n');
fprintf(fid,'\t%d\t%d\t%.5f\t%.4f\t%.5f\t%f\t%f\t%f\t%f\t%f\t%f\t%f\t%f;\n',mpcase.branch');
fprintf(fid,'];\n');
fprintf(fid,'\n');
fprintf(fid,'%%%%-----  OPF Data  -----%%%%\n');
fprintf(fid,'%%%% generator cost data\n');
fprintf(fid,'%%	1	startup	shutdown	n	x1	y1	...	xn	yn\n');
fprintf(fid,'%%	2	startup	shutdown	n	c(n-1)	...	c0\n');
fprintf(fid,'mpc.gencost = [\n');
fprintf(fid,'\t%d\t%f\t%f\t%f\t%f\t%f\t%f;\n',mpcase.gencost')
fprintf(fid,'];\n');

fclose(fid);
end