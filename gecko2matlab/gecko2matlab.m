% =========================================================================
% *** gecko2matlab
% ***  
% *** This function converts GeckoCIRCUITS simulated data to MATLAB data in struct
% *** format.
% *** Convert GeckoCIRCUITS txt data to simulink struct data
% =========================================================================

function GeckoData = gecko2matlab(GeckoTxtFile)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if nargin <1  % PSIMtxt not supplied
    if isfield(dirstruct,'simulatedir')
        if isequal(exist(dirstruct.simulatedir,'dir'),7)
            cd(dirstruct.simulatedir) % Change to directory with simutalad data
        end
    end
    [GeckoTxtName, GeckoTxtPath] = uigetfile({'*.txt','GeckoCIRCUITS (*.txt)';...
        '*.*','All files'}, 'Pick an GeckoCIRCUITS txt file!');
    if isequal(GeckoTxtName,0)
        disp('User selected Cancel')
        GeckoData =[]; % Return empty data
        return
    end
    GeckoTxtFile=[GeckoTxtPath GeckoTxtName]; % Provide
else
    if ~isequal(exist(GeckoTxtFile,'file'),2) % If file NOT exists
        disp([GeckoTxtFile ' Not found!'])
        GeckoData = gecko2matlab(); % Load again
        return
    end
end

% Split GeckoTxtFile name
[pathstr, name, ext] = fileparts(GeckoTxtFile);

switch ext % Make a simple check of file extensions
    case '.txt'
         % Good to go!!
    otherwise
        disp('Save GeckoCIRCUITS data as *.txt file.')
        cd(dirstruct.wdir)
        GeckoData =[];
        return
end
    
dirstruct.simulatedir=pathstr; % Update simulations dir
    
%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.geckodir, name); % Check here
dirstruct.geckostorage = [dirstruct.geckodir '\' name]; %


%%  Load file .txt
disp(['Reading ' name '.txt file....     Wait!'])
tic
cd(dirstruct.simulatedir)
[fileID,errmsg] = fopen(GeckoTxtFile);
% [filename,permission,machinefmt,encodingOut] = fopen(fileID); 
if fileID==-1
    disp('File error!!')
    return
end

% BufSize -> Maximum string length in bytes -> 4095
tline = fgetl(fileID);
[header] = strread(tline,'%s','delimiter',' ');

header={header{2:end}}'; % Just ignore first caracter

fstr='%f';
for tt=2:length(header)
    fstr=[fstr '%f'];
end
 
M = cell2mat(textscan(fileID,fstr));            
fclose(fileID);

disp('Done!')

%% Convert data

 disp('Converting to simulink struct data ....')

 GeckoData.time=M(:,1);
 GeckoData.Ts=M(2,1)-M(1,1); % Time step
 
 % Verifies header name
 for i=2:length(header)
     if verLessThan('matlab', '8.2.0')
         U = genvarname(header{i});
         modified=1; % Just force update
     else
         [U, modified] = matlab.lang.makeValidName(header{i},'ReplacementStyle','delete');
     end
     if modified
         disp(['Name ' header{i} ' modified to ' U ' (MATLAB valid name for variables)!!'])
     end
     GeckoData.signals(i-1).label=U;
     GeckoData.signals(i-1).values=M(:,i);
     GeckoData.signals(i-1).dimensions=1;   
     GeckoData.signals(i-1).title=U;
     GeckoData.signals(i-1).plotStyle=[0,0];
 end
  
 GeckoData.blockName=name;

 
GeckoData.GeckoHeader=header; % For non valid variables
disp('Done!!!!')
toc

disp('Saving data file....')
cd(dirstruct.geckostorage)
save([name '_data.mat'], 'GeckoData') 

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')

cd(dirstruct.wdir)
disp('We are good to go!!!')

% winopen(dirstruct.geckostorage)

end

