x = params.dev_d_vec;
y = d;
p=polyfit(x,y,3);
x1=linspace(-0.5,0.5,100);
y1=polyval(p,x1);
figure;
plot(x,y,'o');
hold on
plot(x1,y1);
hold off