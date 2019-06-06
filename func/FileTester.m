% code & research by : PDB

%
%   test single file with a specific classifier
%   and return appropriate response
function result = FileTester(classifier, audio , fs)
%   classifier	(.mat):         classifier with variables:
%                               trainedClassifier,m(mean),s(standard division)
%   audio       (int matrix):   vector of audio in
%   fs          (int):          frequency sampling of audio in
%
%   return      (int)
%                       1 : open
%                       0 : close

[r,match] = MyKNN(classifier, audio, fs);
disp('result= ' + r + ' %= '+match)
if r == "open"
    r = 1;
else
    r = 0;
end
% result = int2str(r);
if match > 51
    result = int2str(r);
else
    result = int2str(~r); %be-careful !
    
end