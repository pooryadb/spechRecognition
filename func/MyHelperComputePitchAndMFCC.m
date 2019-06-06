function t = MyHelperComputePitchAndMFCC(data, info)
% HelperComputePitchAndMFCC Compute pitch and MFCC features
% This function performs the following actions 
% on the audio samples of the input file read using audio datastore 
% 1. Divide the audio into frames of size 30ms with overlap of 75%.
% 2. For each frame, determine if it contains voiced speech.
% 3. Compute pitch and 13 MFCCs.
% 4. Keep pitch and MFCC features only for voiced speech.

% The output of this function is a table containing filename, pitch, MFCCs,
% and speaker name as columns. The structure is an array because each file
% will have these values for multiple frames. NaNs indicate that the frame
% was not voiced speech.
%
% This function HelperComputePitchAndMFCC is only in support of
% SpeakerIdentificationExample. It may change in a future release.

%   Copyright 2017 The MathWorks, Inc.

%fs = 16e3;
fs = info.SampleRate;

% Compute pitch and MFCC for frames of the file

[pitch1, mfcc1] = computePitchMFCC(data,fs);

%get file name, by split the pathName
filenamesplit = regexp(info.FileName, filesep, 'split');

% Output structure
s = struct();
s.Filename = repmat({filenamesplit{end}},size(pitch1));
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
s.Label = repmat({char(info.Label)},size(pitch1));

t = struct2table(s);
end

function [pitch1, mfcc1] = computePitchMFCC(x,fs)


pwrThreshold = -50; % Frames with power below this threshold (in dB) are likely to be silence
freqThreshold = 1100; % Frames with zero crossing rate above this threshold (in Hz) are likely to be silence or unvoiced speech

% Audio data will be divided into frames of 30 ms with 75% overlap
frameTime = 25e-3;
samplesPerFrame = floor(frameTime*fs);

% ---- remove silence

% -- normalize data
x = x / abs(max(x));

% -- smooth the signal
x = sgolayfilt(x,2,9);

% -- bandpass filter
% n = 2;
% beginFreq = 500 / (fs/2);
% endFreq = 15000 / (fs/2);
% [b,a] = butter(n, [beginFreq, endFreq], 'bandpass');
% x = filter(b, a, x);
% -- bandpass filter

% --remove low amplitude using threshold
n = length(x);
n_f = floor(n/samplesPerFrame);
temp = 0;
for i = 1 : n_f
    
    frames(i,:) = x(temp + 1 : temp + samplesPerFrame);
    temp = temp + samplesPerFrame;
end

m_amp = abs(max(frames,[],2)); % find maximum of each frame
id = find(m_amp > 0.1); % finding ID of frames with max amp > x.xx
fr_ws = frames(id,:); % frames without silence
x = reshape(fr_ws',1,[]);
x=x';
% ---- remove silence -end

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
