% =========================================================================
%  SCOPE Plot function
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


function [status]=scope2tikz(SCOPEdata)

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
        SCOPEdata = evalin('base', 'SCOPEdata'); % Load SCOPEdata from base workspace
        %     disp('Load PSIMdata from base workspace')
    catch
        % Load .mat file
        if isfield(dirstruct,'scopestorage')
            if isequal(exist(dirstruct.scopestorage,'dir'),7)
                cd(dirstruct.scopestorage) % Change to directory with SCOPEdata
            end
        end
        SCOPEdata=[]; % Begin with empty file
        [SCOPEdataFile,SCOPEdataPath] = uigetfile('*.mat','Select the SCOPEdata mat file');
        if isequal(SCOPEdataFile,0)
            disp('User selected Cancel')
            status=1;
            return
        end
        load([SCOPEdataPath SCOPEdataFile]); % Load mat file
        % Ask for SCOPEdata file
        if isempty(SCOPEdata) % If there is no data, just return
            status=1;
            return
        end
        
    end
end

%% All data must be available here:

if ~isfield(SCOPEdata,'setstruct')
    status=1;
    return
end

wstruct=SCOPEdata.setstruct; % set struct to work



%% Get csv data
if isequal(exist(dirstruct.scopestorage,'dir'),7)
    cd(dirstruct.scopestorage)
end

% wstruct.horizontal.recordlength
downfactor=1;
labels=lower({SCOPEdata.signals.label});
selectnames=fieldnames(wstruct.select); % what channels are selected?
csvheader='time'; % Initialize header
c=1; % Number of curves to plot

SCREENdata=SCOPEdata.time/wstruct.horizontal.scale;
for s=1:length(selectnames) % Get with flag set to 1
    selected = eval(['wstruct.select.' selectnames{s}]);
    if isnumeric(selected)
        if selected % If is selected
            csvheader=[csvheader [', ' selectnames{s}]];
            chindex = find(not(cellfun('isempty', strfind(labels,selectnames{s})))); % Solution by Jan Simon
            % Must be checked is data exists
            yscale = eval(['wstruct.' selectnames{s} '.scale;']);
            ydata=SCOPEdata.signals(chindex).values/yscale;
            SCREENdata=horzcat(SCREENdata,ydata);
            curves{c}=selectnames{s};
            c=c+1;
        end
    end
end

% Save csv file
screenfile = [SCOPEdata.blockName '.csv'];
fileID = fopen(screenfile,'w','n','UTF-8');
fprintf(fileID,'%s\r\n',csvheader); % Begin axis
fclose(fileID); % Close it.

% write data
dlmwrite (screenfile, SCREENdata, '-append','newline','pc');    



% Save downsample por curve
for p=1:length(curves)
    hl=dsplot(SCREENdata(:,1), SCREENdata(:,p+1), 5000);
    x=get(hl,'XData');
    y=get(hl,'YData');
    close(get(get(hl,'Parent'),'Parent'))% Closes the figure
    x=x(:); % force vector to be vertical
    y=y(:);
    curveheader=['time, ' curves{p}];
    Mdata=[x y];
    screenfile = [SCOPEdata.blockName curves{p} '.csv'];
    fileID = fopen(screenfile,'w','n','UTF-8');
    fprintf(fileID,'%s\r\n',curveheader); % Begin axis
    fclose(fileID); % Close it.
    
    % write data
    dlmwrite (screenfile, Mdata, '-append','newline','pc');    
end



 %% Save tex file
    % Grava pontos por screen0.txt
    %  Create folder under tikzdir to store mat file
    
    fileID = fopen('scopepreamble.tex','r'); % Opens preamble file
    preamble = fread(fileID); % Copy content
    fclose(fileID); % Close it.
    
    fileID = fopen('scopeend.tex','r'); % Opens ending tex file
    endtex = fread(fileID); % Copy content
    fclose(fileID); % Close it.
    
    
    fileoutID = fopen([SCOPEdata.blockName 'full.tex'],'w');
    fwrite(fileoutID,preamble);
    
%     fprintf(fileoutID,'\n%s\n','\begin{tikzpicture}');
%     fprintf(fileoutID,'%s\n','\begin{axis}'); % Begin axis
    screenfile = [SCOPEdata.blockName '.csv'];
    for c=1:length(curves) % Curves Loop
        str=['\addplot[solid,' curves{c} 'color]table[x=time,y=' curves{c} ',col sep=comma]{' screenfile '};'];
        fprintf(fileoutID,'%s\n',str);
    end
    
%     fprintf(fileoutID,'%s\n','\end{axis}');
    % Close tex file
%     fprintf(fileoutID,'\n\n%s\n','\end{tikzpicture}');
%     fprintf(fileoutID,'%s\n','\end{document}');

    fwrite(fileoutID,endtex);
    fclose(fileoutID);
    
    % for downsample version    
    fileoutID = fopen([SCOPEdata.blockName '.tex'],'w');
    fwrite(fileoutID,preamble);
    
%     fprintf(fileoutID,'\n%s\n','\begin{tikzpicture}');
%     fprintf(fileoutID,'%s\n','\begin{axis}'); % Begin axis
    
    for c=1:length(curves) % Curves Loop
        screenfile = [SCOPEdata.blockName curves{c} '.csv'];
        str=['\addplot[solid,' curves{c} 'color]table[x=time,y=' curves{c} ',col sep=comma]{' screenfile '};'];
        fprintf(fileoutID,'%s\n',str);
    end
    
%     fprintf(fileoutID,'%s\n','\end{axis}');
    % Close tex file
%     fprintf(fileoutID,'\n\n%s\n','\end{tikzpicture}');
%     fprintf(fileoutID,'%s\n','\end{document}');
     fwrite(fileoutID,endtex);
    fclose(fileoutID);
    
    
    
    %% Compile figure

if isequal(exist(dirstruct.tikzdir,'dir'),7)
    cd(dirstruct.tikzdir)
end
copyfile('Makefile',dirstruct.scopestorage)
cd(dirstruct.scopestorage)
tic
[status,cmdout] = system('make','-echo');
t=toc;

% Open output directory
winopen(dirstruct.scopestorage)



