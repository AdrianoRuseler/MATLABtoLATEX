% =========================================================================
% *** matlab2simview
% ***  
% *** This function converts  MATLAB data in struct format to *.txt simvew
% data
% *** Convert PSIM txt data to simulink struct data
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






