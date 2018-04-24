function [ yTest, Time ] = SVM(xTrain, yTrain, xTest, opts)
%CSVM 此处显示有关此类的摘要
% C-Support Vector Machine
%   此处显示详细说明

%% Parse opts
C = opts.C;            % 参数
kernel = opts.kernel;  % 核函数

%% Fit
tic
X = xTrain;
Y = yTrain;
% 二次规划求解
e = ones(size(Y));
H = Cond((Y*Y').*Kernel(X, X, kernel));
Alpha = quadprog(H, -e, Y', 0, [], [], 0*e, C*e, [], []);
svi = Alpha > 0 & Alpha < C;
% 停止计时
Time = toc;

%% Predict
yTest = sign(Kernel(xTest, X(svi,:), kernel)*(Y(svi).*Alpha(svi)));
yTest(yTest==0) = 1;

end