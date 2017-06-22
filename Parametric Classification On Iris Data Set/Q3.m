sampleMeanEst = @(data,colInd) mean(data(:,colInd));
sampleVarEst = @(data,colInd) var(data(:,colInd));
probXGivenCi = @(mean,var,x) 1/(sqrt(2*pi)*sqrt(var))*exp(-1*(x-mean)^2/(2*var));

A = importdata('iris.data.txt');
IrisSetosa = 1;
IrisVersicolour = 2;
numOfInsts = 100;
classes = zeros(numOfInsts,1);
features = zeros(numOfInsts,4);

cnt = 1;
for i=1:length(A)
    parts = strsplit(char(A(i)),',');
    
    if strcmp(char(parts(length(parts))),'Iris-setosa' ) == 1
        classes (cnt) = IrisSetosa;
        features(cnt,:) = str2double(parts(1:length(parts)-1));
        cnt = cnt + 1;
    elseif  strcmp(char(parts(length(parts))),'Iris-versicolor') == 1
        classes (cnt) = IrisVersicolour;
        features(cnt,:) = str2double(parts(1:length(parts)-1));
        cnt = cnt + 1;
    end;
end;

idx = randperm(numOfInsts);
trainFeats = features(idx(1:70),:);
testFeats = features(idx(71:100),:);
trainClasses = classes(idx(1:70),:);
testClasses = classes(idx(71:100),:);

%for each feature
%sepal length: index=1
%sepal width: index=2
%petal length: index=3
%petal width: index=4
strArr = cell(4,1);
for featClass = 1:4
    mC1 = sampleMeanEst(trainFeats(find(trainClasses==IrisSetosa),:),featClass);
    s2C1 = sampleVarEst(trainFeats(find(trainClasses==IrisSetosa),:),featClass);

    mC2 = sampleMeanEst(trainFeats(find(trainClasses==IrisVersicolour),:),featClass);
    s2C2 = sampleVarEst(trainFeats(find(trainClasses==IrisVersicolour),:),featClass);

    trueCnt = 0;
    falseCnt = 0;
    for i=1:length(testFeats)
        pxC1 = probXGivenCi(mC1,s2C1,testFeats(i,featClass));
        pxC2 = probXGivenCi(mC2,s2C2,testFeats(i,featClass));

        if pxC1 >= pxC2
            predicted = 1;
        else
            predicted = 2;
        end;

        actual = testClasses(i,1);

        if actual == predicted %true match
            trueCnt = trueCnt + 1;
        else
            falseCnt = falseCnt + 1;
        end;
    end;
    
    formatStr = 'for feature i:%d  mean of classes => IrisSetosa: %f  IrisVersicolour: %f ';
    formatStr = strcat(formatStr , '  variance of classes => IrisSetosa: %f  IrisVersicolour: %f ');
    formatStr = strcat(formatStr , '  true predicted: %d  false predicted: %d');
    str = sprintf(formatStr,featClass,mC1,mC2,s2C1,s2C2,trueCnt,falseCnt);
    strArr(featClass) = cellstr(str);
end;
