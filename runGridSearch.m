Path = './data/regression/linear/';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% 添加搜索路径
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

% 加载数据集和网格搜索参数
load('LabMTLReg.mat');
load('LabRParams-Linear.mat');

DataSets = LabMTLReg;
IParams = RParams;

% 数据集
DataSetIndices = [15 : 18];
ParamIndices = [9 10 13];

% 实验设置
opts = InitOptions('reg', 0, []);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

% 实验开始
fprintf('runGridSearch\n');
for i = DataSetIndices
    DataSet = DataSets(i);
    fprintf('DataSet: %s\n', DataSet.Name);
    [ X, Y, ValInd ] = GetMultiTask(DataSet);
    [ X ] = Normalize(X);
    for j = ParamIndices
        Method = IParams{j};
        Name = [DataSet.Name, '-', Method.Name];
        StatPath = [Path, Name, '.mat'];
        if exist(StatPath, 'file') == 2
            fprintf(fd, 'skip: %s\n', StatPath);
            continue;
        else
            try
                [ CVStat, CVTime ] = GridSearchCV(@MTL, X, Y, Method, DataSet.TaskNum, DataSet.Kfold, ValInd, opts);
                save(StatPath, 'CVStat', 'CVTime');
                fprintf(fd, 'save: %s\n', StatPath);
            catch Exception
                fprintf(fd, 'Exception in %s\n', Name);
            end
        end
    end
end
fclose(fd);