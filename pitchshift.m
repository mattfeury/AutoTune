% Matt Feury and the Chillwavves
% Matt Feury, Leah Downey and Mike Hirth
%
% CS 4590 Georgia Institute of Technology
% 3.1.11
%
% pitchshift.m
%
% This shifts the pitch according to the note
% provided from the GUI and stores the output 

wavfile = getappdata(0, 'wavfile');     %get stored wav from GUI

[input, fs] = wavread(wavfile);         %read wav file, get sampling rate
input = input';                         %transpose the matrix
setappdata(0, 'fs', fs);                %store sampling rate

sliderValue = getappdata(0,'num');      %get stored pitch-shift numerator

scalingFactor = 2^((sliderValue) / 12); %pitch-shift factor, base two scale
frameLength = 512;                      %frame length
overlap = .75;                          %fraction of overlap
window = hanning(frameLength)';         %input window

inputLength = length(input);                                              %length of input signal
numFrames = floor((inputLength-2*frameLength)/(frameLength*(1-overlap))); %number of frames in input
jump = floor(frameLength*(1-overlap));                                    %analysis jump (non-overlap distance)
jumpShifted = floor(scalingFactor*jump);                                  %synthesis jump (scaled analysis jump)
centerFreqs = (0:(frameLength-1))*2*pi/frameLength;                       %center bin frequencies
output = zeros(1, inputLength*scalingFactor);                             %initialize output signal

stftCurr = fft(window.*input(1:frameLength));  %analyze initial frame
phaseCurr = angle(stftCurr);                   %initial frame output phase

for i=1:numFrames
    
    stftPrev = stftCurr;                                                 %previous frame's FFT
    phasePrev = phaseCurr;                                               %previous frame's output phase
    
    stftCurr = fft(window.*input(i*jump:i*jump+frameLength-1));          %fft current frame. shift to freq domain.
    phaseShift = angle(stftCurr) - angle(stftPrev) - jump*centerFreqs;   %compare phase with previous and unwrap
    phaseShiftMod = mod(phaseShift+pi, 2*pi) - pi;                       %shift domain [-pi, pi]
    
    realFreq = centerFreqs + (1/jump)*phaseShiftMod;                     %estimate real frequency
    phaseCurr = phasePrev + jumpShifted*realFreq;                        %adjust phase based on frequency
    
    stftOut = abs(stftCurr).*exp(j*phaseCurr);                           %modify FFT based on phase
    
    % shift current frame back to time domain and use it to modify original signal, 
    output(i*jumpShifted:i*jumpShifted+frameLength-1) = output(i*jumpShifted:i*jumpShifted+frameLength-1) + real(ifft(stftOut)); 
    
end

outputNorm = output./max(output);       %normalize the output amplitude
[t,d]=rat(scalingFactor);               %integer shift ratio
shifted = resample(output,d,t);         %resample for pitch shift

setappdata(0,'shifted', shifted);       %store shifted wav