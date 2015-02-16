% =========================================================================
%  PSIM Plot function
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

function [status]=psim2tikz(PSIMdata)

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
PSIMdata


