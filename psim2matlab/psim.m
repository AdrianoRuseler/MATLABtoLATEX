% =========================================================================
% *** PSIM INDEX file
% ***  
% ***  
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

% Test enviroment

%% Test some examples
% Example 01 
% [folder, name, ext] = fileparts(which('psim')); 

% Read simulated data
PSIMdata = psim2matlab();

% PSIMdata = rmfield(PSIMdata,'simview'); % Remove field 

% Read simview settings (*.ini) and add to PSIMdata   Time,Iabc,Ibc,Ic
PSIMdata = psimini2struct();

disp(PSIMdata.simview)
%% Downsample

% [PSIMdataDown]=psim2down(PSIMdata,3);

options.DSn=5;

lengthY = ceil(length(PSIMdata.time)/options.DSn)


[PSIMdataDown]=psim2down(PSIMdata,options);

% TeX capacity exceeded, sorry [main memory size=3000000] - como calcular
% isso????



%% Now we are ready to plot from PSIM data;

    options.Compile=1;  % Compiles the latex code
    options.ManualTips=0; % Select manually tips positions
    options.SetVar=1; % Set plot associated variables
    options.English=0; % Output in English?
    options.simviewcolor=0; % Plot with simview color settings
    options.shadesgray=0; % Plot with shades of gray
    options.PutTips=1; % Put arrow not working. why??
    options.PutLegend=1;
    options.PutYLabel=1;
    options.PutAxisLabel=1; % Puts (a), (b), ... in rigth side of each axis
    options.PutTitle=0; % Show title
    options.DSPlot=0;
    options.DSpoints=1000; % Number of points
    options.AxisType=1; % tipo de eixo utilizado
    
% psim2tikz(PSIMdata,options) 

psim2tikz(PSIMdataDown,options) 

%% Can be used with
power_fftscope

FFTSCOPEdata=power_fftscope;
SCOPEdata.time(1)

fftscope2tikz(FFTSCOPEdata)



%% Now we are ready to plot from PSIM data;

psim2tikz(PSIMdata) 


%% Read Fra from PSIM
PSIMdata = rmfield(PSIMdata,'fra'); % Remove field 


%% initexmf --edit-config-file=pdflatex
[status,cmdout] = system('initexmf --edit-config-file=pdflatex','-echo');

% This opens an editor where you can put the new values. E.g.
% 
% main_memory=50000000 
% extra_mem_bot=50000000 


[status,cmdout] = system('initexmf --dump=pdflatex','-echo');

% [status,cmdout] = system('make','-echo');




