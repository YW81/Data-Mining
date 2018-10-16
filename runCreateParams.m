clc
clear

addpath(genpath('./utils/'));

% 核函数参数
P1 = 2.^(-3:1:8)';

% 分类器网格搜索参数
C = 2.^(-3:1:8)';
C1 = 2.^(-3:1:8)';
C2 = 2.^(-3:1:8)';
C3 = 1e-7;% cond 矫正
C4 = 1e-7;% cond 矫正
EPS1 = [0.01;0.02;0.05;0.1];
EPS2 = [0.01;0.02;0.05;0.1];
RHO = 2.^(-3:1:8)';
LAMBDA = 2.^(-3:1:8)';
GAMMA = 2.^(-3:1:8)';
NU = 2.^(-3:1:8)';
% MTL-aLS-SVM
RATE = [0.83,0.90,0.97]';
% MTCTSVM
P = (0.5:0.5:2.0)';
% VSTG-MTL
K = (3:2:13)';
k = (1:2:7)';
% v-TWSVM
V = 2.^(-6:0)';

%% 核函数
kernel = struct('kernel', 'rbf', 'p1', P1);
% kernel = struct('kernel', 'linear');

%% 回归任务参数
RParams = {
    struct('Name', 'SVR', 'C', C, 'eps', EPS1, 'kernel', kernel);...
    struct('Name', 'PSVR', 'nu', NU, 'kernel', kernel);...
    struct('Name', 'LS_SVR', 'gamma', GAMMA, 'kernel', kernel);...
    struct('Name', 'TWSVR', 'C1', C1, 'C3', C3, 'eps1', EPS1, 'kernel', kernel);... 
    struct('Name', 'TWSVR_Xu', 'C1', C1, 'eps1', EPS1, 'kernel', kernel);...
    struct('Name', 'LS_TWSVR_Mei', 'C1', C1, 'eps1', EPS1, 'kernel', kernel);...
    struct('Name', 'LS_TWSVR_Huang', 'eps1', EPS1, 'kernel', kernel);...
    struct('Name', 'MTL_LS_SVR', 'lambda', LAMBDA, 'gamma', GAMMA, 'kernel', kernel);...
    struct('Name', 'MTL_PSVR', 'lambda', LAMBDA, 'nu', NU, 'kernel', kernel);...
    struct('Name', 'MTL_TWSVR', 'C1', C1, 'eps1', EPS1, 'rho', RHO, 'kernel', kernel);...
    struct('Name', 'MTL_TWSVR_Xu', 'C1', C1, 'eps1', EPS1, 'rho', RHO, 'kernel', kernel);...
    struct('Name', 'MTL_LS_TWSVR', 'C1', C1, 'eps1', EPS1, 'rho', RHO, 'kernel', kernel);...
    struct('Name', 'LS_TWSVR_Xu', 'C1', C1, 'eps1', EPS1, 'kernel', kernel);...
    struct('Name', 'MTL_LS_TWSVR_Xu', 'C1', C1, 'eps1', EPS1, 'rho', RHO, 'kernel', kernel)...
};

[ RParams ] = PrintParams('./params/LabRParams-Linear.txt', RParams);
save('./params/LabRParams-Linear.mat', 'RParams');
%% 分类任务参数
CParams = {
    struct('Name', 'SVM', 'C', C, 'kernel', kernel);...
    struct('Name', 'PSVM', 'nu', NU, 'kernel', kernel);...
    struct('Name', 'LS_SVM', 'gamma', GAMMA, 'kernel', kernel);...
    struct('Name', 'TWSVM', 'C1', C1, 'kernel', kernel);...
    struct('Name', 'LS_TWSVM', 'C1', C1, 'kernel', kernel);...
    struct('Name', 'vTWSVM', 'v1', V, 'kernel', kernel);...
    struct('Name', 'MTL_PSVM', 'lambda', LAMBDA, 'nu', NU, 'kernel', kernel);...
    struct('Name', 'MTL_LS_SVM', 'lambda', LAMBDA, 'gamma', GAMMA, 'kernel', kernel);...
    struct('Name', 'MTL_aLS_SVM', 'C1', C, 'C2', C, 'rho', RATE, 'kernel', kernel);...
    struct('Name', 'MTL_TWSVM_Xie', 'C1', C1, 'rho', RHO, 'kernel', kernel);...
    struct('Name', 'MCTSVM', 'C1', C1, 'rho', RHO, 'p', P, 'kernel', kernel);...
    struct('Name', 'MTL_LS_TWSVM', 'C1', C1, 'rho', RHO, 'kernel', kernel);...
    struct('Name', 'MTvTWSVM', 'v1', V, 'rho', RHO, 'kernel', kernel);...
%     struct('Name', 'MTBSVM', 'C1', C1, 'C3', C1, 'rho', RHO, 'kernel', kernel);...
%     struct('Name', 'MTLS_TBSVM', 'C1', C1, 'C3', C1, 'rho', RHO, 'kernel', kernel);...
};

%     struct('Name', 'VSTG_MTL', 'func', 'logistic', 'gamma1', GAMMA, 'gamma2', GAMMA, 'K', K, 'k', k);...

% 保存参数表
[ CParams ] = PrintParams('./params/LabCParams.txt', CParams);
save('./params/LabCParams.mat', 'CParams');