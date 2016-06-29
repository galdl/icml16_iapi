function nodeName = select_node(i_psi,maxConcurrentJobs)
%001-012 12 nodes each
%013 is all_q
%014-016 are down
%017-020 16 nodes each
i_psi = 1+mod(i_psi-1,maxConcurrentJobs);
if(i_psi<=12*12)
    nodeNum=1+floor((i_psi-1)/12);
else
    i_psi = i_psi - 12*12;
    nodeNum=17+floor((i_psi-1)/16);
end
if(nodeNum<10)
    nodeName = ['n00',num2str(nodeNum)];
else
    nodeName = ['n0',num2str(nodeNum)];
end
