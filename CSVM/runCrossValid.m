images = '../images/CSVM/';
datasets = '../datasets/artificial/';

% 数据集名称
DatasetNames = {
    'Sine-4000', 'Grid-4000', 'Ring-4000'
};

% 加载数据集
load([datasets, 'Datasets.mat'], 'Datasets');
n = length(DatasetNames);

% 打开文件
fprintf('Datasets\tAccuracy\tRecall\tPrecision\tTime(s)\n');

% 开启绘图模式
fprintf('runCrossValid');
h = figure('Visible', 'on');

% 设置模型参数
C = 1136.5;
Sigma = 3.6;
Output = zeros(n, 5);
 
% 在三个数据集上测试
for i = 1 : n
    D = Datasets{i};
    [ Recall, Precision, Accuracy, FAR, FDR ] = CrossValid( D(1:1000,:), n, C, Sigma );
    Output(i, :) = [ Recall, Precision, Accuracy, FAR, FDR ];
    fprintf('%s\t%8.5f\t%8.5f\t%8.5f\n', DatasetNames{i}, Accuracy, Recall, Precision);
end

% 绘制条形图
bar(Output);

% 保存结果
csvwrite('runCrossValid.txt', Output);