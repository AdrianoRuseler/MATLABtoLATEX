% =========================================================================
%  Downsample compare function
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
    
    