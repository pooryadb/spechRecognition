%
% code & research by : PDB
%

function result = CheckAudioA(path,port)
%	path    (string):   "file.wav"  path
%	port    (string):   port name of arduino connection
% 


[x,fs] = audioread(path);

if ~exist('classifier','var')
    classifier = load('func/classifier.mat');
end

result = FileTester(classifier,x,fs);

disp("sending command");
if result == 1
    command = "open";
else
    command = "close";
    
[msg,state] = arduinoFunc(port,command);
% msgbox(msg);
disp(msg);

end