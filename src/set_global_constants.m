function [] = set_global_constants()
% Matpower tool uses constants, loaded using define_constnats
% function. Calling this function is relatively heavy. Setting them as
% global significantly improves efficiency. 
global global_consts
define_constants;

global_consts = who;

for i = 1:length(global_consts)
    eval(['global ',global_consts{i}])
end


end