%   get pitch and 13 first MFCC coefficient
function t = MyPitchAndMFCC(data, fs)
%   data	(int matrix):   vector of audio in
%   fs      (int):          frequency sampling of audio in
%
%   return  (Table):        audio features (pitch ,mfcc1 ,... ,mfcc13)
%

% Compute pitch and MFCC for frames of the file

[pitch1, mfcc1] = computePitchMFCC(data,fs);

% Output structure
s = struct();
s.Pitch = pitch1;
s.MFCC1 = mfcc1(:,1);
s.MFCC2 = mfcc1(:,2);
s.MFCC3 = mfcc1(:,3);
s.MFCC4 = mfcc1(:,4);
s.MFCC5 = mfcc1(:,5);
s.MFCC6 = mfcc1(:,6);
s.MFCC7 = mfcc1(:,7);
s.MFCC8 = mfcc1(:,8);
s.MFCC9 = mfcc1(:,9);
s.MFCC10 = mfcc1(:,10);
s.MFCC11 = mfcc1(:,11);
s.MFCC12 = mfcc1(:,12);
s.MFCC13 = mfcc1(:,13);

t = struct2table(s);
end

function [pitch1, mfcc1] = computePitchMFCC(x,fs)


pwrThreshold = -50; % Frames with power below this threshold (in dB) are likely to be silence
freqThreshold = 1000; % Frames with zero crossing rate above this threshold (in Hz) are likely to be silence or unvoiced speech

% Audio data will be divided into frames of 30 ms with 75% overlap
frameTime = 25e-3;
samplesPerFrame = floor(frameTime*fs);
% ---- remove silence

% normalize data
x = x / abs(max(x));

%smooth the signal
x = sgolayfilt(x,2,9);

% -- bandpass filter
% n = 2;
% beginFreq = 500 / (fs/2);
% endFreq = 15000 / (fs/2);
% [b,a] = butter(n, [beginFreq, endFreq], 'bandpass');

% Filter the signal
% x = filter(b, a, x);

% -- bandpass filter

n = length(x);
n_f = floor(n/samplesPerFrame);
temp = 0;
for i = 1 : n_f
    
   frames(i,:) = x(temp + 1 : temp + samplesPerFrame);
   temp = temp + samplesPerFrame;
end

m_amp = abs(max(frames,[],2)); % find maximum of each frame
id = find(m_amp > 0.03); % finding ID of frames with max amp > 0.07
fr_ws = frames(id,:); % frames without silence
x = reshape(fr_ws',1,[]);
x=x';
% ---- remove silence
startIdx = 1;
stopIdx = samplesPerFrame;
increment = floor(0.3*samplesPerFrame);
overlapLength = samplesPerFrame - increment;

[pitch1,~] = pitch(x,fs, ...
    'WindowLength',samplesPerFrame, ...
    'OverlapLength',overlapLength);

mfcc1 = mfcc(x,fs,'WindowLength',samplesPerFrame, ...
    'OverlapLength',overlapLength, 'LogEnergy', 'Replace');
numFrames = length(pitch1);
voicing = zeros(numFrames,1);

    for i = 1: numFrames
        
        xFrame = x(startIdx:stopIdx,1); % 30ms frame

        if audiopluginexample.SpeechPitchDetector.isVoicedSpeech(xFrame,fs,... % Determining if the frame is voiced speech
                pwrThreshold,freqThreshold)
            voicing(i) = 1;
        end
        startIdx = startIdx + increment;
        stopIdx = stopIdx + increment;

    
    end
    
pitch1(voicing == 0) = nan;
mfcc1(voicing == 0,:) = nan;


end
