% Matt Feury and the Chillwavves
% Matt Feury, Leah Downey and Mike Hirth
%
% CS 4590 Georgia Institute of Technology
% 2.28.11
%
% pitchshift.m
%
% This shifts the pitch according to the note
% provided from the GUI and stores the output 

wavfile = getappdata(0, 'wavfile');     % get stored wav from GUI
input = wavread(wavfile)';              % input wav
fs = 44100;                             % sampling rate
setappdata(0, 'fs', fs);                % store sampling rate

sliderValue = getappdata(0,'num');      % get stored pitch-shift numerator
alpha = 2^((sliderValue-12) / 12);      % pitch-shift factor, 12 notes in scale
frameLength = 512;                      % frame length
overlap = .75;                          % overlap fraction
window = hanning(frameLength)';         % input window

inputLength = length(input);           % length of input signal
numFrames = floor((inputLength-2*frameLength)/(frameLength*(1-overlap)));
                                        % number of frames in input
Ra = floor(frameLength*(1-overlap));    % analysis time hop
Rs = floor(alpha*Ra);                   % synthesis time hop
Wk = (0:(frameLength-1))*2*pi/frameLength;       % center bin frequencies
output = zeros(1, inputLength*alpha);  % output signal initialization

XCurr = fft(window.*input(1:frameLength)); % analyze initial frame
phiYCurr = angle(XCurr);       % initial frame output phases

for i=1:numFrames
    XPrev = XCurr;                  % store last frame's STFT
    phiYPrev = phiYCurr;            % store last frame's output phases
    XCurr = fft(window.*input(i*Ra:i*Ra+frameLength-1)); % analyze current frame
    DPhi = angle(XCurr) - angle(XPrev) - Ra*Wk; % unwrapped phase change
    DPhip = mod(DPhi+pi, 2*pi) - pi;    % principle determination (+/- pi)
    wHat = Wk + (1/Ra)*DPhip;         % estimated "real" bin frequency
    phiYCurr = phiYPrev + Rs*wHat;     % Phase propagation formula
    Yu = abs(XCurr).*exp(j*phiYCurr);   % output STFT
    output(i*Rs:i*Rs+frameLength-1) = output(i*Rs:i*Rs+frameLength-1) + real(ifft(Yu)); % add current frame to output
end

outputNorm = output./max(output);      % normalize the output amplitude
[t,d]=rat(alpha);                       % determine integer shift ratio
shifted = resample(output,d,t);         % resample for pitch shift

setappdata(0,'shifted', shifted);       % store shifted wav