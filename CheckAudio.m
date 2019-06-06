%
% code & research by : PDB
%

function result = CheckAudio(path)
%	path    (string):   "file.wav"  path
% 

[x,fs] = audioread(path);

if ~exist('classifier','var')
    classifier = load('func/classifier.mat');
end

result = FileTester(classifier,x,fs);

end