
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2017 AdrianoRuseler
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

function PSIMdata = simview2matlab(PSIMdata)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end



if ~isfield(PSIMdata.PSIMCMD,'inifile')
    disp('Field inifile not Found!')
    [PSIMFile, PSIMPath] = uigetfile('*.ini','Select the SIMVIEW *.ini file','MultiSelect', 'off');   
    if isequal(PSIMFile,0)
        disp('User selected Cancel')
        return
    end
    PSIMdata.PSIMCMD.inifile=[PSIMPath PSIMFile];
else
    if ~exist(PSIMdata.PSIMCMD.inifile,'file')
         disp('File inifile not Found!')
        [PSIMFile, PSIMPath] = uigetfile('*.ini','Select the SIMVIEW *.ini file','MultiSelect', 'off');          
        if isequal(PSIMFile,0)
            disp('User selected Cancel')
            return
        end
        PSIMdata.PSIMCMD.inifile=[PSIMPath PSIMFile];
    end    
end



[pathstr, name, ext] = fileparts(PSIMdata.PSIMCMD.inifile);
switch ext % Make a simple check of file extensions
    case '.ini'
        % Good to go!!
    otherwise
        disp('Save simview Settings and load the *.ini file.')
        cd(dirstruct.wdir)
        return
end

% Make name valid in MATLAB
name = matlab.lang.makeValidName(name);
name = strrep(name, '_', ''); % Removes umderscore


PSIMdata.simview.inidata = ini2struct(PSIMdata.PSIMCMD.inifile);  
