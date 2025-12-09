% =========================================================================
% *** psimfra2matlab
% ***  
% *** This function converts fft PSIM simulated data to MATLAB data 
% *** format.
% *** Convert PSIM txt data to simulink struct data
% =========================================================================

function PSIMdata = psimfra2matlab(PSIMdata)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end


if ~isfield(PSIMdata.PSIMCMD,'outfile')
    disp('Field infile not Found!')
    [PSIMFile, PSIMPath] = uigetfile('*.fra','Select the PSIM ACSweep file');
    if isequal(PSIMFile,0)
        disp('User selected Cancel')
        return
    end
    PSIMdata.PSIMCMD.outfile=[PSIMPath PSIMFile];
else
    [pathstr, name, ext] = fileparts(PSIMdata.PSIMCMD.outfile);
    switch ext % Make a simple check of file extensions
        case '.fra'
            % Good to go!!
        case '.txt'
            frafile=[pathstr '\' name '.fra'];
            if ~exist(frafile,'file')
                disp('Save simview Settings and load the *.fra file.')
                cd(dirstruct.wdir)
                return
            else
                PSIMdata.PSIMCMD.outfile=frafile;
                [pathstr, name, ext] = fileparts(PSIMdata.PSIMCMD.outfile);
            end
        otherwise
            disp('Save simview Settings and load the *.fra file.')
            cd(dirstruct.wdir)
            return
    end    
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
[fileID,errmsg] = fopen(PSIMdata.PSIMCMD.outfile);
% [filename,permission,machinefmt,encodingOut] = fopen(fileID); 
if fileID==-1
    disp('File error!!')
    return
end

tline = fgetl(fileID); % Frequency amp(VarName) phase(VarName) ...
[fraheader] = strread(tline,'%s','delimiter',' '); % Convert header into cell array
PSIMdata.fra.header=fraheader;

fstr='%f';
for tt=2:length(fraheader)
    fstr=[fstr '%f'];
end

FRAdata = cell2mat(textscan(fileID,fstr));
fclose(fileID);

PSIMdata.fra.freq=FRAdata(:,1);

% Verifies header name
s=1;
for i=2:2:length(fraheader)-1
    varstr=fraheader{i}; % Gets header name
    [startIndex,endIndex] = regexp(varstr,'\(\w+\)');
    PSIMdata.fra.signals(s).label=varstr(startIndex+1:endIndex-1);
    PSIMdata.fra.signals(s).amp=single(FRAdata(:,i));
    PSIMdata.fra.signals(s).phase=single(FRAdata(:,i+1));
    PSIMdata.fra.signals(s).dimensions=1;
    s=s+1;
end

PSIMdata.fra.name=name;
 
disp('Done!!!!')
toc

freq=PSIMdata.fra.freq;

for s=1:length(PSIMdata.fra.signals)
   mag= PSIMdata.fra.signals(s).amp;
   phase= PSIMdata.fra.signals(s).phase;      
   response = mag.*exp(1j*phase*pi/180);
   PSIMdata.fra.idfrd(s) = idfrd(response,freq,0);
   assignin('base',PSIMdata.fra.signals(s).label,PSIMdata.fra.idfrd(s));
end

% disp('Saving data file....')
% cd(dirstruct.psimstorage)
% save([name '_data.mat'], 'PSIMdata') 

% assignin('base','dirstruct',dirstruct);
% cd(dirstruct.root)
% save('dirstruct.mat','dirstruct')

cd(dirstruct.wdir)
% disp('All done!!!')


