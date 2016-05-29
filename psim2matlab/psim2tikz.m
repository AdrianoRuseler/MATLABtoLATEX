% =========================================================================
%  PSIM Plot function
%
% =========================================================================
%
%  The MIT License (MIT)
%
%  Copyright (c) 2016 AdrianoRuseler
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

function [status]=psim2tikz(PSIMdata,options)

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
    options.ManualTips=1; % Select manually tips positions
    options.SetVar=1; % Set plot associated variables
    options.English=1; % Output in English?
    options.simviewcolor=0; % Plot with simview color settings
    options.shadesgray=0; % Plot with shades of gray
    options.ManualTips=1;
    options.PutTips=1; % Put arrow
    options.PutLegend=1;
    options.PutYLabel=1;
    options.PutAxisLabel=1; % Puts (a), (b), ... in rigth side of each axis
    options.PutTitle=1; % Show title
    options.DSPlot=0;
    options.DSpoints=500; % Number of points
    options.AxisType=1; % tipo de eixo utilizado
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
            disp('If there is no data, just return')
            status=1;
            return
        end
        
    end
end

%% All data must be available here:

if ~isfield(PSIMdata,'simview')
    disp('If there is no simview data, return with 1!')
    status=1;
    return
end

plots=fieldnames(PSIMdata.simview); % Find plots in PSIMdata


todaynow = datestr(now,'-yyyy.mm.dd-HH.MM.SS'); % Generates date string
dirname=[PSIMdata.blockName todaynow]; % Directory name where all files will be stored

%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.psimdir, dirname); % Check here
dirstruct.psimstorage = [dirstruct.psimdir '\' dirname]; %

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')
cd(dirstruct.psimstorage)


for p = 1:length(plots)
    wstruct{p}=eval(['PSIMdata.simview.' plots{p}]); % set struct to work
    %     disp(wstruct)
    
    if(wstruct{p}.main.fft) % Not implemented yet
        disp('fft -> Not implemented yet!')
        status=1;
        return
    end
    
    %% Get csv data
 
    
    xfrom = wstruct{p}.main.xfrom; % x lower limit
    xto = wstruct{p}.main.xto; % x upper limit
    
    
%     if options.DSPlot
%         Save downsample por curve
%         for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
%             DSxdata=wstruct{p}.main.xdata; %
%             for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
%                 DSydata = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data']);
% 
%                 hfig=dsplot(DSxdata, DSydata, options.DSpoints);
%                 x=get(hfig,'XData');
%                 y=get(hfig,'YData');
%                 x=x(:); % force vector to be vertical
%                 y=y(:);
%                 
%                 disp('Plot dowsampled points!!')
%                 if options.ManualTips % Gets tips points from plot
%                     if eval(['isfield(wstruct{p}.screen' num2str(s) '.curve' num2str(c) ',''tip'')'])
%                         Well, we found some tips, move on;
%                     else
%                         grid on
%                         xlim([xfrom  xto])
%                         yfrom = eval(['wstruct{p}.screen' num2str(s) '.yfrom']);
%                         yto = eval(['wstruct{p}.screen' num2str(s) '.yto']);
%                         ylim([yfrom yto])
%                         clabel = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.label']);
%                         legend(clabel)                        
%                         xlabel(wstruct{p}.main.xaxis)                        
%                         title(['Get tip location for curve ' clabel])
%                         
%                         [xtip,ytip] = ginput(2); % Get two points for putting tips                        
%                         Dxtip=xtip/(xto-xfrom); % Scales to get angle
%                         Dytip=ytip/(yto-yfrom);                       
%                         
%                         tip.theta = round(angle((Dxtip(2)-Dxtip(1))+1i*(Dytip(2)-Dytip(1)))*180/pi);
%                         tip.x=xtip(1); % Tip x position
%                         tip.y=ytip(1); % Tip y position
%                         if options.SetVar
%                             prompt = {['Enter tip String for ' clabel]};
%                             dlg_title = 'Input';
%                             num_lines = 1;
%                             def = {['$' clabel '$']};
%                             answer = inputdlg(prompt,dlg_title,num_lines,def);
%                             if isempty(answer)
%                                 tip.string=['$' clabel '$']; % enters string value
%                             else
%                                 tip.string=answer{1};
%                             end
%                         else
%                             tip.string=clabel; % enters string value
%                         end
%                         eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip=tip;']);
%                         eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip'])
%                         close(get(get(hfig,'Parent'),'Parent'))% Closes the figure
%                     end
%                 end % end of manual tips              
% 
%                 close(get(get(hfig,'Parent'),'Parent'))% Closes the figure                
%                   datatofit{p}=y; % Get this data for future use in labels
%                 csvheader=['xdata, curve' num2str(c) ];
%                 SCREENdata=[x y];
%                 csvfilename = [dirstruct.psimstorage '\' plots{p} 'DSscreen' num2str(s) 'curve' num2str(c) '.csv'];
%                 savecsvfile(SCREENdata, csvheader, csvfilename);
%             end
%         end
%     end % end of DSplot

for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
    csvheader='xdata';
    SCREENdata=wstruct{p}.main.xdata; %
    
    if options.PutYLabel
        prompt = {['Enter YLabel String for Screen: ' num2str(s)]};
        dlg_title = 'YLabel Input';
        num_lines = 1;
        def = {['$Screen_' num2str(s) '$']};
        answer = inputdlg(prompt,dlg_title,num_lines,def);
        if isempty(answer)
            YLabelstring=['$Screen_' num2str(s) '$']; % enters string value
        else
            YLabelstring=answer{1};
        end
        eval(['wstruct{p}.screen' num2str(s) '.YLabel=''' YLabelstring ''';' ]);
    end
    
    for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
        ydata = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data']);
        SCREENdata=horzcat(SCREENdata,ydata);
        csvheader=[csvheader [', curve' num2str(c)]];
        
        if options.ManualTips % Gets tips points from plot
            if eval(['isfield(wstruct{p}.screen' num2str(s) '.curve' num2str(c) ',''tip'')'])
                % Well, something can be done.
            else
                hfig=plot(wstruct{p}.main.xdata,ydata);
                grid on
                xlim([xfrom  xto])
                yfrom = eval(['wstruct{p}.screen' num2str(s) '.yfrom']);
                yto = eval(['wstruct{p}.screen' num2str(s) '.yto']);
                %                     yinc = eval(['wstruct{p}.screen' num2str(s) '.yinc']);
                ylim([yfrom yto])
                clabel = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.label']);
                legend(clabel)
                title(['Get tip location for curve ' clabel])
                [xtip,ytip] = ginput(2); % Get two points for putting tips
                Dxtip=xtip/(xto-xfrom); % Scales to get angle
                Dytip=ytip/(yto-yfrom);
                
                tip.theta = round(angle((Dxtip(2)-Dxtip(1))+1i*(Dytip(2)-Dytip(1)))*180/pi);
                
                tip.x=xtip(1); % Tip x position
                tip.y=ytip(1); % Tip y position
                if options.SetVar
                    prompt = {['Enter tip String for ' clabel]};
                    dlg_title = 'Input';
                    num_lines = 1;
                    def = {['$' clabel '$']};
                    answer = inputdlg(prompt,dlg_title,num_lines,def);
                    if isempty(answer)
                        tip.string=['$' clabel '$']; % enters string value
                    else
                        tip.string=answer{1};
                    end
                else
                    tip.string=clabel; % enters string value
                end
                eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip=tip;']);
                %                     eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip'])
                close(get(get(hfig,'Parent'),'Parent'))% Closes the figure
            end
        end % end of manual tips
    end
    
    csvfilename = [dirstruct.psimstorage '\' plots{p} 'screen' num2str(s) '.csv'];
    savecsvfile(SCREENdata, csvheader, csvfilename);
end
%
    
    
    %% Update structure     Why?????
%     eval(['PSIMdata.simview.' plots{p} '=wstruct{p};']); % set struct to work
%     assignin('base', 'PSIMdata', PSIMdata);
    
    
end





%% Load pre defined tex files
%  Create folder under tikzdir to store mat file

fileID = fopen('preamble.tex','r'); % Opens preamble file
preamble = fread(fileID); % Copy content
fclose(fileID); % Close it.

%% Save tex file
fileoutID = fopen([plots{1} '.tex'],'w');
fwrite(fileoutID,preamble);

if options.English
    xlabelstr='{Time ($\SI{}{\milli\second}$)}';
    xtickstyle='x tick label style={/pgf/number format/.cd,	scaled x ticks = false,	set decimal separator={{.}},set thousands separator={},fixed},';
    siunitxstr= '\sisetup{scientific-notation = fixed, fixed-exponent = 0, round-mode = places,round-precision = 2,output-decimal-marker = {.}}';
    ytickstyle='y tick label style={/pgf/number format/.cd,	scaled y ticks = false,	set decimal separator={{.}},set thousands separator={},fixed},';
else
    xlabelstr='{Tempo ($\SI{}{\milli\second}$)}';
    xtickstyle='x tick label style={/pgf/number format/.cd,	scaled x ticks = false,	set decimal separator={{,}},set thousands separator={},fixed},';
    siunitxstr= '\sisetup{scientific-notation = fixed, fixed-exponent = 0, round-mode = places,round-precision = 2,output-decimal-marker = {,}}';
    ytickstyle='y tick label style={/pgf/number format/.cd,	scaled y ticks = false,	set decimal separator={{,}},set thousands separator={},fixed},';
end

groupplotsrt=['\begin{groupplot}[group style={group name=simviewplots, group size= ' num2str(length(plots)) ' by ' num2str(wstruct{p}.main.numscreen) ', vertical sep=0.25cm,  horizontal sep=0.25cm}]'];
fprintf(fileoutID,'\n%s\n',groupplotsrt);


for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
    for p = 1:length(plots)  
       
%         xinc = wstruct{p}.main.xinc;
        if wstruct{p}.main.numscreen==1 % If is single plot
            fprintf(fileoutID,'\n%s\n','\nextgroupplot[height=\singleaxisheight,width=\axiswidth,grid=major,'); % Begin axis
        else
            fprintf(fileoutID,'\n%s\n','\nextgroupplot[height=\axisheight,width=\axiswidth,grid=major,'); % Begin axis
        end
        
        if options.PutTitle && isequal(s,0) % Display Title for first screen  
            prompt = {['Enter TITLE for Screen: ' num2str(s) ' at ' plots{p}]};
            answer = inputdlg(prompt,'TITLE Input',1,{plots{p}});  
            if isempty(answer)
                answer{1} ='';
            end
            fprintf(fileoutID,'%s\n',['title={' answer{1} '},']); % Write title            
        end
        
        yfrom = eval(['wstruct{p}.screen' num2str(s) '.yfrom']);
        yto = eval(['wstruct{p}.screen' num2str(s) '.yto']);
        yinc = eval(['wstruct{p}.screen' num2str(s) '.yinc']);
        fprintf(fileoutID,'%s\n',['xmin=' num2str(wstruct{p}.main.xfrom) ', xmax=' num2str(wstruct{p}.main.xto) ',']); % Write x limits
        fprintf(fileoutID,'%s\n',['ymin=' num2str(yfrom) ', ymax=' num2str(yto) ',ytick={' num2str(yfrom) ',' num2str(yfrom+yinc) ',...,' num2str(yto) '},']); % Write y limits
        
        if options.PutYLabel % Put y labels
            yLabelstr = ['{' eval(['wstruct{p}.screen' num2str(s) '.YLabel']) '}'];
        else
            yLabelstr='\empty';
        end
        
        if p>1 % Prints ytick only on fisrt column
            fprintf(fileoutID,'%s\n','yticklabels=\empty,');
        end
        
        if s<(wstruct{p}.main.numscreen-1)
            fprintf(fileoutID,'%s\n',['xticklabels=\empty,xlabel=\empty,ylabel=' yLabelstr ', xtick scale label code/.code={},ylabel absolute,% No xticks here']); % No xticks here
            fprintf(fileoutID,'%s\n',ytickstyle);
        else
            %             fprintf(fileoutID,'%s\n','xticklabel style={/pgf/number format/.cd,use comma,fixed,precision=3},'); % Last one
            fprintf(fileoutID,'%s\n',ytickstyle);
            fprintf(fileoutID,'%s\n',['xlabel=' xlabelstr ',ylabel=' yLabelstr  ',scaled x ticks=base 10:3,xtick scale label code/.code={},ylabel absolute,']); % Set 
            fprintf(fileoutID,'%s\n',xtickstyle);
        end
        %     cycle list name=linestyles*
        fprintf(fileoutID,'%s\n\n','] % End of setings for nextgroupplot'); % End of nextgroupplot configurations
        
        fprintf(fileoutID,'\n%s\n','% Settings for siunitx package');
        fprintf(fileoutID,'%s\n\n',siunitxstr);
        
        for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
            linewidth = num2str(eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.thickness']));
            if options.simviewcolor % Use simwiew colors
                ccolor = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.color']); %www.color-hex.com
                strcolor=['\definecolor{s' num2str(s) 'c' num2str(c) '}{HTML}{' dec2hex(ccolor,6) '}']; %\definecolor{s0c0}{HTML}{DF7F50}
                addplotset=['solid,line width=' linewidth 'pt,s' num2str(s) 'c' num2str(c) ]; % Define settings for addplot
                fprintf(fileoutID,'%s\n',strcolor);
            elseif options.shadesgray
                % Use shades of gray
                addplotset=['solid,line width=' linewidth 'pt,c' num2str(c) 'gray']; % Define settings for addplot
            else
                % Use colors defined in preamble tex file
                addplotset=['solid,line width=' linewidth 'pt,c' num2str(c) 'color']; % Define settings for addplot
            end
            
            if options.DSPlot
                addplotstr=['\addplot[smooth,' addplotset ']table[x=xdata,y=curve' num2str(c) ',col sep=comma]{' plots{p} 'DSscreen' num2str(s) 'curve' num2str(c) '.csv};'];   % Downsampled Version
            else
                addplotstr=['\addplot[smooth,' addplotset ']table[x=xdata,y=curve' num2str(c) ',col sep=comma]{' plots{p} 'screen' num2str(s) '.csv};'];                
            end
            fprintf(fileoutID,'%s\n',addplotstr);
            
            legendstr=['\addlegendentry{$' eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.label']) '$};'];
            
            if options.PutTips
                if eval(['isfield(wstruct{p}.screen' num2str(s) '.curve' num2str(c) ',''tip'')'])
                    thetastr = num2str( eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip.theta;']));
                    xtipstr = num2str( eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip.x;']));
                    ytipstr = num2str( eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip.y;']));
                    tipString =eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.tip.string;']);
                    tipstr=['\node[coordinate,pin={[pin distance=\tipdist,pin edge={stealth-,semithick,black}]' thetastr ':{' tipString '}}] at (axis cs:' xtipstr ',' ytipstr '){}; % Print curve tip'];
                    legendstr=['\addlegendentry{' tipString '};'];
                    fprintf(fileoutID,'%s\n',tipstr);
                end
            end
            
            if options.PutLegend
                fprintf(fileoutID,'%s\n\n',legendstr);
            end
        end
    end
end % End of loop for plots
fprintf(fileoutID,'%s\n\n','\end{groupplot} % End of group');


if options.PutAxisLabel
    % \node[right = 0.1cm of simviewplots c1r1.east] {(a)};
    for s=1:wstruct{p}.main.numscreen
        fprintf(fileoutID,'%s\n',['\node[right = 0.1cm of simviewplots c' num2str(length(plots)) 'r' num2str(s) '.east] {(' char(s+96) ')};']);
    end
end

fprintf(fileoutID,'\n%s\n','\end{tikzpicture}');
fprintf(fileoutID,'%s\n','\end{document}');
fclose(fileoutID);



%% Compile figure
if options.Compile
    if isequal(exist(dirstruct.tikzdir,'dir'),7)
        cd(dirstruct.tikzdir)
    end
    copyfile('Makefile',dirstruct.psimstorage)
    copyfile('MeCompile.cmd',dirstruct.psimstorage)
    cd(dirstruct.psimstorage)
    [status,cmdout] = system('make','-echo');
    if status
        warning('Something got wrong!!')
    else
        disp('File compliled with success!!')
    end
    
end
% Open output directory
winopen(dirstruct.psimstorage)


















