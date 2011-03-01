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

[input, fs] = wavread(wavfile);         % read wav file, get sampling rate
input = input';                         % complex conjugate transpose
setappdata(0, 'fs', fs);                % store sampling rate

sliderValue = getappdata(0,'num');      % get stored pitch-shift numerator
alpha = 2^((sliderValue) / 12);         % pitch-shift factor
frameLength = 512;                      % frame length
overlap = .75;                          % overlap fraction
window = hanning(frameLength)';         % input window

inputLength = length(input);                                              % length of input signal
numFrames = floor((inputLength-2*frameLength)/(frameLength*(1-overlap))); % number of frames in input
hop = floor(frameLength*(1-overlap));                                     % analysis time hop
hopShifted = floor(alpha*hop);                                            % synthesis time hop
centerFreqs = (0:(frameLength-1))*2*pi/frameLength;                       % center bin frequencies
output = zeros(1, inputLength*alpha);                                     % output signal initialization

stftCurr = fft(window.*input(1:frameLength));  % analyze initial frame
phaseCurr = angle(stftCurr);                   % initial frame output phases

for i=1:numFrames
    stftPrev = stftCurr;                                                  % store last frame's STFT
    phasePrev = phaseCurr;                                                % store last frame's output phases
    stftCurr = fft(window.*input(i*hop:i*hop+frameLength-1));             % analyze current frame
    phaseUnwrap = angle(stftCurr) - angle(stftPrev) - hop*centerFreqs;    % unwrapped phase change
    phaseUnwrapMod = mod(phaseUnwrap+pi, 2*pi) - pi;                      % principle determination (+/- pi)
    realFreq = centerFreqs + (1/hop)*phaseUnwrapMod;                      % estimated "real" bin frequency
    phaseCurr = phasePrev + hopShifted*realFreq;                          % Phase propagation formula
    stftOut = abs(stftCurr).*exp(j*phaseCurr);                            % output STFT
    output(i*hopShifted:i*hopShifted+frameLength-1) = output(i*hopShifted:i*hopShifted+frameLength-1) + real(ifft(stftOut)); % add current frame to output
end

outputNorm = output./max(output);       % normalize the output amplitude
[t,d]=rat(alpha);                       % determine integer shift ratio
shifted = resample(output,d,t);         % resample for pitch shift

setappdata(0,'shifted', shifted);       % store shifted wav