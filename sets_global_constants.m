function [] = sets_global_constants()
global global_consts
define_constants;

global_consts = who;

for i = 1:length(global_consts)
    eval(['global ',global_consts{i}])
end


end