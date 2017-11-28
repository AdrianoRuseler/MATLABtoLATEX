
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2017 AdrianoRuseler
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

%% Clear and Test enviroment
clear all
clc
status = testenviroment(); % Test if some error were encontered

%% CMD
PSIMdata.PSIMCMD.totaltime = 0.167; % Ajuste o tempo para atingir o regime permanente
PSIMdata.PSIMCMD.steptime = 1E-005; 
PSIMdata.PSIMCMD.printtime = 0;
PSIMdata.PSIMCMD.printstep = 1;
PSIMdata.PSIMCMD.infile=[dirstruct.wdir '\psim2matlab\test\ex01.psimsch'];

PSIMdata = psim2cmd(PSIMdata);


%% Test some examples
% Example 01 
% [folder, name, ext] = fileparts(which('psim')); 
clear all
clc

PSIMdata = psimfra2matlab();

% Read simulated data
PSIMdata = psim2matlab();

% PSIMdata = rmfield(PSIMdata,'simview'); % Remove field 

% Read simview settings (*.ini) and add to PSIMdata   Time,Iabc,Ibc,Ic
PSIMdata = psimini2struct();

disp(PSIMdata.simview)
%% Downsample

% [PSIMdataDown]=psim2down(PSIMdata,3);
options.DSmain=0; % Downsaple main data points

%  options.DSfunction='decimate'; % Applies a filter - Not recomended
%  options.DSn=100;

options.DSfunction='DSplot';
options.DSpoints=2500; % number of points (roughly) to display on the screen. The default is
%   50000 points (~390 kB doubles).

[PSIMdataDown]=psim2down(PSIMdata,options);

down2compare(PSIMdata,PSIMdataDown); % Compare downsample 

%% Now we are ready to plot from PSIM data;

    options.Compile=1;  % Compiles the latex code
    options.ManualTips=0; % Select manually tips positions
    options.SetVar=1; % Set plot associated variables
    options.English=0; % Output in English?
    options.simviewcolor=0; % Plot with simview color settings
    options.shadesgray=0; % Plot with shades of gray
    options.ManualTips=0;
    options.PutTips=1; % Put arrow not working. 
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




