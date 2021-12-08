%This code is for determining the non-dominated site combinations with
%given preference information for the site combination selection problem of
%Assignment 3. 
%Add your code to places marked with XXXXX (6 instances). 
%Making the additions may require you to write some preceding lines of code.
close all, clear all
%-------------------------------Defining data--------------------------------------
%m: number of sites
m=10;
%n: number criteria
n=9;
%M: number of site combinations
M=2^m;
%A: m x 1 - vector of sites' areas
A=[1.2 3 2.1 3 0.8 2 3 0.9 1.1 2.4]';
%c: m x 1 - vector of sites' costs
c=[2400 5700 4725 7800 1560 4500 6150 1728 1859 4800]; 
%b: budget
b=25000;
%v: m x n - matrix of attribute scores multiplied with site areas 
v=zeros(n,m); %Define m * n - matrix f here (The rows of f define the objective functions of the MOO problem)
v(1,:) = [0 0.3 0.4 0.625 0.95 1 0.3 0.4 0.475 0.125];
v(2,:) = [0.888888889 0.518518519 0.25 0.933333333 0.555555556 0 0 0.866666667 0.977777778 0.62962963];
v(3,:) = [0.595238095 0.428571429 0 0.142857143 0.571428571 0.857142857 1 0.071428571 0.571428571 0.80952381];
v(4,:) = [0.555555556 0.055555556 0.5 0 1 0 0.388888889 0.388888889 0.666666667 0.222222222];
v(5,:) = [0.2 0.75 1 0.85 0.8 0.95 0.15 0.4 0.4 0.2];
v(6,:) = [0.55 0.25 1 0.1 0.05 0.8 0.5 0.5 0.8 0.1];
v(7,:) = [0 0 0 0 0.3 0 0 0 0.4 0.05];
v(8,:) = [0.500488759 0.750733138 0 0 0 0.500488759 0.999022483 0.96969697 0 0.500488759];
v(9,:) = [0 1 0.581731655 0.425767726 0 0.5 0.190983006 0 0 0.671720323];
v=v';
V = A.*v; %times area and transpose, since the initial input is the wrong way

%Aw: (q x n) dimensional matrix  
%Bw: (q x 1) dimensional vector  
%such that w belongs to S if and only if Aw*w <= Bw
w = [0.0835016 0.0553747 0.0369165 0.1031880 0.1375840 0.1547820 0.2293060 0.0916330 0.1077140]';
r= w/w(7);
diag_ones = eye(n,n);
A_temp_upper = -diag_ones;
A_temp_upper(:,7) = A_temp_upper(:,7) + 0.8.*r;
A_temp_lower = diag_ones;
A_temp_lower(:,7) = A_temp_lower(:,7) - 1.25*r;
Aw = [A_temp_upper;A_temp_lower]; %Define Aw here (It may be helpful to define Aw with multiple lines of code)
Bw=zeros(2*n,1); %Define Bw here (It may be helpful to define Bw with multiple lines of code)

%Z: M x m binary matrix of all 2^m possible site combinations 
%i.e. Z(k,j)=1 if and only if combination k includes site j
Z=zeros(M,m);
for k=1:M
    Z(k,:)=bitget(M-k,1:m);
end

%% %------------------------Identifying feasible combinations--------------------------
%F: M-dimensional binary vector indicating feasible site combinations
%i.e. F(j)=1 if and only if combination j is feasible
F=zeros(M,1);

%Checking which of the combinations are feasible 
%For feasible combination k, it is set F(k)=1 
for k=1:M
    if (c*Z(k,:)'<=b) %Define the condition for a site combination being feasible here
        F(k)=1;
    end
end

%% %------------------------Identifying dominated combinations-------------------------
%D: M-dimensional binary vector indicating dominated site combinations
%i.e. D(j)=1 if and only if feasible combination j is dominated by a feasible
%combination
D=zeros(M,1);

%Checking which feasible combinations are dominated by another feasible combination
%If feasible combination k is dominated, it is set D(k)=1
for k=1:M
    if (F(k)==1 && D(k)==0)
        for kk=1:M
            if (F(kk)==1 && D(kk)==0 && kk~=k)
                %Determining the smallest and largest value differences
                %between porfolios Z(k,:) and Z(kk,:) within the set of
                %feasible weights S.
                f=(Z(k,:) - Z(kk,:))*V; %Define the attribute value differences of portfolios k and kk here
                [wopt,minVdif] = linprog(f,Aw,Bw,[],[],zeros(n,1),ones(n,1));
                [wopt,maxVdif] = linprog(-1*f,Aw,Bw,[],[],zeros(n,1),ones(n,1));
                maxVdif=-1*maxVdif;
                if (minVdif>=0 && maxVdif>0)
                    D(kk)=1;
                end
            end
        end
    end
end

%% %-----------------------Collecting non-dominated combinations-------------------------
%Z_ND: (number of ND-combinations) x m - binary matrix of non-dominated combinations 
%i.e. Z_ND(k,j)=1 if and only if ND-combination k inclu<des site j
Z_ND=[];
for k=1:M
    if (F(k)==1 && D(k)==0)
        Z_ND=[Z_ND;Z(k,:)];
    end
end
Z_ND %Shows the value of Z_ND in the command window

%-----------------Identifying dominated combinations given no preference information-------
%D2: M-dimensional binary vector indicating dominated site combinations
%i.e. D2(j)=1 if and only if feasible combination j is dominated by a feasible
%combination
D2=zeros(M,1);

%Checking which feasible combinations are dominated by another feasible combination
%If feasible combination k is dominated, it is set D2(k)=1
for k=1:M
    if (F(k)==1 && D2(k)==0)
        for kk=1:M
            if (F(kk)==1 && D2(kk)==0 && kk~=k)
                %Determining the smallest and largest value differences
                %between porfolios Z(k,:) and Z(kk,:) within the set of
                %feasible weights S^0.
                %As the extreme points of S^0 are easy to determine, the
                %value differences are determined by going through the
                %extreme points one by one.
                w_ext=eye(n); %columns of w_ext represent extreme points of S^0
                minVdif=10^6;
                maxVdif=0;
                for i=1:n
                    dif=((Z(k,:) - Z(kk,:))*V)*w_ext(:,i); %Define the value difference between portfolios k and kk at i:th extreme point here
                    if dif < minVdif
                        minVdif=dif;
                    elseif dif > maxVdif
                        maxVdif=dif;
                    end
                end
                if (minVdif>=0 && maxVdif>0)
                    D2(kk)=1;
                end
            end
        end
    end
end

%% %--------------Collecting non-dominated combinations given no preference information------------
%Z_ND2: (number of ND-combinations) x m - binary matrix of non-dominated combinations 
%i.e. Z_ND2(k,j)=1 if and only if ND-combination k includes site j
Z_ND2=[];
for k=1:M
    if (F(k)==1 && D2(k)==0)
        Z_ND2=[Z_ND2;Z(k,:)];
    end
end
Z_ND2 %Shows the value of Z_ND2 in the command window