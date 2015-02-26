% =========================================================================
% *** fftscope2tikz
% ***  
% ***  fftscope2tikz(power_fftscope)
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2015 AdrianoRuseler
% *** 
% *** Permission is hereby granted, free of charge, to any person obtaining a copy
% *** of this software and associated documentation files (the "Software"), to deal
% *** in the Software without restriction, including without limitation the rights
% *** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% *** copies of the Software, and to permit persons to whom the Software is
% *** furnished to do so, subject to the following conditions:
% *** 
% *** The above copyright notice and this permission notice shall be included in all
% *** copies or substantial portions of the Software.
% *** 
% *** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% *** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% *** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% *** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% *** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% *** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% *** SOFTWARE.
% ***
% =========================================================================
%  FFTSCOPEdata =  power_fftscope
function fftscope2tikz(FFTSCOPEdata,options)
clc
% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if nargin <2 % input options not supplied
    options=[]; % Some options here
end

if nargin <1 % input data not supplied
     power_fftscope
     fftscope2tikz(power_fftscope)
     return
end

if ~isfield(FFTSCOPEdata,'freq')
    warning('Frequency analysis not found!')
    return
end

BASEdata = evalin('base', FFTSCOPEdata.structure); % Load analysed data from base workspace

%% Write folder

name=[FFTSCOPEdata.structure BASEdata.blockName BASEdata.signals(FFTSCOPEdata.input).label];
%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.fftscopedir, name); % Check here
dirstruct.fftscopestorage = [dirstruct.fftscopedir '\' name]; %

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')
cd(dirstruct.fftscopestorage)

% Colect data
csvdata=[FFTSCOPEdata.freq FFTSCOPEdata.mag FFTSCOPEdata.phase];
csvheader='freq,mag,phase';
csvfilename=[dirstruct.fftscopestorage '\' name '.csv'];
savecsvfile(csvdata, csvheader, csvfilename); % Save to folder

%%



winopen(dirstruct.fftscopestorage)


disp(FFTSCOPEdata)

disp(BASEdata)


figure
plot(FFTSCOPEdata.t,FFTSCOPEdata.Y)
grid on
axis tight

figure
bar(FFTSCOPEdata.freq,FFTSCOPEdata.mag)
grid on
axis tight

figure
bar(FFTSCOPEdata.freq,FFTSCOPEdata.phase)
grid on
axis tight
