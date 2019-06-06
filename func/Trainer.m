%
% code & research by : PDB
%
function Trainer(path)

% create audio Datastore from voice files, categorizing with folder Names
ads = audioDatastore(path, 'IncludeSubfolders', true,...
    'FileExtensions', '.wav',...
    'LabelSource','foldernames');

% [trainDatastore, testDatastore]  = splitEachLabel(ads,0.80);
trainDatastore = ads;

disp('dataStores created');

lenDataTrain = length(trainDatastore.Files);
features = cell(lenDataTrain,1);
for i = 1:lenDataTrain
    [dataTrain, infoTrain] = read(trainDatastore);
    %remove sencond channel:
    if (size(dataTrain,2) > 0)
        dataTrain = dataTrain(:,1);
    end
    %get pitch & mfcc
    features{i} = MyHelperComputePitchAndMFCC(dataTrain,infoTrain);
end

features = vertcat(features{:});%covert to vertical array
features = rmmissing(features);%remove missing entries
featureVectors = features{:,2:15};
m = mean(featureVectors);
s = std(featureVectors);
features{:,2:15} = (featureVectors-m)./s;

disp('features calculated');

inputTable     = features;
predictorNames = features.Properties.VariableNames;
predictors     = inputTable(:, predictorNames(2:15));%only pitch % mfcc data
response       = inputTable.Label;%only labels

disp('training...');

trainedClassifier = fitcknn(...
    predictors, ...
    response, ...
    'Distance', 'euclidean', ...
    'NumNeighbors', 5, ...
    'DistanceWeight', 'squaredinverse', ...
    'Standardize', false, ...
    'ClassNames', unique(response));

disp('KNN trained');

k = 5;
group = response;
c = cvpartition(group,'KFold',k); % 5-fold stratified cross validation
partitionedModel = crossval(trainedClassifier,'CVPartition',c);

validationAccuracy = 1 - kfoldLoss(partitionedModel, 'LossFun', 'ClassifError');
fprintf('\nValidation accuracy = %.2f%%\n', validationAccuracy*100);

%save data to mat file
save('classifier','trainedClassifier','m','s');

end