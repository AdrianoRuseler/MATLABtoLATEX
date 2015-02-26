% =========================================================================
% *** bode2tikz
% ***  

% *** bode2tikz(gcf)
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
end

if nargin <1 % input data not supplied
     hbode=gcf;
     return
end






axesObjs = findobj(hbode,'Type','Axes');  %axes handles

for i=1:length(axesObjs)
    if ~isempty(strfind(axesObjs(i).YLabel.String,'Phase')) % Find Phase axes
        PhaseAxes=axesObjs(i);
    elseif ~isempty(strfind(axesObjs(i).YLabel.String,'Magnitude'))% Find Mag axes
        MagAxes=axesObjs(i);
    end
end

PhaselinesObjs = findobj(PhaseAxes,'Type','line','Visible','on'); % Find visible lines
MaglinesObjs = findobj(MagAxes,'Type','line','Visible','on'); % Find visible lines

if length(PhaselinesObjs)>1
    warning('One bode plot only!')
    return
end


PhasexData=get(PhaselinesObjs,'Xdata');
PhaseyData=get(PhaselinesObjs,'Ydata');

MagxData=get(MaglinesObjs,'Xdata');
MagyData=get(MaglinesObjs,'Ydata');

xMPlim = get(MagAxes,'Xlim');
yMlim = get(MagAxes,'Ylim');
yPlim = get(PhaseAxes,'Ylim');
% 
% figure
% subplot(2,1,1);
% semilogx(MagxData,MagyData)
% grid on
% xlim(get(MagAxes,'Xlim'))
% ylim(get(MagAxes,'Ylim'))
% 
% subplot(2,1,2);
% semilogx(PhasexData,PhaseyData)
% grid on
% xlim(get(PhaseAxes,'Xlim'))
% ylim(get(PhaseAxes,'Ylim'))
% 
% 


name='bode';

%  Create folder under bodedir to store files
[s,mess,messid] = mkdir(dirstruct.bodedir, name); % Check here
dirstruct.bodedirstorage = [dirstruct.bodedir '\' name]; %

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')
cd(dirstruct.bodedirstorage)

% Colect data
csvdata=[PhasexData(:) MagyData(:) PhaseyData(:)];
csvheader='freq,mag,phase';
csvfilename=[dirstruct.bodedirstorage '\' name '.csv'];
savecsvfile(csvdata, csvheader, csvfilename); % Save to folder

bodefile=[name '.csv'];


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
     fprintf(fileoutID,'%s\n','minor tick num=5,xtickten = {0,...,10},xminorgrids=true,xticklabels=\empty,xlabel=\empty,');
     
     fprintf(fileoutID,'%s\n',['xmin=' num2str(xMPlim(1)) ',xmax=' num2str(xMPlim(2)) ',ymin='  num2str(yMlim(1)) ',ymax=' num2str(yMlim(2)) ',ylabel=' yMaglabel ',']);
     fprintf(fileoutID,'%s\n','] % End of axis configurations');
     
     fprintf(fileoutID,'\n%s\n','% Settings for siunitx package');
     fprintf(fileoutID,'%s\n',siunitxstr);
     
     addplotstr=['\addplot[solid,line width=1pt,c0color]table[x=freq,y=mag,col sep=comma]{' bodefile '}; % Add plot data'];
     fprintf(fileoutID,'%s\n',addplotstr);
     
     fprintf(fileoutID,'%s\n','\addlegendentry{Mag};');
     
      
       
      
     
     fprintf(fileoutID,'\n%s\n','\nextgroupplot[xmode=log,ymode=normal,height=\axisheight,width=\axiswidth,grid=major,');
     fprintf(fileoutID,'%s\n',['minor tick num=5,xtickten = {0,...,10},xminorgrids=true,xlabel=' xlabelstr ',']);
     
     fprintf(fileoutID,'%s\n',['xmin=' num2str(xMPlim(1)) ',xmax=' num2str(xMPlim(2)) ',ymin='  num2str(yPlim(1)) ',ymax=' num2str(yPlim(2)) ',ylabel=' yPhaselabel ',']);
     fprintf(fileoutID,'%s\n','] % End of axis configurations');
     
     fprintf(fileoutID,'\n%s\n','% Settings for siunitx package');
     fprintf(fileoutID,'%s\n',siunitxstr);
     
     addplotstr=['\addplot[solid,line width=1pt,c0color]table[x=freq,y=phase,col sep=comma]{' bodefile '}; % Add plot data'];
     fprintf(fileoutID,'%s\n',addplotstr);
     
     fprintf(fileoutID,'%s\n','\addlegendentry{Phase};');
     
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
 
 
 
     
     
