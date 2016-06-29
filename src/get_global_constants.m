global global_consts

globalStr = ['global '];
for i = 1:length(global_consts)
    globalStr = [globalStr,global_consts{i},' '];
end
eval(globalStr)