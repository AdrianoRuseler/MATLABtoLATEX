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


function [status]=scope2tikz(SCOPEdata)

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
        
    end
end

%% All data must be available here:
SCOPEdata



