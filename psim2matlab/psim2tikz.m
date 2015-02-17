% =========================================================================
%  PSIM Plot function
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

function [status, wstruct]=psim2tikz(PSIMdata)

status=0; % We have to return something
% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
    if status
        return
    end
end


if nargin <1 % input file not supplied
    % Try to Load SCOPEdata structure    
    try
        PSIMdata = evalin('base', 'PSIMdata'); % Load SCOPEdata from base workspace
        %     disp('Load PSIMdata from base workspace')
    catch
        % Load .mat file
        if isfield(dirstruct,'psimstorage')
            if isequal(exist(dirstruct.psimstorage,'dir'),7)
                cd(dirstruct.psimstorage) % Change to directory with SCOPEdata
            end
        end
        PSIMdata=[]; % Begin with empty file
        [PSIMdataFile,PSIMdataPath] = uigetfile('*.mat','Select the PSIMdata mat file');
        if isequal(PSIMdataFile,0)
            disp('User selected Cancel')
            status=1;
            return
        end
        load([PSIMdataPath PSIMdataFile]); % Load mat file
        % Ask for SCOPEdata file
        if isempty(PSIMdata) % If there is no data, just return
            status=1;
            return
        end
        
    end
end

%% All data must be available here:

if ~isfield(PSIMdata,'simview')
    return
end

plots=fieldnames(PSIMdata.simview); % Find plots in PSIMdata

for p = 1:length(plots)
    wstruct=eval(['PSIMdata.simview.' plots{p}]); % set struct to work
    disp(wstruct)
    
    if(wstruct.main.fft) % Not implemented yet
        return
    end
    
    %      xaxis: 'Time'
    %     numscreen: 1
    %         xfrom: 0
    %           xto: 0.0167
    %         scale: 0
    %          xinc: 0.0020
    %           fft: 0
    %       default: 1
    
    % wstruct.view
    
    %   fontheight: -10
    %          bkcolor: 16777215
    %       fontweight: 0
    %             grid: 1
    %          fgcolor: 0
    %       fontitalic: 0
    %        gridcolor: 8421504
    %     hideaxistext: 0
    %
    % wstruct.screen0
    
    
    %        scale: 0
    %           yinc: 200
    %        default: 1
    %          yfrom: -400
    %     curvecount: 3
    %             db: 0
    %           auto: 0
    %            yto: 400
    %         curve0: [1x1 struct]
    %         curve1: [1x1 struct]
    %         curve2: [1x1 struct]
    
    %
    % x=wstruct.main.xdata;
    % y=wstruct.screen0.curve0.data ;
    %
    % plot(x,y)
    
    
    %% Plot figure to handle next
    
    for k = 1:wstruct.main.numscreen
        h(k) = subplot(wstruct.main.numscreen,1,k);
        eval(['wstruct.screen' num2str(k-1) '.handle=h(k);'])
    end
    
    
    xto=wstruct.main.xto;
    xfrom=wstruct.main.xfrom;
    
    
    % Plot data file and generate handles;
    for s=0:wstruct.main.numscreen-1 % Screens Loop
        axhandle = eval(['wstruct.screen' num2str(s) '.handle']);
        legString={};
        for c=0:eval(['wstruct.screen' num2str(s) '.curvecount'])-1 % Curves Loop
            ydata = eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.data']);
            curvehandle=plot(axhandle,wstruct.main.xdata,ydata);
            eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.handle=curvehandle;']);
            % Configure curves Plot
            legString{c+1} = eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.label']);
            hold(axhandle,'all')
            
        end
        
        xlim(axhandle,[xfrom,xto])
        %     [xmin xmax ymin ymax]= axis(axhandle)
        axes(axhandle)
        % Configure Axes
        yto=eval(['wstruct.screen' num2str(s) '.yto;']);
        yfrom=eval(['wstruct.screen' num2str(s) '.yfrom;']);
        ylim([yfrom,yto])
        legend(axhandle,legString);
        grid on
        hold off % reset hold state
    end
    
    xlabel(axhandle,wstruct.main.xaxis)
    for s=0:wstruct.main.numscreen-2 % Screens Loop
        axhandle = eval(['wstruct.screen' num2str(s) '.handle']);
        set(axhandle,'XTickLabel',[])
    end
    
    
    %% Get csv data
    if isequal(exist(dirstruct.psimstorage,'dir'),7)
        cd(dirstruct.psimstorage)
    end
    
    for s=0:wstruct.main.numscreen-1 % Screens Loop
        csvheader='xdata';
        SCREENdata=wstruct.main.xdata; %
        for c=0:eval(['wstruct.screen' num2str(s) '.curvecount'])-1 % Curves Loop
            ydata = eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.data']);
            SCREENdata=horzcat(SCREENdata,ydata);
            csvheader=[csvheader [', curve' num2str(c)]];
        end
        %
        screenfile = ['screen' num2str(s) '.csv'];
        fileID = fopen(screenfile,'w','n','UTF-8'); 
        fprintf(fileID,'%s\r\n',csvheader); % Begin axis
        fclose(fileID); % Close it.
        
        % write data
        dlmwrite (screenfile, SCREENdata, '-append','newline','pc');
    end
    
    
%     red, green, blue, cyan, magenta, yellow, black, gray,
% white, darkgray, lightgray, brown, lime, olive, orange, pink, purple, teal, violet.
    dec2hex(wstruct.view.bkcolor)
    
    %% Save file
    % Grava pontos por screen0.txt
    %  Create folder under tikzdir to store mat file
    
    fileID = fopen('preamble.tex','r'); % Opens preamble file
    preamble = fread(fileID); % Copy content
    fclose(fileID); % Close it.
    
    fileoutID = fopen([plots{p} '.tex'],'w');
    fwrite(fileoutID,preamble)
    
    for s=0:wstruct.main.numscreen-1 % Screens Loop
        fprintf(fileoutID,'\n%s\n','\begin{tikzpicture}');
        fprintf(fileoutID,'%s\n','\begin{axis}'); % Begin axis
        
        % [xtick={-3,-2,...,3}, ytick={-3,-2,...,3},
        % xmin=-3, xmax=3, ymin=-3, ymax=3]
        for c=0:eval(['wstruct.screen' num2str(s) '.curvecount'])-1 % Curves Loop
            ccolor = eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.color']); %www.color-hex.com
            strcolor=['\definecolor{s' num2str(s) 'c' num2str(c) '}{HTML}{' dec2hex(ccolor,6) '}']; %\definecolor{s0c0}{HTML}{DF7F50}
            str=['\addplot[solid,s' num2str(s) 'c' num2str(c) ']table[x=xdata,y=curve' num2str(c) ',col sep=comma]{screen' num2str(s) '.csv};'];
            fprintf(fileoutID,'%s\n',strcolor);
            fprintf(fileoutID,'%s\n',str);
        end
        
        fprintf(fileoutID,'%s\n','\end{axis}');
        % Close tex file
        fprintf(fileoutID,'\n\n%s\n','\end{tikzpicture}');
    end
    fprintf(fileoutID,'%s\n','\end{document}');
    
    fclose(fileoutID);
    
    
end
%% Compile figure

if isequal(exist(dirstruct.tikzdir,'dir'),7)
    cd(dirstruct.tikzdir)
end
copyfile('Makefile',dirstruct.psimstorage)
cd(dirstruct.psimstorage)
[status,cmdout] = system('make','-echo');

% Open output directory
winopen(dirstruct.psimstorage)












