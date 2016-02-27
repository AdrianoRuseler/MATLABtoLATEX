# MATLABtoLATEX
Tools to generate figures from MATLAB to LATEX

## How to begin?

Run index.m

## Import data from scope

% Load scope data points
SCOPEdata = csv2struct();

% Load settings file
SCOPEdata = set2struct();

## Use fft analysis 
fftscope.time=SCOPEdata.time-SCOPEdata.time(1); % Time starts from zero
fftscope.signals=SCOPEdata.signals; % Copy signals
fftscope.blockName=SCOPEdata.blockName; % Copy Block name

power_fftscope % Call fftscope

% After each fft calculation, run:
tmpfft=power_fftscope;
fftscope.fft(tmpfft.input)=tmpfft;

