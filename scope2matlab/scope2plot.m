% =========================================================================
%  PSIM Plot function
%  psim2plot -- Plots simview data
%
% =========================================================================
% http://pgfplots.sourceforge.net/gallery.html
% =========================================================================


function status=scope2plot(SCOPEdata)

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


figure
plot(SCOPEdata.time,SCOPEdata.signals(1).values)

