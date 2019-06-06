% code & research by : PDB

%   test single file with a specific classifier
function [result,match] = MyKNN(classifier, data , fs)
%   classifier	(.mat):         classifier with variables:
%                               trainedClassifier,m(mean),s(standard division)
%   data        (int matrix):   vector of audio in
%   fs          (int):          frequency sampling of audio in
%
%   return      
%           result  (Label->String):    word recognized from "classifier"
%                                       labels stored
%           match   (float):            Percentage of confidence
% 

trainedClassifier = classifier.trainedClassifier;
m = classifier.m;
s = classifier.s;

featuresTest = GetData(data,fs , m , s);

T = featuresTest(:,:);  % Rows that correspond to one file
predictedLabels = string(predict(trainedClassifier,T(:,:))); % Predict

[predictedLabel, freq] = mode(categorical(predictedLabels)); % Find most frequently predicted label
totalVals = size(predictedLabels,1);
match = freq/totalVals*100;

result = string(predictedLabel);

end

%   Extracts features from audio
function featuresTest = GetData(data , fs , m ,s)
%   data	(int matrix):   vector of audio in
%   fs      (int):          frequency sampling of audio in
%   m       (double):       mean of "trained data"
%   s       (double):       standard-division of "trained data"
%
%   return  (Table):        audio features (pitch ,mfcc1 ,... ,mfcc13)
%
info.SampleRate = fs;

result = cell(1,1);
result{1} = MyPitchAndMFCC(data,fs);

result = vertcat(result{:});
result = rmmissing(result);
% m = mean(result{:,:});
% s = std(result{:,:});

result{:,:} = (result{:,:}-m)./s;

featuresTest = result;

end