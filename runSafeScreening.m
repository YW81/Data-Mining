clc
clear

Path = './data/ssr/linear/';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('DATA.mat');
load('LabSParams-Linear.mat');

% 数据集
DataSetIndices = [ 1 ];
ParamIndices = [ 1:4 ];

%% 实验设置 RMTL
solver = struct('Display', 'off');
opts = InitOptions('clf', 0, solver, 0, 3);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

% profile clear;
% profile on;
% 实验开始
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    StatDir = [ Path, int2str(DataSet.Kfold) '-fold/' ];
    if exist(StatDir, 'dir') == 0
        mkdir(StatDir);
    end
    for j = ParamIndices
        Method = SParams{j};
        Name = [Method.ID, '-', DataSet.Name];
        StatPath = [StatDir, Name, '.mat'];
        if exist(StatPath, 'file') == 2
            fprintf(fd, 'skip: %s\n', StatPath);
            continue;
        else
            try
                [ CVStat, CVTime, CVRate ] = SSR(X, Y, Method, DataSet.TaskNum, 1, ValInd, opts );
                save(StatPath, 'CVStat', 'CVTime', 'CVRate');
                fprintf(fd, 'save: %s\n', StatPath);
            catch Exception
                delete('check-point.mat');
                fprintf(fd, 'Exception in %s\n', Name);
            end
        end
    end
end
fclose(fd);
% profile viewer;
% p = profile('info');
% profsave(p, 'profile_results');