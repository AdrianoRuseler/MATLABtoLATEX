% =========================================================================
% *** bode2tikz
% ***  

% *** bode2tikz(gcf)
% =========================================================================

function bode2tikz(hbode,options)


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
end

if nargin <1 % input data not supplied
    if isempty(get(groot,'CurrentFigure'))
        % There is no current figure
        return
    end
    hbode=gcf;    
end


%% Prepare folder
name='bode';

%  Create folder under bodedir to store files
[s,mess,messid] = mkdir(dirstruct.bodedir, name); % Check here
dirstruct.bodedirstorage = [dirstruct.bodedir '\' name]; %

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')
cd(dirstruct.bodedirstorage)

%% Get handles
axesObjs = findobj(hbode,'Type','Axes');  %axes handles

if length(axesObjs)>2
    warning('Just two axes per figure for now!')
    return
end

for i=1:length(axesObjs)
    if ~isempty(strfind(axesObjs(i).YLabel.String,'Phase')) % Find Phase axes
        PhaseAxes=axesObjs(i);
    elseif ~isempty(strfind(axesObjs(i).YLabel.String,'Magnitude'))% Find Mag axes
        MagAxes=axesObjs(i);
    end
end

PhaselinesObjs = findobj(PhaseAxes,'Type','line','Visible','on'); % Find visible lines
MaglinesObjs = findobj(MagAxes,'Type','line','Visible','on'); % Find visible lines

hLegendEntry = legend('show'); % Displays legend and gets handle
LegendStr=hLegendEntry.String; % Wrong order




%% Get axes data

xMPlim = get(MagAxes,'Xlim');
yMlim = get(MagAxes,'Ylim');
yPlim = get(PhaseAxes,'Ylim');


MagYTick = get(MagAxes,'YTick');
MagYTickLabel = get(MagAxes,'YTickLabel');
MagYTickstr=['{' strjoin(cellstr(num2str(MagYTick(:))),',') '}'];
MagYTickLabelstr=['{$' strjoin(MagYTickLabel,'$, $') '$}'];

PhaseYTick = get(PhaseAxes,'YTick');
PhaseYTickLabel = get(PhaseAxes,'YTickLabel');
PhaseYTickstr=['{' strjoin(cellstr(num2str(PhaseYTick(:))),',') '}'];
PhaseYTickLabelstr=['{$' strjoin(PhaseYTickLabel,'$, $') '$}'];

PhaseXTick = get(PhaseAxes,'XTick'); 
PhaseXTickLabel = get(PhaseAxes,'XTickLabel');

PhaseXTick=['{' strjoin(cellstr(num2str(PhaseXTick(:))),',') '}'];
PhaseXTickLabelstr=['{$' strjoin(PhaseXTickLabel,'$, $') '$}'];


%% Get plot data

Pcurves=length(PhaselinesObjs);
Mcurves=length(MaglinesObjs);

if ~isequal(Pcurves,Mcurves)
    warning('Magnitude and Phase have diferent number os lines!')
    return
end


for c=1:Pcurves
    tempdata =  get(PhaselinesObjs(c),'Xdata');
    PhasexData{c}=tempdata(:);
    endofxdata{c}=tempdata(end);
    
    tempdata=get(PhaselinesObjs(c),'Ydata');
    PhaseyData{c}=tempdata(:);
    
    tempdata=get(MaglinesObjs(c),'Xdata')';
    MagxData{c}=tempdata(:);
    tempdata=get(MaglinesObjs(c),'Ydata')';
    MagyData{c}=tempdata(:);    
    
end



%% Plot figure
if options.PlotData
    figure
    subplot(2,1,1);
    for c=1:Pcurves
        semilogx(MagxData{c},MagyData{c})
        hold all
    end
    grid on
    xlim(get(MagAxes,'Xlim'))
    ylim(get(MagAxes,'Ylim'))
    
    subplot(2,1,2);
    for c=1:Pcurves
        semilogx(PhasexData{c},PhaseyData{c})
        hold all
    end
    grid on
    xlim(get(PhaseAxes,'Xlim'))
    ylim(get(PhaseAxes,'Ylim'))    
end

%% Colect data
for c=1:Pcurves
    csvdata=[PhasexData{c} MagyData{c} PhaseyData{c}];
    csvheader='freq,mag,phase';
    csvfilename{c}=[dirstruct.bodedirstorage '\' name  LegendStr{c} '.csv'];
    savecsvfile(csvdata, csvheader, csvfilename{c}); % Save to folder
    
    bodefile{c}=[name  LegendStr{c} '.csv'];
end

%% Read predefined files

     fileID = fopen('bodepreamble.tex','r'); % Opens preamble file
     preamble = fread(fileID); % Copy content
     fclose(fileID); % Close it.
     
    
     
     fileID = fopen('bodeend.tex','r'); % Opens ending tex file
     endtex = fread(fileID); % Copy content
     fclose(fileID); % Close it.
         

%% Write tex file

fileoutID = fopen([name '.tex'],'w');
fwrite(fileoutID,preamble);

if options.English
    xlabelstr='Frequency (rad/s)';
    yMaglabel='Magnitude (dB)';
    yPhaselabel='Phase (deg)';
    siunitxstr= '\sisetup{scientific-notation = fixed, fixed-exponent = 0, round-mode = places,round-precision = 2,output-decimal-marker = {.}}';
else
    xlabelstr='Frequ\^encia (rad/s)';
    yMaglabel='Magnitude (dB)';
    yPhaselabel='Fase (deg)';
    siunitxstr= '\sisetup{scientific-notation = fixed, fixed-exponent = 0, round-mode = places,round-precision = 2,output-decimal-marker = {,}}';
end


fprintf(fileoutID,'\n%s\n','\nextgroupplot[xmode=log,ymode=normal,height=\axisheight,width=\axiswidth,grid=major,');
fprintf(fileoutID,'%s\n','minor tick num=5,xtickten = {-10,...,10},xminorgrids=true,xticklabels=\empty,xlabel=\empty,');

fprintf(fileoutID,'%s\n',['yticklabel style={/pgf/number format/fixed},ytick=' MagYTickstr ',yticklabels=' MagYTickLabelstr ',']);
fprintf(fileoutID,'%s\n',['xmin=' num2str(xMPlim(1)) ',xmax=' num2str(xMPlim(2)) ',ymin='  num2str(yMlim(1)) ',ymax=' num2str(yMlim(2)) ',ylabel=' yMaglabel ',']);
fprintf(fileoutID,'%s\n','] % End of axis configurations');

fprintf(fileoutID,'\n%s\n','% Settings for siunitx package');
fprintf(fileoutID,'%s\n',siunitxstr);

for c=1:Pcurves
    addplotstr=['\addplot[solid,thick,c' num2str(c) 'color]table[x=freq,y=mag,col sep=comma]{' bodefile{c} '}; % Add plot data'];
    fprintf(fileoutID,'%s\n',addplotstr);
    fprintf(fileoutID,'%s\n',['\addlegendentry{' LegendStr{c} '};']);
    fprintf(fileoutID,'%s\n',['\draw[thick] (' num2str(endofxdata{c}) ',' num2str(yMlim(1)) ') -- (' num2str(endofxdata{c}) ',' num2str(yMlim(2)) '); % draw end of data line']);
end



fprintf(fileoutID,'\n%s\n','\nextgroupplot[xmode=log,ymode=normal,height=\axisheight,width=\axiswidth,grid=major,');
fprintf(fileoutID,'%s\n',['minor tick num=5,xtickten = {-10,...,10},xminorgrids=true,xlabel=' xlabelstr ',']);
fprintf(fileoutID,'%s\n',['yticklabel style={/pgf/number format/fixed},ytick=' PhaseYTickstr ',yticklabels=' PhaseYTickLabelstr ',']);
fprintf(fileoutID,'%s\n',['xmin=' num2str(xMPlim(1)) ',xmax=' num2str(xMPlim(2)) ',ymin='  num2str(yPlim(1)) ',ymax=' num2str(yPlim(2)) ',ylabel=' yPhaselabel ',']);
fprintf(fileoutID,'%s\n','] % End of axis configurations');

fprintf(fileoutID,'\n%s\n','% Settings for siunitx package');
fprintf(fileoutID,'%s\n',siunitxstr);

for c=1:Pcurves
    addplotstr=['\addplot[solid,thick,c' num2str(c) 'color]table[x=freq,y=phase,col sep=comma]{' bodefile{c} '}; % Add plot data'];
    fprintf(fileoutID,'%s\n',addplotstr);
    fprintf(fileoutID,'%s\n',['\addlegendentry{' LegendStr{c} '};']);
    fprintf(fileoutID,'%s\n',['\draw[thick] (' num2str(endofxdata{c}) ',' num2str(yPlim(1)) ') -- (' num2str(endofxdata{c}) ',' num2str(yPlim(2)) '); % draw end of data line']);
end

     
     fwrite(fileoutID,endtex);    
     fclose(fileoutID);
     
     
     
      %% Compile figure
 if options.Compile
     if isequal(exist(dirstruct.tikzdir,'dir'),7)
         cd(dirstruct.tikzdir)
     end
     copyfile('Makefile',dirstruct.bodedirstorage)
     cd(dirstruct.bodedirstorage)
     tic
     [status,cmdout] = system('make','-echo');
     toc
     
 end
 
  
 %% Open output directory
 winopen(dirstruct.bodedirstorage)
 
     
     
