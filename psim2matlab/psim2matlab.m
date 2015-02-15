% =========================================================================
% *** psim2matlab
% ***  
% *** This function converts PSIM simulated data to MATLAB data in struct
% *** format.
% *** Convert PSIM txt data to simulink struct data
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2015 AdrianoRuseler
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

function PSIMdata = psim2matlab(PSIMtxt)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct');
    disp(dirstruct)
catch
    checkdirstruct % Well, check this out
end

if ~isfield(dirstruct,'simulatedir') % Check if directory for simulations is defined
    dirstruct.simulatedir=uigetdir(pwd,'Select directory for PSIM simulations');
    if isequal(dirstruct.simulatedir,0)
        disp('User selected Cancel')        
        return
    end
end

if nargin <1  % PSIMtxtFile not supplied
    if isequal(exist(dirstruct.simulatedir,'dir'),7)
        cd(dirstruct.simulatedir)
    end
    [PSIMtxtFile, PSIMtxtPath] = uigetfile({'*.txt;*.fra;*.csv','PSIM Files (*.txt,*.fra)'; ...
        '*.txt','PSIM-Data (*.txt)';'*.fra','AC-Sweed (*.fra)';...
        '*.*','All files'}, 'Pick an PSIM-file');
    if isequal(PSIMtxtFile,0)
        disp('User selected Cancel')
        PSIMdata =[];
        return
    end
    [pathstr, name, ext] = fileparts(PSIMtxtFile);    
    if isequal(ext,'.smv') % Not supported here
        disp('Wrong file extension. Convert the file to a *.txt file.')
         cd(dirstruct.wdir)
         PSIMdata =[];
        return
    end      
    dirstruct.simulatedir=PSIMtxtPath; % Update simulations dir
    PSIMtxt=PSIMtxtFile;
else
   [pathstr, name, ext] = fileparts(PSIMtxt); 
   dirstruct.simulatedir=pathstr;
end


%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.psimdir, name); % Check here
dirstruct.storage = [dirstruct.psimdir '\' name]; % Not sure


%%  Load file .txt
disp('Reading txt file....     Wait!')

tic
cd(dirstruct.simulatedir)
fid = fopen(PSIMtxt);
if fid==-1
    disp('File error')
    return
end

% [filename,permission,machinefmt,encodingOut] = fopen(fid); 

% BufSize -> Maximum string length in bytes -> 4095
tline = fgetl(fid);
[header] = strread(tline,'%s','delimiter',' ');

fstr='%f';
 for tt=2:length(header)
    fstr=[fstr '%f']; 
 end
 
M = cell2mat(textscan(fid,fstr));            
fclose(fid);

disp('Done!')

%% Convert data

 disp('Converting to simulink struct data ....')

 PSIMdata.time=single(M(:,1));
 PSIMdata.signals.values=single(M(:,2:end));
 PSIMdata.signals.dimensions=size(M,2)-1;
%  invalid_name=1; 
  for i=2:length(header)
     [U, modified] = matlab.lang.makeValidName(header{i});
     if modified
       disp(['Name ' header{i} ' modified to ' U ' (MATLAB valid name for variables)!!'])        
%        changeName{invalid_name}=header{i};
%        invalid_name=invalid_name+1; 
    end
    PSIMdata.signals.label{i-1}=U;
  end
  
 PSIMdata.PSIMheader=header; % For non valid variables
 PSIMdata.signals.title='';
 PSIMdata.signals.plotStyle=[0,0]; 
 PSIMdata.blockName=name;
 
disp('Done!!!!')
toc

disp('Saving data file....')
cd(dirstruct.storage)
save([name '_data.mat'], 'PSIMdata')



assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')

cd(dirstruct.wdir)
disp('We are good to go!!!')

% winopen(dirstruct.storage)

end

