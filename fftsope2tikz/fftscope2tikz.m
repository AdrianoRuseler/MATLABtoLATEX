% =========================================================================
% *** fftscope2tikz
% ***  
% ***  fftscope2tikz(power_fftscope)
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
    options.English=1;
    options.Compile=1;
    options.PlotData=0;
    options.MagPerFund=1; % Plot relative to fundamental
    options.SaveData=1; % Save data points in *.mat file
    options.nplots=1; % Number of plots
    options.fullxtick=0; % Display all frequencies in xtick DESABLED
    options.numdisp=0; % Display numbers above relevant bars
    options.barwidth={'1pt','5pt'};
    
    options.groupsize=[1 2]; % Defines the number of screens line x column
    options.groupplot{1,1}=[1 2 3 ]; % Associates inputs with plots
    options.groupplot{1,2}=[1 4]; 
    options.groupplotshowlabels{1,1}=[1 1 1 1]; % [ylabel xlabel yticklabel xticklabel]
    options.groupplotshowlabels{1,2}=[1 1 1 1]; % [ylabel xlabel yticklabel xticklabel]

    options.vertsep='0.2cm'; % Vertical axis separation 
    options.horisep='1cm'; % Horizontal axis separation 
    options.yshiftstr='-0.3cm'; % Vertical legend spacing
    options.enlargexlimits='abs=10';
    options.xtickselements=5; % Numbers of elements in xticks
    options.minvalue=1; % minimal value to consider in plot
end



if nargin <1 % input data not supplied
     power_fftscope
%      fftscope2tikz(power_fftscope)
     return
end


if ~isfield(FFTSCOPEdata,'fft')
    warning('Frequency analysis not found!')
    return
end


% BASEdata = evalin('base', FFTSCOPEdata.fft.structure); % Load analysed data from base workspace

FFTdata = FFTSCOPEdata.fft; % Copy FFT data from struct

todaynow = datestr(now,'-yyyy.mm.dd-HH.MM.SS'); % Generates date string

dirname=[FFTSCOPEdata.blockName todaynow]; % Directory name where all files will be stored

%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.fftscopedir, dirname); % Check here
dirstruct.fftscopestorage = [dirstruct.fftscopedir '\' dirname]; %

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')
cd(dirstruct.fftscopestorage)



%% Read predefined files

     fileID = fopen('fftpreamble.tex','r'); % Opens preamble file
     preamble = fread(fileID); % Copy content
     fclose(fileID); % Close it.    
     
     fileID = fopen('fftend.tex','r'); % Opens ending tex file
     endtex = fread(fileID); % Copy content
     fclose(fileID); % Close it.


%% Loop for plots

for f=1:length(FFTdata) % Loop for plots
    
%     FFTSCOPEdata=FFTdata(f); % Must verify if is not empty
    if ~isfield(FFTdata(f),'freq') % A simple way to check if data is present
        continue
    end
      
    %% Find limits and extra data    
    
    ind=find(FFTdata(f).freq==FFTdata(f).fundamental);
    if ind
    indFund=ind(1);
    else
        continue
    end
    
    
    freqxtick{f}=strjoin(cellstr(num2str(FFTdata(f).freq)),',');
    
    MagFund(f)=FFTdata(f).mag(indFund);
    PhaseFund(f)=FFTdata(f).phase(indFund);   
    
    fakeMag=FFTdata(f).mag;
    fakeMag(indFund)=0;
    
    % indexmax = find(max(fakeMag) == fakeMag);
    ymax(f)=round(1.25*FFTdata(f).mag((max(fakeMag) == fakeMag)));
    
    FFTdata(f).magPerFund=100*FFTdata(f).mag/MagFund(f);
    
    ymaxPer(f)=round(125*FFTdata(f).mag((max(fakeMag) == fakeMag))/MagFund(f));
    
    MaxFrequency(f)=FFTdata(f).MaxFrequency;
    Fundamental(f)=FFTdata(f).fundamental;
    
    thd(f)=FFTdata(f).THD;
    
    if ~isequal(options.minvalue,0)  %% Comform data        
       indMin=find(FFTdata(f).magPerFund >=options.minvalue); % Find elements that are greater than
       FFTdata(f).freq = FFTdata(f).freq(indMin);
       FFTdata(f).mag = FFTdata(f).mag(indMin);
       FFTdata(f).phase = FFTdata(f).phase(indMin);
       FFTdata(f).magPerFund = FFTdata(f).magPerFund(indMin);        
    end
    
    
    %% Write to folder    
    
    filename{f}=[FFTSCOPEdata.blockName FFTSCOPEdata.signals(f).label];
    % Colect data
    csvdata=[FFTdata(f).freq FFTdata(f).mag FFTdata(f).phase FFTdata(f).magPerFund];
    csvheader='freq,mag,phase,magperfund';
    csvfilename=[dirstruct.fftscopestorage '\' filename{f} '.csv'];
    savecsvfile(csvdata, csvheader, csvfilename); % Save to folder  
    
end % End of 1st loop





%% Write tex file
if options.MagPerFund
    fileoutID = fopen([dirname '_relative.tex'],'w'); % Creates file
else
    fileoutID = fopen([dirname '.tex'],'w'); % Creates file
end

fwrite(fileoutID,preamble); % Creates file
    
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


%% Select data plot mode

% All in one

% group size x - gsx
% group size y - gsy

gsx = options.groupsize(1); % Gets plot group size
gsy = options.groupsize(2);

fprintf(fileoutID,'\n%s\n\n',['\begin{groupplot}[group style={group size= ' num2str(gsx) ' by ' num2str(gsy) ', vertical sep=' options.vertsep ',  horizontal sep=' options.horisep '},ylabel absolute, ylabel style={yshift=' options.yshiftstr '}, x tick label style={ /pgf/number format/1000 sep=}] ']);

nplot=0;
for i=1:gsx
    for j=1:gsy 
        nplot=nplot+1;        
        nextgroupplotstr{1}=['\nextgroupplot[height=\axisheight,width=\axiswidth,grid=major, enlarge x limits={' options.enlargexlimits '}, enlarge y limits={upper,value=0.2}, ybar=0pt,bar width=' options.barwidth{nplot} ','];
        plotin=options.groupplot{i,j}; % Plots inputs for actual screen
        ymaxALL = max(ymax(plotin)); %Finds max from axis Y
        ymaxPerALL = max(ymaxPer(plotin)); %Finds max from axis Y
        MaxFrequencyAll=max(MaxFrequency(plotin));
        
        if all(Fundamental(plotin)==mean(Fundamental(plotin)))
            FundamentalALL=mean(Fundamental(plotin));
        else
            FundamentalALL=Fundamental(plotin(1));
        end        
      
        showflags=options.groupplotshowlabels{i,j}; % [ylabel xlabel yticklabel xticklabel]
        
        if showflags(1) % ylabel
           xylabelstr = ['ylabel=' yMagPerlabel ','];           
        else
            xylabelstr='ylabel=\empty, ';
        end       
        
        if showflags(2) % xlabel
           xylabelstr = [xylabelstr 'xlabel=' xlabelstr ','];
        else
            xylabelstr = [xylabelstr 'xlabel=\empty, '];
        end        

        if showflags(3) % yticklabel
            ytickstr= ' '; % Not implemented yet
        else
            ytickstr='yticklabel=\empty';
        end  
        
        if showflags(4) % xticklabel    options.xtickselements              
            xtickstr=['xtick ={' options.xtickselements{i,j} '}']; % Must be manual because of number size limitations
        else
            xtickstr=['xtick ={' options.xtickselements{i,j} '},xticklabel=\empty'];
        end
   
      
        if options.MagPerFund
            nextgroupplotstr{2}=['xticklabel style= {rotate=0,anchor=near xticklabel}, ' xtickstr ',ymin=0,ymax=' num2str(ymaxPerALL) ',' ytickstr ','];
        else
            nextgroupplotstr{2}=[ xtickstr ',ymin=0,ymax=' num2str(ymaxALL) ',' ytickstr ','];
        end        
        fprintf(fileoutID,'%s\n',nextgroupplotstr{1});
        fprintf(fileoutID,'%s\n',nextgroupplotstr{2});        
        
        fprintf(fileoutID,'%s\n',xylabelstr);
        fprintf(fileoutID,'%s\n\n','] % End of axis configurations');      
      
        for ind=1:length(plotin)
            titlestr=['Fundamental (\SI{' num2str(Fundamental(plotin(ind))) '}{\hertz}) = \SI{' num2str(MagFund(plotin(ind))) '}{};  THD: \SI{' num2str(thd(plotin(ind))) '}{} \%;'];
            addplotstr=['\addplot[nodes near coords,fill,c' num2str(plotin(ind)) 'color]table[x=freq,y=magperfund,col sep=comma]{' filename{plotin(ind)} '.csv}; % Add plot data'];
            fprintf(fileoutID,'%s\n',addplotstr);  
            fprintf(fileoutID,'%s\n',['\addlegendentry{' FFTSCOPEdata.signals(plotin(ind)).label ' - ' titlestr '};']);
        end    
    end
end
    
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
 
 %% Save mat data file
 
 if options.SaveData % Save data points in *.mat file
    cd(dirstruct.fftscopestorage)
    save([ FFTSCOPEdata.blockName '.mat'],'FFTSCOPEdata'); 
 end
 
     
%% Opens output directory
winopen(dirstruct.fftscopestorage)
