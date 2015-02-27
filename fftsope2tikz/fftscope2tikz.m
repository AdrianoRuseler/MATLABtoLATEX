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
    options.English=0;
    options.Compile=1;
    options.PlotData=0;
    options.MagPerFund=1; % Plot relative to fundamental
    options.nplots=1; % Number of plots
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




%% Display data

disp(FFTSCOPEdata)

disp(BASEdata)


%% Polt data
if options.PlotData
    figure
    subplot(3,1,1);
    plot(FFTSCOPEdata.t,FFTSCOPEdata.Y)
    grid on
    axis tight
    
     subplot(3,1,2);
    bar(FFTSCOPEdata.freq,FFTSCOPEdata.mag)
    grid on
    axis tight
    
    subplot(3,1,3);
    bar(FFTSCOPEdata.freq,FFTSCOPEdata.phase)
    grid on
    axis tight
end

%% Find limits and extra data

ind=find(FFTSCOPEdata.freq,FFTSCOPEdata.fundamental);
indFund=ind(1);

MagFund=FFTSCOPEdata.mag(indFund);
PhaseFund=FFTSCOPEdata.phase(indFund);


fakeMag=FFTSCOPEdata.mag;
fakeMag(indFund)=0;

% indexmax = find(max(fakeMag) == fakeMag);
ymax=round(1.25*FFTSCOPEdata.mag((max(fakeMag) == fakeMag)));

FFTSCOPEdata.magPerFund=100*FFTSCOPEdata.mag/MagFund;

ymaxPer=round(125*FFTSCOPEdata.mag((max(fakeMag) == fakeMag))/MagFund);



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
csvdata=[FFTSCOPEdata.freq FFTSCOPEdata.mag FFTSCOPEdata.phase FFTSCOPEdata.magPerFund];
csvheader='freq,mag,phase,magperfund';
csvfilename=[dirstruct.fftscopestorage '\' name '.csv'];
savecsvfile(csvdata, csvheader, csvfilename); % Save to folder



%% Read predefined files

     fileID = fopen('fftpreamble.tex','r'); % Opens preamble file
     preamble = fread(fileID); % Copy content
     fclose(fileID); % Close it.    
     
     fileID = fopen('fftend.tex','r'); % Opens ending tex file
     endtex = fread(fileID); % Copy content
     fclose(fileID); % Close it.
         

     %% Write tex file
     if options.MagPerFund
         fileoutID = fopen([name 'relative.tex'],'w');
     else
         fileoutID = fopen([name '.tex'],'w');
     end
     fwrite(fileoutID,preamble);

if options.English
    xlabelstr='Frequency (Hz)';
    yMaglabel='Magnitude';
    yMagPerlabel='Magnitude (\% of the Fundamental)';
    yPhaselabel='Phase (deg)';
    siunitxstr= '\sisetup{scientific-notation = fixed, fixed-exponent = 0, round-mode = places,round-precision = 2,output-decimal-marker = {.}}';
else
    xlabelstr='Frequ\^encia (Hz)';
    yMaglabel='Magnitude';
    yMagPerlabel='Magnitude (\% da Fundamental)';
    yPhaselabel='Fase (deg)';
    siunitxstr= '\sisetup{scientific-notation = fixed, fixed-exponent = 0, round-mode = places,round-precision = 2,output-decimal-marker = {,}}';
end     
     
fprintf(fileoutID,'\n%s\n','% Settings for siunitx package');
fprintf(fileoutID,'%s\n',siunitxstr);

fprintf(fileoutID,'\n%s\n',['\begin{groupplot}[group style={group size= 1 by ' num2str(options.nplots) ', vertical sep=0.2cm,  horizontal sep=1cm},ylabel absolute,ybar,x tick label style={ /pgf/number format/1000 sep=}] ']);
fprintf(fileoutID,'%s\n','\nextgroupplot[height=\axisheight,width=\axiswidth,grid=major, enlarge y limits={upper,value=0.2},xticklabel style= {rotate=90,anchor=near xticklabel},');

if options.MagPerFund    
    fprintf(fileoutID,'%s\n',['xtick = {0,60,180,...,' num2str(FFTSCOPEdata.MaxFrequency) '},xmin=-60,ymin=0,ymax=' num2str(ymaxPer) ',']);
    fprintf(fileoutID,'%s\n',['title={Fundamental (\SI{' num2str(FFTSCOPEdata.fundamental) '}{\hertz}) = \SI{' num2str(MagFund) '}{};  THD: \SI{' num2str(FFTSCOPEdata.THD) '}{};},']);
    fprintf(fileoutID,'%s\n',['xlabel=' xlabelstr ',ylabel=' yMagPerlabel ',']);
    fprintf(fileoutID,'%s\n','] % End of axis configurations');
    
    addplotstr=['\addplot[nodes near coords,fill,c0color]table[x=freq,y=magperfund,col sep=comma]{' name '.csv}; % Add plot data'];
    fprintf(fileoutID,'%s\n',addplotstr);  
    
else
    fprintf(fileoutID,'%s\n',['xtick = {60,180,...,' num2str(FFTSCOPEdata.MaxFrequency) '},xmin=-60,ymin=0,ymax=' num2str(ymax) ',ytick = {0,5,...,' num2str(round(FFTSCOPEdata.fundamental)) '},']);
    fprintf(fileoutID,'%s\n',['title={Fundamental (\SI{' num2str(FFTSCOPEdata.fundamental) '}{\hertz}) = \SI{' num2str(MagFund) '}{};  THD: \SI{' num2str(FFTSCOPEdata.THD) '}{};},']);
    fprintf(fileoutID,'%s\n',['xlabel=' xlabelstr ',ylabel=' yMaglabel ',']);
    fprintf(fileoutID,'%s\n','] % End of axis configurations');
    
    addplotstr=['\addplot[nodes near coords,fill,c0color]table[x=freq,y=mag,col sep=comma]{' name '.csv}; % Add plot data'];
    fprintf(fileoutID,'%s\n',addplotstr);
end
    fprintf(fileoutID,'%s\n',['\addlegendentry{' BASEdata.signals(FFTSCOPEdata.input).label '};']);
    
     fwrite(fileoutID,endtex);    
     fclose(fileoutID);
     
       %% Compile figure
 if options.Compile
     if isequal(exist(dirstruct.tikzdir,'dir'),7)
         cd(dirstruct.tikzdir)
     end
     copyfile('Makefile',dirstruct.fftscopestorage)
     cd(dirstruct.fftscopestorage)
     tic
     [status,cmdout] = system('make','-echo');
     toc
     
 end
 
     
%% Opens output directory
winopen(dirstruct.fftscopestorage)
