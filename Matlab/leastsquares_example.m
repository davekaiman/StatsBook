% Victor Z
% UW-Madison, 2020
% least-squares fit of gauss and weibull

clc
clear all
close all hidden

% generate observations for weibull
rng(0)
n = 1000;
xdata = wblrnd(2,1,n,1);

%% visualize data
figure(1)
subplot(2,1,1)
plot(xdata,'blacko','MarkerFaceColor','w','MarkerSize',4)
xlabel('$\omega$','Interpreter','latex','FontSize',14)
ylabel('$x_\omega$','Interpreter','latex','FontSize',14)
grid on

%% first assume gaussian and use moment mathching
mu=mean(xdata);
sigma=sqrt(var(xdata));
subplot(2,1,2)
xgrid=linspace(-4,10,100)
histogram(xdata,'BinWidth',1,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
plot(xgrid,normpdf(xgrid,mu,sigma),'black-','LineWidth',1.5);
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
axis([-4 10 0 0.4])
grid on
legend({'Empirical','Least-Squares'},'location','northeast','Interpreter','latex','FontSize',14)
print -depsc gauss_ls_fit.eps

%% now assume Weibull and fit to cdf

% generate thresholds and ecdf at thresholds
N = 20;
t = linspace(min(xdata),max(xdata),N);

for k=1:length(t)
   s=0;
   for j=1:n
       if xdata(j)<=t(k)
           s=s+1;
       end
   end
   F(k)=(1/n)*s;
end

% drop last term
t=t(1:N-1);
F=F(1:N-1);

% solve least-squares problem
 y = log(t);
 z = log(-log(1 - F));
 
 my=mean(y);
 mz=mean(z);
 a=sum(z.*(y-my))/sum(z.*(z-mz));
 b=my-a*mz;
 
 xi=1/a
 beta=exp(b)

figure(2)
subplot(2,1,1)
tgrid=linspace(0,max(t),100);
plot(tgrid,wblcdf(tgrid,beta,xi),'black-','LineWidth',1.5);
hold on
plot(t,F,'blacko','MarkerFaceColor','w')
xlabel('$t$','Interpreter','latex','FontSize',14) 
ylabel('$F(t)$','Interpreter','latex','FontSize',14)
axis([0 10 0 1.05])
grid on
subplot(2,1,2)
xgrid=linspace(0,16,100);
histogram(xdata,'BinWidth',0.5,'Normalization','pdf','EdgeColor','black','FaceColor','none','LineWidth',1)
hold on
plot(xgrid,wblpdf(xgrid,beta,xi),'black-','LineWidth',1.5);
axis([0 10 0 0.6])
xlabel('$x$','Interpreter','latex','FontSize',14)
ylabel('$f(x)$','Interpreter','latex','FontSize',14)
grid on
legend({'Empirical','Least-Squares'},'location','northeast','Interpreter','latex','FontSize',14)
print -depsc weibull_ls_fit.eps
