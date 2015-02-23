% =========================================================================
% *** csv2struct
% *** Converts Scope dat to Simulink Struct data
% ***
% ***  Returns SCOPEdata

% *** [SCOPEdata] = csv2struct();
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


function [SCOPEdata] = csv2struct(SCOPEcsv)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end


if nargin <1  % PSIMtxt not supplied
    if isfield(dirstruct,'aquisitiondir')
        if isequal(exist(dirstruct.aquisitiondir,'dir'),7)
            cd(dirstruct.aquisitiondir) % Change to directory with aquisition data
        end
    end
    
    [csvfilename, csvpathname] = uigetfile('*.csv', 'Select scope data aquisition', 'MultiSelect', 'off');
    if isequal(csvfilename,0)
        disp('User selected Cancel')
        SCOPEdata=[];
        return
    end
    SCOPEcsv=[csvpathname csvfilename];
else
    if ~isequal(exist(SCOPEcsv,'file'),2) % If file NOT exists
        disp([SCOPEcsv ' Not found!'])
        [SCOPEdata] = csv2struct(); % Load again
        return
    end
end

[pathstr, name, ext] = fileparts(SCOPEcsv);
switch ext % Make a simple check of file extensions
    case '.csv'
        % Good to go!!
    otherwise
        disp('We expect an *.csv file.')
        cd(dirstruct.wdir)
        return
end
% Make name valid in MATLAB
name = matlab.lang.makeValidName(name);

dirstruct.aquisitiondir=pathstr;

%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.scopedir, name); % Check here
dirstruct.scopestorage = [dirstruct.scopedir '\' name]; % Not sure

tic
DELIMITER = ',';
HEADERLINES = 21;

csvdata = importdata(SCOPEcsv, DELIMITER, HEADERLINES);

for i=1:HEADERLINES-1
    sheader{i} = strsplit(csvdata.textdata{i,1},',');
end

%  Converte para o formato de estruturas utilizado pelo simulink.
SCOPEdata.scopedata.model=sheader{1}{2};
SCOPEdata.scopedata.firmware=str2double(sheader{2}{2});
SCOPEdata.scopedata.xunits=sheader{6}{2};
SCOPEdata.scopedata.xscale=str2double(sheader{7}{2});
SCOPEdata.scopedata.xdelay=str2double(sheader{8}{2});
SCOPEdata.scopedata.xinterval=str2double(sheader{9}{2});
SCOPEdata.scopedata.xlength=str2double(sheader{10}{2});

SCOPEdata.scopedata.yunits=sheader{13}{2};
SCOPEdata.scopedata.yoffset=str2double(sheader{14}{2});
SCOPEdata.scopedata.yscale=str2double(sheader{15}{2});
SCOPEdata.scopedata.yposition=str2double(sheader{16}{2});

SCOPEdata.time=single(csvdata.data(:,1));
header=csvdata.colheaders;

for i=2:length(header)
    SCOPEdata.signals(i-1).values=single(csvdata.data(:,i));
    SCOPEdata.signals(i-1).dimensions=1;
    
    if verLessThan('matlab', '8.2.0')
        % -- Put code to run under MATLAB 8.2.0 and earlier here --
        U = genvarname(header{i});
    else
        % -- Put code to run under MATLAB 8.2.0 and later here --
        U = matlab.lang.makeValidName(header{i});
    end
    
   if ~isempty(strfind(U,'MATH'))
       U = 'math'; % Puts math as label only
   end    
    
    SCOPEdata.signals(i-1).label=U;
    SCOPEdata.signals(i-1).title=U;
    SCOPEdata.signals(i-1).plotStyle=[0,0];
end

SCOPEdata.blockName=name;
disp('Done!!!!')

cd(dirstruct.scopestorage)
save([name '_data.mat'], 'SCOPEdata')

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')

cd(dirstruct.wdir)
toc
disp('We are good to go!!!')
%    fftresults = power_fftscope
end










