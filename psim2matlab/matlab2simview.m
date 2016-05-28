% =========================================================================
% *** matlab2simview
% ***  
% *** This function converts  MATLAB data in struct format to *.txt simvew
% data
% *** Convert PSIM txt data to simulink struct data
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2016 Adriano Ruseler
% *** 
% *** Permission is hereby granted, free of charge, to any person obtaining a copy
% *** of this software and associated documentation files (the "Software"), to deal
% *** in the Software without restriction, including without limitation the rights
% *** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% *** copies of the Software, and to permit persons to whom the Software is
% *** furnished to do so, subject to the following conditions:
% *** 
% *** The above copyright notice and this permission notice shall be included in all
% *** copies or substantial portions of the Software.
% *** 
% *** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% *** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% *** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% *** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% *** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% *** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% *** SOFTWARE.
% ***
% =========================================================================

function [status]=matlab2simview(MATLABdata,filename)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end


if nargin <1  % MATLABdata not supplied
    disp(' MATLABdata not supplied!')
   status =1; % Not Ok 
   return;
end

% Generates Matrix   MATLABdata=PLECSdata
data=MATLABdata.time; % Get time vector

ns=length(MATLABdata.signals); % Number of signals

VarsName{1}='Time';

for i=2:ns+1
    VarsName{i}=MATLABdata.signals(i-1).label;
    data=horzcat(data,MATLABdata.signals(i-1).values);
end

if nargin < 2  % txtfilename not supplied
    if isfield(dirstruct,'simulatedir')
        if isequal(exist(dirstruct.simulatedir,'dir'),7)
            cd(dirstruct.simulatedir) % Change to directory with simutalad data
        end
    end
   [File, Path] = uiputfile({'*.txt;*.csv;','SIMVIEW data Files (*.txt,*.csv)'; ...
        '*.mat','SIMVIEW - Text (*.txt)';'*.csv','SIMVIEW - Excel (*.csv)';...
        '*.*','All files'}, 'Save the SIMVIEW data file!');
    if isequal(File,0)
        disp('User selected Cancel!')
        status =1; % Return empty data
        return
    end
    filename=[Path File]; % Provide
end

[pathstr, name, ext] = fileparts(filename);

switch ext % Make a simple check of file extensions
    case '.csv' % Waiting for code implementation  
        csvheader=VarsName{1};        
        for nvars=2:length(VarsName)            
            csvheader=[csvheader ', ' VarsName{nvars}];
        end        
        % Write csv file
        status=savecsvfile(data, csvheader, filename);
    case '.txt'
        txtheader=VarsName{1};        
        for nvars=2:length(VarsName)            
            txtheader=[txtheader ' ' VarsName{nvars}];
        end        
        % Write text file
        status=savetxtfile(data, txtheader, filename); % OK testado
    otherwise
        disp('File extension error!')
        status =1; % Return empty data
        return
end






