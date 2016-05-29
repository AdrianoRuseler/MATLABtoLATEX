
% =========================================================================
%  PSIM data downsample using Decimate MATLAB function
%
%
% =========================================================================
%
%  The MIT License (MIT)
%
%  Copyright (c) 2016 Adriano Ruseler
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
% =========================================================================

function [PSIMdataDown]=psim2down(PSIMdata,options)

nsignals=length(PSIMdata.signals); % Find plots in PSIMdata

PSIMdataDown=PSIMdata; % Just copy

% PSIMdataDown.time = downsample(PSIMdata.time,options.DSn);

% for s=1:nsignals    
%  PSIMdataDown.signals(s).values = downsample(PSIMdata.signals(s).values,options.DSn); 
% end



%% Decimate

% y = decimate(x,r) reduces the sampling rate of x, the input signal, by a factor of r. The decimated vector, y, is shortened by a factor of r so that length(y) = ceil(length(x)/r). By default, decimate uses a lowpass Chebyshev Type I IIR filter of order 8.
% example
% y = decimate(x,r,n) uses a Chebyshev filter of order n. Orders above 13 are not recommended because of numerical instability. The function displays a warning in those cases.
% y = decimate(x,r,'fir') uses an FIR filter designed using the window method with a Hamming window. The filter has order 30.
% example
% y = decimate(x,r,n,'fir') uses an FIR filter of order n.

if options.DSmain
    % options.DSn=100;
    t=double(PSIMdataDown.time);
    PSIMdataDown.time = single(decimate(t,options.DSn));
    
    % length(y) = ceil(length(x)/r)
    
    
    % t=double(PSIMdata.time);
    % PSIMdataDown.time=single(t(1:options.DSn:length(t)));
    
    for s=1:nsignals
        PSIMdataDown.signals(s).values = decimate(double(PSIMdataDown.signals(s).values),options.DSn);
        PSIMdataDown.signals(s).values=single(PSIMdataDown.signals(s).values);
    end    
end
%% Decimate simview data points.

if ~isfield(PSIMdataDown,'simview')
    disp('If there is no simview data, return with 1!')
    status=1;
    return
end

plots=fieldnames(PSIMdataDown.simview); % Find plots in PSIMdata

for p = 1:length(plots)
    wstruct{p}=eval(['PSIMdataDown.simview.' plots{p}]); % set struct to work
    
    %          xfrom = wstruct{p}.main.xfrom; % x lower limit
    %     xto = wstruct{p}.main.xto; % x upper limit
    switch options.DSfunction % Select function
        case 'decimate' % Waiting for code implementation
            wstruct{p}.main.xdata=single(decimate(double(wstruct{p}.main.xdata),options.DSn)); %
            % Atualizar limites do eixo x
            wstruct{p}.main.xfrom=wstruct{p}.main.xdata(1); % x lower limit
            wstruct{p}.main.xto=wstruct{p}.main.xdata(end); % x upper limit
            for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
                for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
                    ydata = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data']);
                    ydata=single(decimate(double(ydata),options.DSn));
                    eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data=ydata;'])
                end
            end
            eval(['PSIMdataDown.simview.' plots{p} '=wstruct{p};']); % update struct
            
            
            %     options.DSfunction='matlab-plot-big';
        case 'matlab-plot-big'      % Gets stuck
%             for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
%                 for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
%                     ydata = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data']);
%                     %                     ydata=single(decimate(double(ydata),options.DSn));
%                     figure
%                     hR=reduce_plot(wstruct{p}.main.xdata,ydata)
%                     xdataR=get(hR,'XData');
%                     ydataR=get(hR,'YData');
%                     close(gcf)
%                     eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data=ydataR;'])
%                 end
%                 wstruct{p}.main.xdata=xdataR;
%             end
%             eval(['PSIMdataDown.simview.' plots{p} '=wstruct{p};']); % update struct
        case 'DSplot'
            xdata=wstruct{p}.main.xdata;
            ydata = [];
            for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
                for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
                    ydata = [ydata eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data'])];
                end
            end
            
            %                     figure % creates new figure
            % specifies the  options.DSnPoints number of points (roughly) to display on the screen. The default is
            %   50000 points (~390 kB doubles).
            hR=dsplot(xdata, ydata, options.DSpoints);
            
            h=0;
            for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
                for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
                    h=h+1;
                    xdataR=get(hR(h),'XData');
                    ydataR=get(hR(h),'YData');
                    xdataR=xdataR(:); % force vector to be vertical
                    ydataR=ydataR(:); % force vector to be vertical
                    eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data=ydataR;'])
                end
            end
            
            close(gcf)% Closes the figure
            wstruct{p}.main.xdata=xdataR;
            wstruct{p}.main.xfrom=wstruct{p}.main.xdata(1); % x lower limit
            wstruct{p}.main.xto=wstruct{p}.main.xdata(end); % x upper limit
            
            eval(['PSIMdataDown.simview.' plots{p} '=wstruct{p};']); % update struct
        otherwise
            disp('Select function to reduce data, return with 1!')
            status=1;
            return
    end % end of Select function
end % end of simview plots





    
    
    