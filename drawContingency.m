function [Wc] = drawContingency(state, params)
r = rand(size(state.e));
isFunctional = ~state.e;
Wc.drawnContingencies = r < isFunctional.*params.Pcont;
if(sum(Wc.drawnContingencies)>0)
    display(['time: ',num2str(state.t),' Contingency happend in line',num2str(find(Wc.drawnContingencies'))]);
end

