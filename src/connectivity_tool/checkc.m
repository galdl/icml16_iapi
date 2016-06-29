function conncheckie=checkc(g)
n=length(g);
I=zeros(1,n);
I(1)=1;
count=1;
while sum(I)<n && count<n
for i=1:n 
if I(i)==1
for j=1:n if g(i,j)==1 g(j,:)=g(j,:)+g(i,:); g(j,j)=0; I(j)=1;
    end
end
end
end
count=count+1;
count;
end
if sum(I)==n conncheckie=1; else conncheckie=0; end








