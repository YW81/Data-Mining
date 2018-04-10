function [ OStat ] = CrossValid( Learner, X, Y, TaskNum, Kfold, ValInd, Params )
%CROSSVALID 此处显示有关此函数的摘要
% Cross Validation
%   此处显示详细说明

    % 多任务交叉验证统计
    CVStat = zeros(Kfold, 4, TaskNum);
    % 交叉验证
    for j = 1 : Kfold
        fprintf('CrossValid: %d\n', j);
        % 分割训练集和测试集
        [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, j, ValInd);
        % 在一组任务上训练和预测
        [ y, ~ ] = Learner(xTrain, yTrain, xTest, Params);
        % 统计多任务学习数据
        CVStat(j,:,:) = MTLStatistics(TaskNum, y, yTest);
    end
    
    % 统计多任务交叉验证结果
    OStat = CVStatistics(CVStat);

%% 训练测试集
    function [ xTrain, yTrain, xTest, yTest ] = TrainTest(X, Y, Kfold, ValInd)
        test = ValInd==Kfold;
        train = ~test;
        xTrain = X(train,:);
        yTrain = Y(train,:);
        xTest = X(test,:);
        yTest = Y(test,:);
    end

%% 多任务训练测试集
    function [ xTrain, yTrain, xTest, yTest ] = MTLTrainTest(X, Y, TaskNum, Kfold, ValInd)
        xTrain = cell(TaskNum, 1);
        yTrain = cell(TaskNum, 1);
        xTest = cell(TaskNum, 1);
        yTest = cell(TaskNum, 1);
        for t = 1 : TaskNum
            [ xTrain{t}, yTrain{t}, xTest{t}, yTest{t} ] = TrainTest(X{t}, Y{t}, Kfold, ValInd{t});
        end
    end

%% 统计数据
    function [ MAE, RMSE, SSE, SSR, SST ] = Statistics(y, yTest)
        y_bar = mean(yTest);
        E = yTest-y;
        E2 = E.^2;
        MAE = mean(abs(E));
        RMSE = sqrt(mean(E2));
        SSE = sum(E2);
        SST = sum((yTest-y_bar).^2);
        SSR = sum((y-y_bar).^2);
    end

%% 多任务统计数据
    function [ OStat ]  = MTLStatistics(TaskNum, y, yTest)
        OStat = zeros(4, TaskNum);
        for t = 1 : TaskNum
            [ MAE, RMSE, SSE, SSR, SST ] = Statistics(y{t}, yTest{t});
            OStat(:, t) = [ MAE, RMSE, SSE/SST, SSR/SSE ];
        end
    end

%% 交叉验证多任务统计
    function [ OStat ] = CVStatistics(IStat)
        MStat = mean(IStat);
        OStat = permute(MStat, [2 3 1]);
    end

end
