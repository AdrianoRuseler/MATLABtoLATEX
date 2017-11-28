% =========================================================================
% *** psimfra2matlab
% ***  
% *** This function converts fft PSIM simulated data to MATLAB data 
% *** format.
% *** Convert PSIM txt data to simulink struct data
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


function PSIMdata = psimfra2matlab(PSIMfra)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if nargin <1 % PSIMini not supplied
    if isfield(dirstruct,'simulatedir')
        if isequal(exist(dirstruct.simulatedir,'dir'),7)
            cd(dirstruct.simulatedir) % Change to directory with simutalad data
        end
    end
    [PSIMfraFile,PSIMfraPath] = uigetfile('*.fra','Select the PSIM fft file');
    if isequal(PSIMfraFile,0)
        disp('User selected Cancel')
        return
    end    
    PSIMfra=[PSIMfraPath PSIMfraFile]; % Provide ini file      
end

if ~isequal(exist(PSIMfra,'file'),2) % If file NOT exists
    disp([PSIMfra ' Not found!'])
    PSIMdata = psimfra2matlab(); % Load again without file location
    return
end


try
    disp('Load PSIMdata from base workspace!!')
    PSIMdata = evalin('base', 'PSIMdata'); % Load PSIMdata from base workspace    
catch
    disp('Load all mat files in this folder!!')
    % Load .mat file
    if isfield(dirstruct,'psimstorage')
        if isequal(exist(dirstruct.psimstorage,'dir'),7)
            cd(dirstruct.psimstorage) % Change to directory with PSIM data           
            infolder = what; %look in current directory
            matfiles=infolder.mat; % Get all mat files in this folder            
            for a=1:numel(matfiles) % Just loads all mfiles
                load(char(matfiles(a)));
            end                   
        end
    else        
        PSIMdata = psim2matlab();  % Ask for PSIM data file
        if isempty(PSIMdata) % If there is no data, just return
            return
        end
    end
end

% if isempty(PSIMdata) % If there is no data, just return
%     PSIMdata = psim2matlab();  % Ask for PSIM data file
%     return
% end

[pathstr, name, ext] = fileparts(PSIMfra);
switch ext % Make a simple check of file extensions
    case '.fra'
        % Good to go!!
    otherwise
        disp('Save simview Settings and load the *.fra file.')
        cd(dirstruct.wdir)
        return
end

dirstruct.simulatedir=pathstr; % Update simulations dir
    
%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.psimdir, name); % Check here
dirstruct.psimstorage = [dirstruct.psimdir '\' name]; % Not sure

% Make name valid in MATLAB
name = matlab.lang.makeValidName(name);
name = strrep(name, '_', ''); % Removes umderscore


%%  Load file .fft
disp('Reading fra file....     Wait!')
tic
cd(dirstruct.simulatedir)
[fileID,errmsg] = fopen(PSIMfra);
% [filename,permission,machinefmt,encodingOut] = fopen(fileID); 
if fileID==-1
    disp('File error!!')
    return
end

tline = fgetl(fileID); % Frequency amp(VarName) phase(VarName) ...
[fraheader] = strread(tline,'%s','delimiter',' ');
PSIMdata.fra.header=fraheader;

fstr='%f';
for tt=2:length(fraheader)
    fstr=[fstr '%f'];
end

FRAdata = cell2mat(textscan(fileID,fstr));
fclose(fileID);

PSIMdata.fra.freq=FRAdata(:,1);

 % Verifies header name
 for i=2:length(fraheader)-1
     varstr=fraheader{i};
     [startIndex,endIndex] = regexp(varstr,'\(\w+\)');     
     PSIMdata.fra.signals(i-1).label=varstr(startIndex+1:endIndex-1);
     PSIMdata.fra.signals(i-1).amp=single(FRAdata(:,i));
     PSIMdata.fra.signals(i-1).phase=single(FRAdata(:,i+1));
     PSIMdata.fra.signals(i-1).dimensions=1;   
 end
  
 PSIMdata.fra.name=name;
 
 disp('Done!!!!')
toc

disp('Saving data file....')
cd(dirstruct.psimstorage)
save([name '_data.mat'], 'PSIMdata') 

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')

cd(dirstruct.wdir)
disp('We are good to go!!!')


