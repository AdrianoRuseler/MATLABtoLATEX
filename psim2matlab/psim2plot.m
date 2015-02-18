% =========================================================================
%  PSIM Plot function
%  psim2plot -- Plots simview data
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


function [status]=psim2plot(PSIMdata)

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
    %% Plot figure to handle next
    % psim2plot
    
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
    
end

