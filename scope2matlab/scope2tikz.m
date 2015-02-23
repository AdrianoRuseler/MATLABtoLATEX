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


function [status]=scope2tikz(SCOPEdata,options)

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


if nargin <2 % Look for options entry
    % Options not supplied - use default  
    options.Compile=1;  % Compiles the latex code
    options.FullData=0; % Generates figure with full data set
    options.DSPlot=1; % downsampled plot
    options.ManualTips=1; % Select manually tips positions
    options.DSpoints=5000; % Data length for downsampled version
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
        assignin('base','SCOPEdata',SCOPEdata);
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

labels=lower({SCOPEdata.signals.label});
selectnames=fieldnames(wstruct.select); % what channels are selected?
csvheader='time'; % Initialize header
c=1; % Number of curves to plot

SCREENdata=(SCOPEdata.time-wstruct.horizontal.delay.time)/wstruct.horizontal.scale;


for s=1:length(selectnames) % Get with flag set to 1
    selected = eval(['wstruct.select.' selectnames{s}]);
    if isnumeric(selected)
        if selected % If is selected
            csvheader=[csvheader [', ' selectnames{s}]];
            chindex = find(not(cellfun('isempty', strfind(labels,selectnames{s})))); % Solution by Jan Simon
            % Must be checked is data exists
            if strcmp(selectnames{s},'math')
%                 xscale=wstruct.math.horizontal.scale;
                yscale = wstruct.math.vertical.scale;
                chpos = wstruct.math.vertical.position;                
            else
                yscale = eval(['wstruct.' selectnames{s} '.scale;']); 
                chpos=eval(['SCOPEdata.setstruct.' selectnames{s} '.position']);
            end
                ydata=SCOPEdata.signals(chindex).values/yscale;                
                ydata=ydata+chpos;
                SCREENdata=horzcat(SCREENdata,ydata);
                curves{c}=selectnames{s};
                c=c+1;
        end
    end
end



if options.FullData
    % Save csv file
    screenfile = [SCOPEdata.blockName '.csv'];
    fileID = fopen(screenfile,'w','n','UTF-8');
    fprintf(fileID,'%s\r\n',csvheader); % Begin axis
    fclose(fileID); % Close it.
    
    % write data
    dlmwrite (screenfile, SCREENdata, '-append','newline','pc');
end

if options.DSPlot
    % Save downsample por curve
    for p=1:length(curves)
        hl=dsplot(SCREENdata(:,1), SCREENdata(:,p+1), options.DSpoints);
        if options.ManualTips % Gets pionts from plot
            grid on
            xlim([-5 5])
            ylim([-5 5])
            [xtip,ytip] = ginput(2); % Get two points for putting tips
            tip.theta = round(angle((xtip(2)-xtip(1))+1i*(ytip(2)-ytip(1)))*180/pi);
            tip.x=xtip(1); % Tip x position
            tip.y=ytip(1); % Tip y position
            eval(['wstruct.' curves{p} '.tip=tip;']);
        end
        x=get(hl,'XData');
        y=get(hl,'YData');
        close(get(get(hl,'Parent'),'Parent'))% Closes the figure
        x=x(:); % force vector to be vertical
        y=y(:);
        
        %   datatofit{p}=y; % Get this data for future use in labels
        curveheader=['time, ' curves{p}];
        Mdata=[x y];
        screenfile = [SCOPEdata.blockName curves{p} '.csv'];
        fileID = fopen(screenfile,'w','n','UTF-8');
        fprintf(fileID,'%s\r\n',curveheader); % Begin axis
        fclose(fileID); % Close it.
        
        % write data
        dlmwrite (screenfile, Mdata, '-append','newline','pc');
    end    
end


     fileID = fopen('scopepreamble.tex','r'); % Opens preamble file
     preamble = fread(fileID); % Copy content
     fclose(fileID); % Close it.
     
     fileID = fopen('scopeinter.tex','r'); % Opens intermediary file
     intertex = fread(fileID); % Copy content
     fclose(fileID); % Close it.
     
     
     fileID = fopen('scopeend.tex','r'); % Opens ending tex file
     endtex = fread(fileID); % Copy content
     fclose(fileID); % Close it.
     
     
     

 %% Save tex file for full data version
 if options.FullData     
     fileoutID = fopen([SCOPEdata.blockName 'full.tex'],'w');
     fwrite(fileoutID,preamble);
     
     fprintf(fileoutID,'\n%s\n',['xlabel=Tempo: \SI{' num2str(wstruct.horizontal.scale*1000,'%3.2f') '}{\milli\second}/div,']);
     fprintf(fileoutID,'%s\n','] % End of axis configurations');
      fwrite(fileoutID,intertex); % Writes intermediary axis configuration
      
     screenfile = [SCOPEdata.blockName '.csv'];
     for c=1:length(curves) % Curves Loop
         fprintf(fileoutID,'\n%s\n',['% Arrows and labels for channel ' curves{c}]);
         addplotstr=['\addplot[solid,' curves{c} 'color]table[x=time,y=' curves{c} ',col sep=comma]{' screenfile '}; % Add plot data'];
         if strcmp(curves{c},'math') % If its a math channel
             chpos = num2str(wstruct.math.vertical.position);
             chunit = num2str(wstruct.math.vertical.units);
             chscale = num2str(wstruct.math.vertical.scale);
         else
             chscale=num2str(eval(['wstruct.' curves{c} '.scale']));
             chunit=eval(['wstruct.' curves{c} '.yunits']);
             chpos=num2str(eval(['wstruct.' curves{c} '.position']));
         end
         refstr=['\node[coordinate,pin={[pin distance=\refdist,pin edge={stealth-,semithick,' curves{c} 'color}]0:{}}] at (axis cs:-5,' chpos '){}; % Print ref arrow'];
         if options.ManualTips
             thetastr = num2str( eval(['wstruct.' curves{c} '.tip.theta;']));
             xtipstr = num2str( eval(['wstruct.' curves{c} '.tip.x;']));
             ytipstr = num2str( eval(['wstruct.' curves{c} '.tip.y;']));
             tipstr=['\node[coordinate,pin={[pin distance=\tipdist,pin edge={stealth-,semithick,black}]' thetastr ':{' upper(curves{c}) '}}] at (axis cs:' xtipstr ',' ytipstr '){}; % Print curve tip'];
         else
             [xtip,ytip]=data2tip(SCREENdata(:,1),SCREENdata(:,c+1),c);
             tipstr=['\node[coordinate,pin={[pin distance=\tipdist,pin edge={stealth-,semithick,black}]\tipangle' char(c+64) ':{' upper(curves{c}) '}}] at (axis cs:' num2str(xtip) ',' num2str(ytip) '){}; % Print curve tip'];
         end
         % write string on file
         fprintf(fileoutID,'%s\n',addplotstr);
         fprintf(fileoutID,'%s\n',refstr);
         fprintf(fileoutID,'%s\n',tipstr);
         
         % Legend entry
         legstr=['\addlegendentry[align=center]{\varch' char(c+64) ' @ ' upper(curves{c}) '\\ \SI{' chscale '}{\' chunit '}/div}'];
         fprintf(fileoutID,'%s\n',legstr);
     end
     
     fwrite(fileoutID,endtex);
     fclose(fileoutID);
     
 end
 
 %%    For downsample version    
 if options.DSPlot
    fileoutID = fopen([SCOPEdata.blockName '.tex'],'w');
    fwrite(fileoutID,preamble);
    
    fprintf(fileoutID,'\n%s\n',['xlabel=Tempo: \SI{' num2str(wstruct.horizontal.scale*1000,'%3.2f') '}{\milli\second}/div,']);
    fprintf(fileoutID,'%s\n','] % End of axis configurations');
    fwrite(fileoutID,intertex); % Writes intermediary axis configuration
    
    for c=1:length(curves) % Curves Loop
        fprintf(fileoutID,'\n%s\n',['% Arrows and labels for channel ' curves{c}]);
        screenfile = [SCOPEdata.blockName curves{c} '.csv'];
        addplotstr=['\addplot[solid,' curves{c} 'color]table[x=time,y=' curves{c} ',col sep=comma]{' screenfile '};'];
        
        if strcmp(curves{c},'math') % If its a math channel
             chpos = num2str(wstruct.math.vertical.position);
             chunit = num2str(wstruct.math.vertical.units);
             chscale = num2str(wstruct.math.vertical.scale);
        else
            chscale=num2str(eval(['wstruct.' curves{c} '.scale']));
            chunit=eval(['wstruct.' curves{c} '.yunits']);
            chpos=num2str(eval(['wstruct.' curves{c} '.position']));
        end
        
        refstr=['\node[coordinate,pin={[pin distance=\refdist,pin edge={stealth-,semithick,' curves{c} 'color}]0:{}}] at (axis cs:-5,' chpos '){}; % Print ref arrow'];
        if options.ManualTips
            thetastr = num2str( eval(['wstruct.' curves{c} '.tip.theta;']));
            xtipstr = num2str( eval(['wstruct.' curves{c} '.tip.x;']));
            ytipstr = num2str( eval(['wstruct.' curves{c} '.tip.y;']));
            tipstr=['\node[coordinate,pin={[pin distance=\tipdist,pin edge={stealth-,semithick,black}]' thetastr ':{' upper(curves{c}) '}}] at (axis cs:' xtipstr ',' ytipstr '){}; % Print curve tip'];
        else
            [xtip,ytip]=data2tip(SCREENdata(:,1),SCREENdata(:,c+1),c);
            tipstr=['\node[coordinate,pin={[pin distance=\tipdist,pin edge={stealth-,semithick,black}]\tipangle' char(c+64) ':{' upper(curves{c}) '}}] at (axis cs:' num2str(xtip) ',' num2str(ytip) '){}; % Print curve tip'];
        end
        % write string on file
        fprintf(fileoutID,'%s\n',addplotstr);
        fprintf(fileoutID,'%s\n',refstr);
        fprintf(fileoutID,'%s\n',tipstr);
        
        % Legend entry        
        legstr=['\addlegendentry[align=center]{\varch' char(c+64) ' @ ' upper(curves{c}) '\\ \SI{' chscale '}{\' chunit '}/div}'];        
        fprintf(fileoutID,'%s\n',legstr);
    end
    
    fwrite(fileoutID,endtex);
    fclose(fileoutID);
    
 end  
 
 %% Compile figure
 if options.Compile
     if isequal(exist(dirstruct.tikzdir,'dir'),7)
         cd(dirstruct.tikzdir)
     end
     copyfile('Makefile',dirstruct.scopestorage)
     cd(dirstruct.scopestorage)
     tic
     [status,cmdout] = system('make','-echo');
     toc
     
 end
 % Open output directory
 winopen(dirstruct.scopestorage)
 


