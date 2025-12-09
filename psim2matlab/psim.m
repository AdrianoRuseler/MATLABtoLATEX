
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

%% Leitura de dados
PSIMdata = simview2matlab(PSIMdata);
[status]=psim2plot(PSIMdata);

%% Frequency response

PSIMdata.PSIMCMD.totaltime = 0.05; % Ajuste o tempo para atingir o regime permanente
PSIMdata.PSIMCMD.steptime = 1E-006; 
PSIMdata.PSIMCMD.printtime = 0;
PSIMdata.PSIMCMD.printstep = 1;
PSIMdata.PSIMCMD.infile=[dirstruct.wdir '\psim2matlab\test\BuckACSweep.psimsch'];
PSIMdata = psim2cmd(PSIMdata);

% PSIMdata = psimfra2matlab(PSIMdata);
%%
PSIMdata.fra.freq

np = 2;
nz = 1;
iodelay = NaN;
sysC0 = tfest(vC0,np,nz);
sysiL0 = tfest(iL0,np,nz);

figure
bode(vC0,sysC0);
 
figure
bode(iL0,sysiL0);   
    
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




