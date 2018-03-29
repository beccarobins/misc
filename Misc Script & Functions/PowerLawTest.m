close all
logx=log(x);
logy=log(y);
p=polyfit(logx,logy,1);
k=p(1);
loga=p(2);
a=exp(loga);
plot(x,y,'.');
xlabel('x');
ylabel('y');
hold on; 
plot(x,a*x.^k,'r.')
legend('Data',sprintf('y=%.3f{}x^{%.3f}',a,k));
axis([min(0),max(300),min(0),max(9)]);