
% =========================================================================
%
%  The MIT License (MIT)
%
%  Copyright (c) 2017 AdrianoRuseler
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


%% All data must be available here:

if ~isfield(PSIMdata,'simview')
    status=1;
    return
end

%% PLOT

PSIMdata.simview.main.hfig=figure; % Create fig handle
title(PSIMdata.blockName,'Interpreter','latex')
xscale=1;

xdata=PSIMdata.simview.main.xdata*xscale;

for s=0:PSIMdata.simview.main.numscreen-1
    haxes(s+1) = subplot(PSIMdata.simview.main.numscreen,1,s+1); % Gera subplot
    hold(haxes(s+1),'all')
    grid on
%     eval(['PSIMdata.simview.screen' num2str(s) '.handle=haxes;']) % atribue handle
    legString={};
    for c=0:eval(['PSIMdata.simview.screen' num2str(s) '.curvecount'])-1 % Curves Loop
        ydata = eval(['PSIMdata.simview.screen' num2str(s) '.curve' num2str(c) '.data']);
        legString{c+1} = eval(['PSIMdata.simview.screen' num2str(s) '.curve' num2str(c) '.label']);
        plot(haxes(s+1),xdata,ydata)        
    end
    %     axis tight    
     xlim(haxes(s+1),[PSIMdata.simview.main.xfrom PSIMdata.simview.main.xto]*xscale);
         legend(haxes(s+1),legString,'Interpreter','latex');    
    if s<PSIMdata.simview.main.numscreen-1
        set(haxes(s+1),'XTickLabel',[])
%         title(['RA: ' num2str(conv.RA)],'Interpreter','latex')
    end
end

linkaxes(haxes,'x') % Linka eixos x

xlabel('Tempo (s)','Interpreter','latex')

% bottom=[0.11 0.55 ];
% [left bottom width height]

ns=PSIMdata.simview.main.numscreen;
for a=1:ns
%     get(haxes(a),'Position')
%    set(haxes(a),'Position',[0.15 0.11 0.75 0.8/ns]);
end
%% Caso com 1
% 0.1300    0.1100    0.7750    0.8

%% Caso com dois
%    0.15    0.5838    0.75   0.3412
%    0.15    0.1100    0.75   0.3412

%% Caso com 3 gráficos
% 0.1300    0.7093    0.75    0.2157
% 0.1300    0.4096    0.75    0.2157
% 0.1300    0.1100    0.75    0.2157

 %% Caso com 4
%     0.15    0.7673    0.75    0.1577
%     0.15    0.5482    0.75    0.1577
%     0.15    0.3291    0.75    0.1577
%     0.15    0.1100    0.75    0.1577
    
    

%%  OLD
% PSIMdata.simview.main.numscreen
% 
% plots=fieldnames(PSIMdata.simview); % Find plots in PSIMdata
% 
% for p = 1:length(plots)
%     wstruct=eval(['PSIMdata.simview.' plots{p}]); % set struct to work
%     %% Plot figure to handle next
%     % psim2plot
%     
%     for k = 1:wstruct.main.numscreen
%         h(k) = subplot(wstruct.main.numscreen,1,k);
%         eval(['wstruct.screen' num2str(k-1) '.handle=h(k);'])
%     end
%     
%     xto=wstruct.main.xto;
%     xfrom=wstruct.main.xfrom;
%     
%     
%     % Plot data file and generate handles;
%     for s=0:wstruct.main.numscreen-1 % Screens Loop
%         axhandle = eval(['wstruct.screen' num2str(s) '.handle']);
%         legString={};
%         for c=0:eval(['wstruct.screen' num2str(s) '.curvecount'])-1 % Curves Loop
%             ydata = eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.data']);
%             curvehandle=plot(axhandle,wstruct.main.xdata,ydata);
%             eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.handle=curvehandle;']);
%             % Configure curves Plot
%             legString{c+1} = eval(['wstruct.screen' num2str(s) '.curve' num2str(c) '.label']);
%             hold(axhandle,'all')
%             
%         end
%         
%         xlim(axhandle,[xfrom,xto])
%         %     [xmin xmax ymin ymax]= axis(axhandle)
%         axes(axhandle)
%         % Configure Axes
%         yto=eval(['wstruct.screen' num2str(s) '.yto;']);
%         yfrom=eval(['wstruct.screen' num2str(s) '.yfrom;']);
%         ylim([yfrom,yto])
%         legend(axhandle,legString);
%         grid on
%         hold off % reset hold state
%     end
%     
%     xlabel(axhandle,wstruct.main.xaxis)
%     for s=0:wstruct.main.numscreen-2 % Screens Loop
%         axhandle = eval(['wstruct.screen' num2str(s) '.handle']);
%         set(axhandle,'XTickLabel',[])
%     end
%     
% end

