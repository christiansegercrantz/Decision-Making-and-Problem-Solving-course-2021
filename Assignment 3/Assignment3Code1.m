%This code is for solving Pareto optimal (PO) solutions to the MOO problem
%defined in Assignment 3. 
%Add your code to places marked with XXXXX (3 instances).
%Making the additions may require you to write some preceding lines of code.

close all %close all figures

%---------------------------------Defining given parameters-------------------------------------
%n: number attributes
n=9; 
%m: number of sites
m=10;
%A: m x 1 - vector of sites' areas
A=[1.2 3 2.1 3 0.8 2 3 0.9 1.1 2.4]';
%c: 1 x m - vector of sites' costs
c=[2400 5700 4725 7800 1560 4500 6150 1728 1859 4800]; 
%b: budget
b=25000;

%--------------------------------Calculating utopian vector--------------------------------------
f=XXXXX %Define m * n - matrix f here (The rows of f define the objective functions of the MOO problem)
a=c;
vlb=zeros(m,1);
vub=ones(m,1);
xint=1:m;
utopian_vec=zeros(n,1);
for i=1:n
    [x, utopian_fi, exitflag]=intlinprog(-f(:,i),xint,a,b,[],[],vlb,vub);
    utopian_fi=-1*utopian_fi;
    utopian_vec(i)=1.1*utopian_fi;
end

%--------------------------------------Solving PO-solutions in a loop--------------------------------------------------
%Set of PO-solutions initialized as an empty set
X=[];
figure %Figure for plots is initialized
for k=1:5000
    lambda=rand(n,1);
    lambda=lambda/sum(lambda); 
    
    %---------------------------Weighted sum approach-------------------------------------------------
    [x, WS, exitflag] = intlinprog(XXXXX); %Fill in the arguments of intlinprog regarding the weighted sum approach
    %(It may be helpful to define the arguments separately on preceding lines)
    
    %Update of X (PO-solution x found with the weighted sum approach is
    %added to X only if x isn't already in X)
    dublicate=0;
    if ~isempty(X)
        for d=1:size(X,1)
            if max(abs(X(d,:)-x')) < 10^(-6)
                dublicate=1;
                break;
            end
        end
    end
    if (dublicate==0)
        X=[X ; x'];
    end
    
    %----------------------------Weighted max-norm approach -------------------------------------------
    [x2, WS, exitflag] = intlinprog(XXXXX); %Fill in the arguments of intlinprog regarding the weighted max-norm approach
    %(It may be helpful to define the arguments separately on preceding lines)
    
    x=x2(1:m); %Discarding the optimal value of Delta from the PO-solution x2
   
    %Update of X (PO-solution x found with the weighted sum approach is
    %added to X only if x isn't already in X)
    dublicate=0;
    if ~isempty(X)
        for d=1:size(X,1)
            if max(abs(X(d,:)-x')) < 10^(-6)
                dublicate=1;
                break;
            end
        end
    end
    if (dublicate==0)
        X=[X ; x'];
    end
    
    %---------------------------Plotting and updating figures based on the results---------------------

    %Plot showing the core indices of the different sites
    subplot(2,1,1);
    bar(sum(X)/size(X,1))
    axis([0.5 m+0.5 0 1])
    xlabel('j')
    ylabel('Share of PO-solutions with x_j=1') 
    
    %Plot showing the (M)ILPs solved versus PO-solution found
    subplot(2,1,2)
    plot(2*k,size(X,1),'.')
    xlabel('MILPs and ILPs solved')
    ylabel('Number of PO-solutions found')
    hold on
    drawnow
end