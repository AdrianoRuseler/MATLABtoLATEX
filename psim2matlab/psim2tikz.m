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
% http://pgfplots.sourceforge.net/gallery.html
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
    status=1;
    return
end



plots=fieldnames(PSIMdata.simview); % Find plots in PSIMdata

for p = 1:length(plots)
    wstruct=eval(['PSIMdata.simview.' plots{p}]); % set struct to work
%     disp(wstruct)
    
    if(wstruct.main.fft) % Not implemented yet
        status=1;
        return
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
        screenfile = [plots{p} 'screen' num2str(s) '.csv'];
        fileID = fopen(screenfile,'w','n','UTF-8'); 
        fprintf(fileID,'%s\r\n',csvheader); % Begin axis
        fclose(fileID); % Close it.
        
        % write data
        dlmwrite (screenfile, SCREENdata, '-append','newline','pc');
    end
    
    
    %% Save tex file
    %  Create folder under tikzdir to store mat file
    
    simviewcolor=0; % Plot with simview color settings
    shadesgray=0; % Plot with shades of gray
    
    fileID = fopen('preamble.tex','r'); % Opens preamble file
    preamble = fread(fileID); % Copy content
    fclose(fileID); % Close it.
    
    fileoutID = fopen([plots{p} '.tex'],'w');
    fwrite(fileoutID,preamble);
    
    axiswidth='\linewidth'; % Set axis width
    if wstruct.main.numscreen==1
       axisheight='0.8\linewidth'; % Set axis height --  must fit on a single page
    else
       axisheight='0.4\linewidth'; % Set axis height --  must fit on a single page  
    end
    
    for s=0:wstruct.main.numscreen-1 % Screens Loop
        fprintf(fileoutID,'%s\n',['\begin{axis}[height=' axisheight ',width=' axiswidth ',grid=major,']); % Begin axis
        fprintf(fileoutID,'%s\n',['xmin=' num2str(wstruct.main.xfrom) ', xmax=' num2str(wstruct.main.xto) ',']); % Write x limits
        fprintf(fileoutID,'%s\n',['ymin=' num2str(eval(['wstruct.screen' num2str(s) '.yfrom'])) ', ymax=' num2str(eval(['wstruct.screen' num2str(s) '.yto'])) ',']); % Write y limits
        
        if s<(wstruct.main.numscreen-1)
            fprintf(fileoutID,'%s\n','xticklabels=\empty,xlabel=\empty,ylabel=\empty, % No xticks here'); % No xticks here
        else
            fprintf(fileoutID,'%s\n','xticklabel style={/pgf/number format/.cd,use comma,fixed,precision=3},');
            fprintf(fileoutID,'%s\n',['xlabel=' wstruct.main.xaxis ',']);
        end
            
        fprintf(fileoutID,'%s\n','] % End of setings for axis'); % End of axis configurations
        for c=0:eval(['wstruct.screen' num2str(s) '.curvecount'])-1 % Curves Loop
            linewidth = num2str(eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.thickness']));
            if simviewcolor % Use simwiew colors
                ccolor = eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.color']); %www.color-hex.com
                strcolor=['\definecolor{s' num2str(s) 'c' num2str(c) '}{HTML}{' dec2hex(ccolor,6) '}']; %\definecolor{s0c0}{HTML}{DF7F50}
                addplotset=['solid,line width=' linewidth 'pt,s' num2str(s) 'c' num2str(c) ]; % Define settings for addplot
                fprintf(fileoutID,'%s\n',strcolor);
            elseif shadesgray
                % Use shades of gray
                addplotset=['solid,line width=' linewidth 'pt,c' num2str(c) 'gray']; % Define settings for addplot            
            else
                % Use colors defined in preamble tex file
                addplotset=['solid,line width=' linewidth 'pt,c' num2str(c) 'color']; % Define settings for addplot
            end
            str=['\addplot[' addplotset ']table[x=xdata,y=curve' num2str(c) ',col sep=comma]{' plots{p} 'screen' num2str(s) '.csv};']; 
%             legendstr=['\addlegendentry{$' eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.label']) '$};'];
            
            fprintf(fileoutID,'%s\n',str);
%             fprintf(fileoutID,'%s\n',legendstr);
        end        
        fprintf(fileoutID,'%s\n','\end{axis}\\');        
    end
    
    fprintf(fileoutID,'%s\n','}; % End of Matrix');
    fprintf(fileoutID,'%s\n','\end{tikzpicture}');
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












