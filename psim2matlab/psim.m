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

PSIMdata = rmfield(PSIMdata,'simview'); % Remove field 
% Read simview settings (*.ini) and add to PSIMdata
PSIMdata = psimini2struct();

disp(PSIMdata.simview)

%% Now we are ready to plot from PSIM data;

    options.Compile=1;  % Compiles the latex code
    options.ManualTips=1; % Select manually tips positions
    options.SetVar=1; % Set plot associated variables
    options.English=1; % Output in English?
    options.simviewcolor=0; % Plot with simview color settings
    options.shadesgray=0; % Plot with shades of gray
    options.PutTips=1; % Put arrow
    options.PutLegend=1;
    options.PutYLabel=1;
    options.PutAxisLabel=1; % Puts (a), (b), ... in rigth side of each axis
    options.DisplayTitle=1; % Show title
    options.DSPlot=1;
    options.DSpoints=500; % Number of points
    
psim2tikz(PSIMdata,options) 


%% Can be used with
power_fftscope

FFTSCOPEdata=power_fftscope

fftscope2tikz(FFTSCOPEdata)



%% Now we are ready to plot from PSIM data;

psim2tikz(PSIMdata) 




