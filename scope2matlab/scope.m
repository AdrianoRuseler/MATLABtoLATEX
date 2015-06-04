% =========================================================================
%  SCOPE INDEX file
%   
%   
% =========================================================================
% 
%  The MIT License (MIT)
%  
%  Copyright (c) 2015 AdrianoRuseler
%  
%  Permission is hereby granted, free of charge, to any person obtaining a copy
%  of this software and associated documentation files (the Software), to deal
%  in the Software without restriction, including without limitation the rights
%  to use, copy, modify, merge, publish, distribute, sublicense, andor sell
%  copies of the Software, and to permit persons to whom the Software is
%  furnished to do so, subject to the following conditions
%  
%  The above copyright notice and this permission notice shall be included in all
%  copies or substantial portions of the Software.
%  
%  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%  SOFTWARE.
% 
% =========================================================================

clear all

%% Load scope data points

SCOPEdata = csv2struct();


%% Load settings file

SCOPEdata = set2struct();


%% Load all at once
 clear all
 [status, dirstruct]= checkdirstruct(); % Well, check this out
 
 if isfield(dirstruct,'aquisitiondir')
     if isequal(exist(dirstruct.aquisitiondir,'dir'),7)
         cd(dirstruct.aquisitiondir) % Change to directory with SCOPEdata
     end
 end
  
  [csvfilename, csvpathname] = uigetfile('*.csv', 'Select scope data aquisition', 'MultiSelect', 'off');
    if isequal(csvfilename,0)
        disp('User selected Cancel')
        return
    end

 SCOPEcsv=[csvpathname csvfilename];
[pathstr, name, ext] = fileparts(SCOPEcsv);

SCOPEdata = csv2struct([pathstr '\' name '.csv']);
SCOPEdata = set2struct([pathstr '\' name '.set']);

    options.Compile=1;  % Compiles the latex code
    options.FullData=1; % Generates figure with full data set
    options.DSPlot=1; % downsampled plot
    options.ManualTips=1; % Select manually tips positions
    options.SetVar=1; % Set channels associated variables
    options.DSpoints=5000; % Data length for downsampled version
    options.English=1; % Output in English?
    
    % Remove CH4 for example    
    SCOPEdata.setstruct.select.ch4=0;

scope2tikz(SCOPEdata)

%% Plot scope data to tikz

scope2tikz(SCOPEdata)

scope2tikz()

%% Can be used with

fftscope.time=SCOPEdata.time-SCOPEdata.time(1); % Time starts from zero
fftscope.signals=SCOPEdata.signals; % Copy signals
fftscope.blockName=SCOPEdata.blockName; % Copy Block name



% SCOPEdata.time=SCOPEdata.time-SCOPEdata.time(1); % correct time
power_fftscope % Call fftscope

tmpfft=power_fftscope;
fftscope.fft(tmpfft.input)=tmpfft;



%%
    options.English=1;
    options.Compile=1;
    options.PlotData=0;
    options.MagPerFund=1; % Plot relative to fundamental
    options.nplots=1; % Number of plots
    options.fullxtick=0; % Display all frequencies in xtick DESABLED
    options.numdisp=0; % Display numbers above relevant bars
    options.barwidth={'2pt','5pt'};
    
    options.groupsize=[2 1]; % Defines the number of screens  

    options.groupplot{1,1}=[1 2 3]; % Associates inputs with plots
    options.groupplot{2,1}=[4]; 
    options.groupplotshowlabels{1,1}=[1 1 1 1]; % [ylabel xlabel yticklabel xticklabel]
    options.groupplotshowlabels{2,1}=[0 1 1 1]; % [ylabel xlabel yticklabel xticklabel]
    options.vertsep='0.2cm'; % Vertical axis separation 
    options.horisep='0.5cm'; % Horizontal axis separation
    options.enlargexlimits='abs=15';
    
fftscope2tikz(fftscope,options)

%%

FFTSCOPEdata=fftscope



FFTSCOPEdataCH1=power_fftscope;


FFTSCOPEdataCH2=power_fftscope;
FFTSCOPEdataCH3=power_fftscope;
FFTSCOPEdataCH4=power_fftscope;

fftscope2tikz(FFTSCOPEdataCH1)
fftscope2tikz(FFTSCOPEdataCH2)
fftscope2tikz(FFTSCOPEdataCH3)
fftscope2tikz(FFTSCOPEdataCH4)





%% Set options





    % Options not supplied - use default
    options.Title.String='';
    options.Title.FontSize=9.5;
    options.Title.FontType='';
    options.Title.Color='';
    
    options.XLabel.String='';
    options.XLabel.FontSize=9.5;
    options.XLabel.FontType='';
    options.XLabel.Color='';

    options.YLabel.String='';
    options.YLabel.FontSize=9.5;
    options.YLabel.FontType='';
    options.YLabel.Color='';
    
    options.XLabel=1;
    
    options.Compile=1;  % Compiles the latex code
    options.FullData=1; % Generates figure with full data set
    options.DSPlot=1; % downsampled plot
    options.English=0; % Output in English?
    options.ManualTips=0; % 
    options.DSpoints=5000;

    scope2tikz(SCOPEdata,options)


    
    

