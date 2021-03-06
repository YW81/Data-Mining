function [ yTest, Time ] = TWSVR( xTrain, yTrain, xTest, opts )
%TWSVR 此处显示有关此类的摘要
% Twin Support Vector Machine
% see: Improvements on Twin Support Vector Machines
% see: TWSVR: Regression via Twin Support Vector Machine
%   此处显示详细说明

%% Parse opts
C1 = opts.C1;
C2 = opts.C1;
C3 = opts.C3;
C4 = opts.C3;
eps1 = opts.eps1;
eps2 = opts.eps1;
kernel = opts.kernel;
solver = opts.solver;
symmetric = @(H) (H+H')/2;
%% Fit
tic;
% 得到H
e = ones(size(yTrain));
C = xTrain;
H = [Kernel(xTrain, C, kernel) e];
% 得到f,g
f = yTrain + eps2;
g = yTrain - eps1;
% 得到Hu,Hv
H2 = H'*H;
I = speye(size(H2));
Hu = Cond(H2+C3*I)\H';
Hv = Cond(H2+C4*I)\H';
% 得到Q1，Q2
Q1 = symmetric(H*Hu);
Q2 = symmetric(H*Hv);
% 求解两个二次规划
[m, ~] = size(yTrain);
e = ones(m, 1);
lb = zeros(m, 1);
% TWSVR1
Alpha = quadprog(Q1,Q1'*f-g,[],[],[],[],lb,e*C1,[],solver);
% TWSVR2
Gamma = quadprog(Q2,f-Q2'*g,[],[],[],[],lb,e*C2,[],solver);
% 得到u,v
u = Hu*(f-Alpha);
v = Hv*(g+Gamma);
% 得到w
w = (u+v)/2;
% 停止计时
Time = toc;

%% Predict
[m, ~] = size(xTest);
e = ones(m, 1);
yTest = [Kernel(xTest, C, kernel), e]*w;

end