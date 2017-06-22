f_X = @(x) 2*sin(1.5 * x);

numOfInsts = 20;
numOfSamples = 100;

%generate 20 random number in range [0,5]
testSamples = zeros(1,20);
for i = 1:20
    testSamples(i) = rand * 5;
end;
testSamples = [1:20]/4;

%generate 100 different Samples each containing 20 instances
trainingSamples = zeros(numOfInsts,2,numOfSamples);
for j = 1: numOfSamples
    curSample = zeros(numOfInsts,2);
    for i = 1:numOfInsts
        epsilone = normrnd(0,1);
        x = rand * 5;
        fX = f_X(x);
        y = fX + epsilone;
        row = [x y];
        curSample(i,:) = row;
    end;
    trainingSamples(:,:,j) = curSample;
end;

%For each sample, fit polynomial models of order 1,2,3,4, and 5.
biasMat = zeros(1,5);
varianceMat = zeros(1,5);
errorMat = zeros(1,5);
for polDegree = 1:5
    wMatTotal = zeros(polDegree+1,1);
    giMat = zeros(polDegree+1,numOfSamples);
    for j = 1:numOfSamples
        curSample = trainingSamples(:,:,j);
        D = zeros(numOfInsts,polDegree + 1); % initialize D
        D(:,1)  = ones(numOfInsts,1);
        for i = 2:polDegree+1
            D(:,i) = curSample(:,1).^(i-1);
        end
        r = curSample(:,2);

        wMat = inv(transpose(D) * D ) * transpose(D) * r; % get coeffss for g(x)
        wMatTotal = wMatTotal + wMat; %keep all coeffs for all samples
        giMat(:,j) = wMat; 
    end;
    gAvg = wMatTotal/numOfSamples; %  find mean of g(x)
    
    sumBias = 0;
    sumVariance = 0;
    sumError = 0;
    for k = 1:numOfInsts
        xT = testSamples(1,k);
        y = f_X(xT);
        sumBias = sumBias + (polyval(flipud(gAvg),xT) - f_X(xT))^2;
        
        for l = 1:numOfSamples
            sumVariance = sumVariance + ( polyval(flipud(giMat(:,l)),xT) - polyval(flipud(gAvg),xT))^2 ;
        end;
        
        sumError = sumError + (y-polyval(flipud(gAvg),xT))^2;
    end;
    bias = sumBias/numOfInsts;
    bias = sqrt(bias);
    variance = sumVariance / (numOfInsts * numOfSamples);
    error = sumError / numOfInsts;
    
    biasMat(1,polDegree) = bias;
    varianceMat(1,polDegree) = variance;
    errorMat(1,polDegree) = error;
end;

figure('Name','Bias/Variance Dilemma')
plot(1:5,biasMat,'-.ob',1:5,varianceMat,'--g', 1:5, errorMat, 'r')
title('Bias/Variance Dilemma')
legend('Bias','Variance','Error','Location','southwest');


%%% THIS IS THE START OF QUESTION 2 %%%
idx = randperm(numOfInsts);
trainingSet = trainingSamples(1:10,:,:);
validationSet = trainingSamples(11:20,:,:);

%For training set, fit polynomial models of orders 1 to 5. 
maxPolOrder = 5;
numOfInsts = 10;
trainingErrorMat = zeros(1,maxPolOrder);
validationErrorMat = zeros(1,maxPolOrder);
for polDegree = 1:maxPolOrder
    wMatTotal = zeros(polDegree+1,1);
    giMat = zeros(polDegree+1,numOfSamples);
    for j = 1:numOfSamples
        curSample = trainingSet(:,:,j);
        D = zeros(numOfInsts,polDegree + 1); % initialize D
        D(:,1)  = ones(numOfInsts,1);
        for i = 2:polDegree+1
            D(:,i) = curSample(:,1).^(i-1);
        end
        r = curSample(:,2);

        wMat = inv(transpose(D) * D ) * transpose(D) * r; % get coeffss for g(x)
        wMatTotal = wMatTotal + wMat; %keep all coeffs for all samples
        giMat(:,j) = wMat; 
    end;
    gAvg = wMatTotal/numOfSamples; %  find mean of g(x)
    
    trainErrorSum = 0;
    validateErrorSum = 0;
    for j = 1:numOfSamples
        
        curTrainSample = trainingSet(:,:,j);
        curValidationSample = validationSet(:,:,j);
        
        %calculate error sum for training set
        for i = 1:numOfInsts
            xT = curTrainSample(i,1);
            actualValue = curTrainSample(i,2);
            predictedValue = polyval(flipud(gAvg),xT);
            trainErrorSum = trainErrorSum + (predictedValue-actualValue)^2;
        end;
        
        %calculate error sum for validation set
        for i = 1:numOfInsts
            xT = curValidationSample(i,1);
            actualValue = curValidationSample(i,2);
            predictedValue = polyval(flipud(gAvg),xT);
            validateErrorSum = validateErrorSum + (predictedValue-actualValue)^2;
        end;
    end;
    
    trainErrorAvg = trainErrorSum / (numOfSamples * numOfInsts);
    validateErrorAvg = validateErrorSum / (numOfSamples * numOfInsts);
    
    trainingErrorMat(1,polDegree) = trainErrorAvg;
    validationErrorMat(1,polDegree) = validateErrorAvg;
end;

figure('Name','Error vs. polynomial order')
plot(1:maxPolOrder, trainingErrorMat, '-.ob', 1:maxPolOrder, validationErrorMat, '--g')
title('Error vs. polynomial order')
legend('Training','Validation','Location','southwest');



