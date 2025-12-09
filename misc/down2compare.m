% =========================================================================
%  Downsample compare function
%
% =========================================================================

function [status]=down2compare(Mdata,MDsdata)

if nargin <2 % Look for options entry
    status=1;
    return;    
end

status=0; % We must return something

Mplots=fieldnames(Mdata.simview); % Find plots in PSIMdata

MDsplots=fieldnames(MDsdata.simview); % Find plots in PSIMdata


for p = 1:length(Mplots)
    wstruct{p}=eval(['Mdata.simview.' Mplots{p}]); % set struct to work
    Dswstruct{p}=eval(['MDsdata.simview.' MDsplots{p}]); % set struct to work
    
    xtada=wstruct{p}.main.xdata; %
    Dsxtada=Dswstruct{p}.main.xdata; %
    for s=0:wstruct{p}.main.numscreen-1 % Screens Loop
        for c=0:eval(['wstruct{p}.screen' num2str(s) '.curvecount'])-1 % Curves Loop
            ydata = eval(['wstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data']);
            Dsydata = eval(['Dswstruct{p}.screen' num2str(s) '.curve' num2str(c) '.data']);
            figure
            plot(xtada,ydata,Dsxtada,Dsydata) 
            grid on
            axis tight
            legend(['Original - ' num2str(length(ydata))],['Ds - ' num2str(length(Dsydata))])
            
            
        end        
    end    
end
    
    