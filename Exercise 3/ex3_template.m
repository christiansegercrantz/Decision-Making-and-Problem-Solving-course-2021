close all, clear all
t = 1:0.001:2;

alpha = 0.5

%define the functions
u1 = exp(alpha).*((1-exp(-alpha.*t))./(1-exp(-alpha)) -1 )
u2 = log(t)/log(2)
u3 = (sqrt(t)-1)./(sqrt(2)-1)


%after that they can be plotted with the given code
plot(t,u1,t,u2,t,u3,t,t-1,'LineWidth',2)
legend('u1, exp', 'u2, log', 'u3, iso-e',"linear", 'location','northwest')


close all, clear all

A1=[0 1 1.5 2 2.5 4 6 7 7.5];
A2=[0 1.5 3 4 4.5 6 9 9.5 10];
A3=[0 5 5.5 6 6.5 7 8 9 10];

%Fill in CDF
CDF=[0 0.05 0.1 0.2 0.4 0.7 0.85 0.95 1];

%use stairs function for plotting
stairs(A1, CDF, '-o', 'LineWidth', 2)
hold on
stairs(A2, CDF, '-o', 'LineWidth', 2)
stairs(A3, CDF, '-o', 'LineWidth', 2)
legend('A1', 'A2', 'A2', 'location','northwest')
