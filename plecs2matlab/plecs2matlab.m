
% =========================================================================
%  PLECS mat file to MATLAB SIMULINK data format 
%
%
% =========================================================================
%
%  The MIT License (MIT)
%
%  Copyright (c) 2016 Adriano Ruseler
%
%  Permission is hereby granted, free of charge, to any person obtaining a copy
%  of this software and associated documentation files (the Software), to deal
%  in the Software without restriction, including without limitation the rights
%  to use, copy, modify, merge, publish, distribute, sublicense, andor sell
%  copies of the Software, and to permit persons to whom the Software is
%  furnished to do so, subject to the following conditions
%
%  The above copyright notice and this permission notice shall be included in all
%  copies or substantial portions of the Software.
%
%  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%  SOFTWARE.
% =========================================================================


function [PLECSdata]=plecs2matlab(PLECSfileName)


% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if nargin <1  % PLECSfile not supplied
    if isfield(dirstruct,'simulatedir')
        if isequal(exist(dirstruct.simulatedir,'dir'),7)
            cd(dirstruct.simulatedir) % Change to directory with simutalad data
        end
    end
    [PlecsFile, PlecsPath] = uigetfile({'*.mat;*.csv;','PLECS Files (*.mat,*.csv)'; ...
        '*.mat','PLECS - MATLAB (*.mat)';'*.csv','PLECS Excel (*.csv)';...
        '*.*','All files'}, 'Pick an PLECS-data-file');
    if isequal(PlecsFile,0)
        disp('User selected Cancel!')
        PLECSdata =[]; % Return empty data
        return
    end
    PLECSfileName=[PlecsPath PlecsFile]; % Provide
else
    if ~isequal(exist(PLECSfileName,'file'),2) % If file NOT exists
        disp([PLECSfileName ' Not found!'])
        PLECSdata = plecs2matlab(); % Load again
        return
    end
end

[pathstr, name, ext] = fileparts(PLECSfileName);

switch ext % Make a simple check of file extensions
    case '.csv' % Waiting for code implementation
        disp('Reading *.csv file....     Wait!')
        tic
        cd(dirstruct.simulatedir)
        [fileID,errmsg] = fopen(PLECSfileName);
        % [filename,permission,machinefmt,encodingOut] = fopen(fileID);
        if fileID==-1
            disp('File error!!')
            return
        end
        
        % BufSize -> Maximum string length in bytes -> 4095
        tline = fgetl(fileID);
        try % Trys to read numbers
            [header] = strread(tline,'%f','delimiter',','); % First line of data
            frewind(fileID); % Move file position indicator to beginning of open file
            nvars=length(header); 
            VarsName{1}='Time';
            for i=2:nvars
                VarsName{i}=['Var' num2str(i-1,'%02d')];
            end
            
        catch
            [header] = strread(tline,'%s','delimiter',','); % First line of data
            nvars=length(header);
            VarsName{1}='Time';            
            % Verifies header name
            for i=2:nvars
                if verLessThan('matlab', '8.2.0')
                    VarsName{i}=['Var' num2str(i-1,'%02d')];
                    modified=1; % Just force update
                else
                    [VarsName{i}, modified] = matlab.lang.makeValidName(header{i},'ReplacementStyle','delete');
                end
                if modified
                    disp(['Name ' header{i} ' modified to ' VarsName{i} ' (MATLAB valid name for variables)!!'])
                end
            end            
        end              
        
        formatSpec='%f';
        for tt=2:nvars
            formatSpec=[formatSpec '%f'];
        end
        
        dataArray = textscan(fileID, formatSpec, 'Delimiter', ',' , 'EmptyValue' ,NaN, 'ReturnOnError', false);
        fclose(fileID);
        
        M = cell2mat(dataArray); % Convert cell to matrix
        %         fclose(fileID);
%         M=single(M); % Converts to single
        nvars=length(header); % Number of Variables including time
        toc
        disp('Done!')
        
    case '.mat' %
        % Good to go!!  % PLECSfileName='J:\Dropbox\Dropbox\phd-thesis\Capitulos\Concl\Sims\data.csv';
        PLECS=load(PLECSfileName);
        M=single(PLECS.data'); % Extracts matrix of data
        [lvars nvars]=size(M); % Number of Variables including time
        
%          M=single(M); % Converts to single
        VarsName{1}='Time';
        for i=2:nvars
            VarsName{i}=['Var' num2str(i-1,'%02d')];
        end        
    otherwise
        disp('Save PLECS data as *.csv or *.mat file.')
        cd(dirstruct.wdir)
        PLECSdata =[];
        return
end
    
dirstruct.simulatedir=pathstr; % Update simulations dir

%  Create folder under psimdir to store mat file
[s,mess,messid] = mkdir(dirstruct.plecsdir, name); % Check here  plecsdir
dirstruct.plecsstorage = [dirstruct.plecsdir '\' name]; % Not sure plecsstorage


%% Convert data

 disp('Converting to simulink struct data ....')

 PLECSdata.time=M(:,1); % time vector
  
 % Generates simulink struct
 for i=2:nvars
     PLECSdata.signals(i-1).label=VarsName{i};
     PLECSdata.signals(i-1).values=M(:,i);
     PLECSdata.signals(i-1).dimensions=1;   
     PLECSdata.signals(i-1).title=VarsName{i};
     PLECSdata.signals(i-1).plotStyle=[0,0];
 end
  
 PLECSdata.blockName=name; 
 

disp('Saving data file....')
cd(dirstruct.plecsstorage)
save([name '_data.mat'], 'PLECSdata') 

assignin('base','dirstruct',dirstruct);
cd(dirstruct.root)
save('dirstruct.mat','dirstruct')

cd(dirstruct.wdir)
disp('We are good to go!!!')













