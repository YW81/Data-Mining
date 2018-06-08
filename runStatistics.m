Src = './data/classify/rbf/';
Dst = './lab/classify/rbf/';

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('MTL_CIFAR_OvO.mat');
load('LabCParams.mat');

% 实验设置
opts = InitOptions('clf', 1, []);
MyStatistics(MTL_CIFAR, CParams, Src, Dst, opts);