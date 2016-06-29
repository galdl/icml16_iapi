function theyare=whoare(g,w)
n=length(g);
W=zeros(n,n+1);
for i=1:n
W(i,1)=sum(checkcc(g,i)*w');
W(i,2:n+1)=checkcc(g,i);
%end
end
winnerssort=sortrows(W,[-1]);
theyare=winnerssort(1,2:n+1);
end



