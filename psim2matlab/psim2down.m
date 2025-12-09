
% =========================================================================
%  PSIM data downsample using Decimate MATLAB function
%
%
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
        case 'decimate' %  
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
            
            
 % --------------------------------  DSplot   ------------------------------------------------      
        case 'DSplot' % Recomended
            xdata=wstruct{p}.main.xdata;
            for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
                ydata = [];
                nvars=1;
                for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
                    ydata = [ydata eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data'])];
                    nvars=nvars+1;
                end
                hR=dsplot(xdata, ydata, nvars*options.DSpoints);
                %             pause
                h=0;
                for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
                    h=h+1;
                    xdataR=get(hR(h),'XData');
                    ydataR=get(hR(h),'YData');
                    xdataR=xdataR(:); % force vector to be vertical
                    ydataR=ydataR(:); % force vector to be vertical
                    
                    %                      disp(['The Screen' num2str(s) '.curve' num2str(c) ' xdata length is:' num2str(length(xdataR))])
                    %                      disp(['The Screen' num2str(s) '.curve' num2str(c) ' ydata length is:' num2str(length(ydataR))])
                    XdataLength(s+1,c+1) = length(xdataR);
                    YdataLength(s+1,c+1) = length(ydataR);
                    
                    eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data=ydataR;'])
                    eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.xdata=xdataR;'])
                end
                
                eval(['wstruct{p}.screen' num2str(s) '.xdata=xdataR;'])
                xfrom=xdataR(1);
                xto=xdataR(end);
                eval(['wstruct{p}.screen' num2str(s) '.xfrom=xfrom;'])
                eval(['wstruct{p}.screen' num2str(s) '.xto=xto;'])
                close(gcf)% Closes the figure
            end
            %             close(gcf)% Closes the figure
            wstruct{p}.main.xdata=xdataR; % Must verify this
            wstruct{p}.main.xfrom=wstruct{p}.main.xdata(1); % x lower limit
            wstruct{p}.main.xto=wstruct{p}.main.xdata(end); % x upper limit
            
            % If data length are different, interpolate to match
            if (abs(diff(XdataLength)))
                [xB yB]= find(XdataLength==min(XdataLength(:)),1); % Base curve
                eval(['xBase=wstruct{p}.screen' num2str(xB-1) '.curve' num2str(yB-1) '.xdata;'])
                %                assignin('base', 'xBase', xBase);
                for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
                    for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
                        eval(['xdataR=wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.xdata;'])
                        eval(['ydataR=wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data;'])
%                         assignin('base', ['ydata' num2str(s) num2str(c)], ydataR);
                        ydata = interp1(xdataR,ydataR,xBase);
                        eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data=ydata;'])
                        eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.xdata=xBase;'])
                    end
                    eval(['wstruct{p}.screen' num2str(s) '.xdata=xBase;'])
                    xfrom=xBase(1);
                    xto=xBase(end);
                    eval(['wstruct{p}.screen' num2str(s) '.xfrom=xfrom;'])
                    eval(['wstruct{p}.screen' num2str(s) '.xto=xto;'])
                    %                 close(gcf)% Closes the figure
                end
                wstruct{p}.main.xdata=xBase; % Must verify this
                wstruct{p}.main.xfrom=wstruct{p}.main.xdata(1); % x lower limit
                wstruct{p}.main.xto=wstruct{p}.main.xdata(end); % x upper limit
            end
            
            
            eval(['PSIMdataDown.simview.' plots{p} '=wstruct{p};']); % update struct
        otherwise
            disp('Select function to reduce data, return with 1!')
            status=1;
            return
    end % end of Select function
end % end of simview plots







