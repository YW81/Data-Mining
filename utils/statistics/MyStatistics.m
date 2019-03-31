function [ MyStat, MyTime, MyRank, MyName ] = MyStatistics(DataSets, IParams, Type, opts)
%MYSTATISTICS 此处显示有关此函数的摘要
%   此处显示详细说明

    % 创建文件夹
    Src = ['./data/', lower(Type) ];
    Dst = ['./lab/', lower(Type) ];
    if exist(Src, 'dir') == 0
        mkdir(Src);
    end
    if exist(Dst, 'dir') == 0
        mkdir(Dst);
    end
    
    % 统计每个数据集上的多任务实验数据
    MyStat = [];
    MyTime = [];
    MyRank = [];
    MyName = {};
    n = length(DataSets);
    for j = 1 : n
        DataSet = DataSets(j);
        try
            [ LabStat, LabTime, HasStat ] = LabStatistics(Src, DataSet, IParams, opts);
            if HasStat == 1
               SaveStatistics(Dst, DataSet, LabStat, LabTime, opts);
               if opts.Mean == 1
                   MyStat = cat(2, MyStat, LabStat(:,1,:));
                   MyTime = cat(2, MyTime, LabTime(:,1));
                   [ ~, IDX ] = sort(LabStat(:,1,1));
                   MyRank = cat(2, MyRank, IDX);
                   MyName = cat(1, MyName, DataSet.Name);
               end
            end
        catch MException
            fprintf(['Exception in: ', DataSet.Name, '\n']);
        end
    end
end