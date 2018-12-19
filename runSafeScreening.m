clc
clear

Path = './data/ssr/rbf/';
if exist(Path, 'dir') == 0
    mkdir(Path);
end

% ��������·��
addpath(genpath('./datasets'));
addpath(genpath('./params'));
addpath(genpath('./model'));
addpath(genpath('./utils'));

%% �������ݼ���������������
load('Caltech5.mat');
load('LabCParams.mat');

DataSets = Caltech5;
IParams = CParams;

% ���ݼ�
DataSetIndices = [ 1:15 ];
ParamIndices = [ 1:6 9:13 ];

%% ʵ������
solver = [];%struct('parallel', false);
opts = InitOptions('clf', 0, solver, 0);
fd = fopen(['./log/log-', datestr(now, 'yyyymmddHHMM'), '.txt'], 'w');

% ʵ�鿪ʼ
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
        Method = IParams{j};
        Name = [Method.Name, '-', DataSet.Name];
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