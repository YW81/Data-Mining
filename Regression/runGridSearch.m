images = './images/';
data = './data/';
addpath(genpath('./model'));
addpath(genpath('./utils'));

load('LabUCIReg.mat', 'LabUCIReg');
load('LabOParams.mat', 'OParams');
load('LabIParams.mat', 'IParams');
load('Outputs.mat', 'Outputs');
% 数据集
DataSetIndices = [3 4];
ParamIndices = [1 3 6 7];
% 实验设置
TaskNum = 8;
Kfold = 3;
solver = []; % optimoptions('fmincon', 'Display', 'off');

% 开启绘图模式
fprintf('runGridSearch\n');
% 对每一个数据集
for i = DataSetIndices
    DataSet = LabUCIReg(i);
    fprintf('runGridSearch: %s\n', DataSet.Name);
    % 构造多任务数据集
    [X, Y, ValInd] = MultiTask(DataSet, TaskNum, Kfold);
    [X, Y] = Normalize(X, Y);
    % 交叉验证索引
    opts = struct('solver', solver);
    % 对每一种算法
    for j = ParamIndices
        % 得到算法信息
        method = OParams{j};
        % 网格搜索、交叉验证
        [ Stat, CVStat ] = GridSearchCV(@MTL, X, Y, IParams{j}, TaskNum, Kfold, ValInd, opts);
        % 保存网格搜索交叉验证的结果
        Output = {DataSet.Name, DataSet.Instances, DataSet.Attributes, CVStat};
        Outputs{i, j} = Output;
        save('Outputs.mat', 'Outputs');
        save([data, DataSet.Name, '-', method.Name, '-Stat.mat'], 'Stat');
        save([data, DataSet.Name, '-', method.Name, '-CVStat.mat'], 'CVStat');
    end
end

save('Outputs.mat', 'Outputs');