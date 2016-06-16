function sizegreatestgroup=bigcong(g)
n=length(g);
W=zeros(n,n+1);
for i=1:n
W(i,1)=sum(checkcc(g,i));
W(i,2:n+1)=checkcc(g,i);
%end
end
winnerssort=sortrows(W,[-1]);
%winners=W(1,2:n+1)
sizegreatestgroup=W(1,1);
end



