function [ yTest, Time ] = MTL_TWSVR(xTrain, yTrain, xTest, opts)
%MTL_TWSVR 此处显示有关此类的摘要
% Multi-Task Twin Support Vector Machine
% MTL Peng's model
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
eps1 = opts.eps1;
eps2 = opts.eps1;
rho = opts.rho;
lambda = opts.rho;
kernel = opts.kernel;
solver = opts.solver;
TaskNum = length(xTrain);
[ A, Y, T ] = GetAllData(xTrain, yTrain, TaskNum);
    
%% Prepare
tic;
[m, ~] = size(A);
e = ones(m, 1);
C = A;
A = [Kernel(A, C, kernel) e];
% 得到f和g
f = Y + eps2;
g = Y - eps1;
% 得到P矩阵
P = sparse(0, 0);
AAAt = cell(TaskNum, 1);
for t = 1 : TaskNum
    At = A(T==t,:);
    AAAt{t} = Cond(At'*At)\(At');
    Pt = At*AAAt{t};
    P = blkdiag(P, Pt);
end
% 二次规划的H矩阵
AAA = Cond(A'*A)\A';
Q = A*AAA;
H = Q + P;

%% Fit
% 求解两个二次规划
[m, ~] = size(T);
e = ones(m, 1);
lb = zeros(m, 1);
% MTL_TWSVR1
ub1 = e*C1;
Alpha = quadprog(Q+TaskNum/rho*P,g-H'*f,[],[],[],[],lb,ub1,[],solver);
% MTL_TWSVR2
ub2 = e*C2;
Gamma = quadprog(Q+TaskNum/lambda*P,H'*g-f,[],[],[],[],lb,ub2,[],solver);

%% GetWeight
W = cell(TaskNum, 1);
U = AAA*(f - Alpha);
V = AAA*(g + Gamma);
for t = 1 : TaskNum
    Tt = T==t;
    Ut = AAAt{t}*(f(Tt,:) - TaskNum/rho*Alpha(Tt,:));
    Vt = AAAt{t}*(g(Tt,:) + TaskNum/lambda*Gamma(Tt,:));
    Uts = U + Ut;
    Vts = V + Vt;
    W{t} = (Uts + Vts)/2;
end
Time = toc;
    
%% Predict
TaskNum = length(xTest);
yTest = cell(TaskNum, 1);
for t = 1 : TaskNum
    At = xTest{t};
    [m, ~] = size(At);
    et = ones(m, 1);
    KAt = [Kernel(At, C, kernel) et];
    yTest{t} = KAt * W{t};
end
    
end