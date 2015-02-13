function setstruct = set2struct
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
% setstruct = set2struct 
% 
% This function parses tektronix setup file FileName and returns it as a 
% structure with section names and keys as fields.

% =========================================================================

% Pre load

  % Make sure that we get something
    [FileName,PathName] = uigetfile('*.set','Select the scope setup file');
    if isequal(FileName,0)
        disp('User selected Cancel')
        setstruct=[];  % We have to return something
        return
        %     else      
    end
  
%     [pathstr, name, ext] = fileparts(FileName);

% 
% =========================================================================
setstruct = [];                            % we have to return something

[fileID,errmsg] = fopen([PathName FileName],'r');      % open file

% Its OK to read this file?
% [filename,permission,machinefmt,encodingOut] = fopen(fileID);
if fileID==-1
    disp(errmsg); % Show file error msg
    return % Bye
end

while ~feof(fileID)                          % and read until it ends
    s = strtrim(fgetl(fileID));              % Remove any leading/trailing spaces
    
    %     s=':SEARCH:SEARCH1:TRIGGER:A:UPPERTHRESHOLD:REF2 2.5000'; % for test
   % s= ':MATH:SPECTRAL:MAG DB';
   % s=':MATH:DEFINE "(CH1+CH2+CH3)/3"'
    
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

return;




