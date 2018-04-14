function [  ] = SaveFigures( Path, DataSet, LabStat, LabTime )
%SAVEFIGURES 此处显示有关此函数的摘要
% 保存图表
%   此处显示详细说明

    % 保存时间图表
    bar(LabTime(:, 1));
    FileName = [DataSet.Name, '-Time'];
    SaveFigure(Path, FileName);
    
    % 保存误差图表
    Indices = {'MAE', 'RMSE', 'SSE/SST', 'SSR/SSE'};
    for i = 1 : 4
        Index = replace(Indices{i}, '/', '_');
        FileName = [DataSet.Name, '-' Index];
        bar(LabStat(:,:,i), 'DisplayName', FileName);
        SaveFigure(Path, FileName);
    end
    
    function SaveFigure(Path, FileName)
        StatPath = [Path, '/fig/', FileName];
        saveas(gcf, StatPath, 'fig');
        fprintf('save: %s\n', StatPath);
        StatPath = [Path, '/eps/', FileName];
        saveas(gcf, StatPath, 'epsc');
        fprintf('save: %s\n', StatPath);
    end
end
