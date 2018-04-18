function [ yTest, Time, W ] = MTL_TWSVR_Mei( xTrain, yTrain, xTest, opts )
%MTL_TWSVR_MEI �˴���ʾ�йش˺�����ժҪ
% 2018��4��3��17:12:10
%   �˴���ʾ��ϸ˵��

%% Parse opts
    TaskNum = length(xTrain);
    C1 = opts.C1;
    C2 = opts.C1;
    eps1 = opts.eps1;
    eps2 = opts.eps1;
    rho = TaskNum/opts.rho;
    lambda = TaskNum/opts.rho;
    kernel = opts.kernel;
    solver = opts.solver;
    
%% Prepare
    tic;
    [ A, Y, T ] = GetAllData( xTrain, yTrain, TaskNum );
    [m, ~] = size(A);
    e = ones(m, 1);
    C = A;
    A = [Kernel(A, C, kernel) e];
    
    %% �õ�Q,P����
    % �õ�P����
    P = [];
    AAAt = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = A(T==t,:);
        AAAt{t} = Cond(At'*At)\At';
        P = blkdiag(P, At*AAAt{t});
    end
    % �õ�Q����
    AAA = Cond(A'*A)\A';
    Q = A*AAA;
    
%% Fit
    % ����������ι滮
    [m, ~] = size(T);
    e = ones(m, 1);
    lb = zeros(m, 1);
    QPY = (Q+P)'*Y;
    % MTL_TWSVR1
    ub1 = e*C1;
    Alpha = quadprog(Q+rho*P,(Y+eps1)-QPY,[],[],[],[],lb,ub1,[],solver);
    % MTL_TWSVR2
    ub2 = e*C2;
    Gamma = quadprog(Q+lambda*P, QPY-(Y-eps2),[],[],[],[],lb,ub2,[],solver);
    
%% Get W
    W = cell(TaskNum, 1);
    U = AAA*(Y - Alpha);
    V = AAA*(Y + Gamma);
    for t = 1 : TaskNum
        Tt = T==t;
        Ut = AAAt{t}*(Y(Tt,:) - rho*Alpha(Tt,:));
        Vt = AAAt{t}*(Y(Tt,:) + lambda*Gamma(Tt,:));
        Uts = U + Ut;
        Vts = V + Vt;
        W{t} = (Uts + Vts)/2;
    end
    Time = toc;
    
%% Predict
    [ TaskNum, ~ ] = size(xTest);
    yTest = cell(TaskNum, 1);
    for t = 1 : TaskNum
        At = xTest{t};
        [m, ~] = size(At);
        et = ones(m, 1);
        KAt = [Kernel(At, C, kernel) et];
        yTest{t} = KAt * W{t};
    end
    
end
