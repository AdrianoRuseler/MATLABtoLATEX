
%==========================================================================
% The MIT License (MIT)
% 
% Copyright (c) 2015 AdrianoRuseler
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.
%==========================================================================
% 
% SCOPEdata = set2struct();
% 
% This function parses tektronix setup file FileName and returns it as a 
% structure with section names and keys as fields.

% =========================================================================

function [SCOPEdata] = set2struct(SCOPEset)

SCOPEdata=[]; % We have to return something
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
    if isfield(dirstruct,'aquisitiondir')
        if isequal(exist(dirstruct.aquisitiondir,'dir'),7)
            cd(dirstruct.aquisitiondir) % Change to directory with aquisition data
        end
    end      
    [SCOPEsetFile,SCOPEsetPath] = uigetfile('*.set','Select the scope setup file');
    if isequal(SCOPEsetFile,0)
        disp('User selected Cancel')
          return
    end    
     SCOPEset=[SCOPEsetPath SCOPEsetFile]; % Provide SCOPEset file 
else
     if ~isequal(exist(SCOPEset,'file'),2) % If file NOT exists
        disp([SCOPEset ' Not found!'])
        SCOPEdata = csv2struct(); % Load again
        return
     end    
end


% Try to Load SCOPEdata structure
try
    SCOPEdata = evalin('base', 'SCOPEdata'); % Load SCOPEdata from base workspace
    %     disp('Load PSIMdata from base workspace')
catch
    % Load .mat file
    if isfield(dirstruct,'scopestorage')
        if isequal(exist(dirstruct.scopestorage,'dir'),7)
            cd(dirstruct.scopestorage) % Change to directory with SCOPEdata
            infolder = what; %look in current directory
            matfiles=infolder.mat; % Get all mat files in this folder
            for a=1:numel(matfiles) % Just loads all mfiles
                load(char(matfiles(a)));
            end
            if isempty(SCOPEdata)
                SCOPEdata = csv2struct();
            end            
        end
    else
        SCOPEdata = csv2struct();  % Ask for SCOPEdata file
        if isempty(SCOPEdata) % If there is no data, just return
            return
        end
    end
end


[pathstr, name, ext] = fileparts(SCOPEset);
switch ext % Make a simple check of file extensions
    case '.set'
        % Good to go!!
    otherwise
        disp('We expect an *.set file.')
        cd(dirstruct.wdir)
        return
end
% Make name valid in MATLAB
name = matlab.lang.makeValidName(name);

dirstruct.aquisitiondir=pathstr; % Update aquisition dir

% =========================================================================
tic
disp(['Reading file ' SCOPEset])
[fileID,errmsg] = fopen(SCOPEset,'r');      % open file

% Its OK to read this file?
% [filename,permission,machinefmt,encodingOut] = fopen(fileID);
if fileID==-1
    disp(errmsg); % Show file error msg
    return % Bye
end

while ~feof(fileID)                          % and read until it ends
    s = strtrim(fgetl(fileID));              % Remove any leading/trailing spaces
  
    if isempty(s)  % If line is empty, keep going...
        continue;
    end;
    
    ssplit = strsplit(s,':'); % Splits the line with the delimiter ':'
    % last field have the desired value
    if length(ssplit)<=2
        strvalue = strsplit(ssplit{end});
        CurrMainField = getname(strvalue{1});
        
        FieldValue = str2double(strvalue{2}); % Convert to number
        if isnan(FieldValue)
            FieldValue = strtok(strvalue{2},'"') ; % Leave it as it was if is not a number;
        end
        
        % Applies to the structure
        eval(['setstruct.' CurrMainField ' = FieldValue;'])
        
    else        
        %     CurrMainField = lower(ssplit{f});
        structfiled = '';
        for f=2:length(ssplit)-1
            CurrMainField = getname(ssplit{f});
            if f>2
                structfiled =[structfiled '.' CurrMainField];
            else
                structfiled =CurrMainField;
            end
        end        
        
        strvalue = strsplit(ssplit{end});
        CurrMainField = getname(strvalue{1});
        
        FieldValue = str2double(strvalue{2}); % Convert to number
        if isnan(FieldValue)
            FieldValue = strtok(strvalue{2},'"'); % Leave it as it was if is not a number;
        end
   
        % Applies to the structure
        eval(['setstruct.' structfiled '.' CurrMainField ' = FieldValue;'])
    end
end

fclose(fileID);

SCOPEdata.setstruct=setstruct; 

cd(dirstruct.scopestorage)
save([name '_data.mat'], 'SCOPEdata') 

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')

cd(dirstruct.wdir)
toc
disp('Done!!!!')










