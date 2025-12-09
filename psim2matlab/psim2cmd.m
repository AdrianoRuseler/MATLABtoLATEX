
function  PSIMdata = psim2cmd(PSIMdata)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if ~isfield(PSIMdata.PSIMCMD,'infile')
    disp('Field infile not Found!')
    [PSIMFile, PSIMPath] = uigetfile({'*.psimsch;*.sch','PSIM Files (*.psimsch,*.sch)'; ...
        '*.psimsch','PSIM File';'*.sch','PSIM File'; '*.*','All files'}, 'Pick an PSIM-file');    
    if isequal(PSIMFile,0)
        disp('User selected Cancel')
        return
    end
    PSIMdata.PSIMCMD.infile=[PSIMPath PSIMFile];
else
    if ~exist(PSIMdata.PSIMCMD.infile,'file')
         disp('File infile not Found!')
        [PSIMFile, PSIMPath] = uigetfile({'*.psimsch;*.sch','PSIM Files (*.psimsch,*.sch)'; ...
            '*.psimsch','PSIM File';'*.sch','PSIM File'; '*.*','All files'}, 'Pick an PSIM-file');        
        if isequal(PSIMFile,0)
            disp('User selected Cancel')
            return
        end
        PSIMdata.PSIMCMD.infile=[PSIMPath PSIMFile];
    end    
end

disp(PSIMdata.PSIMCMD.infile)

[filepath,name,ext] = fileparts(PSIMdata.PSIMCMD.infile);

PSIMdata.PSIMCMD.outfile = [filepath '\' name '.txt'];
PSIMdata.PSIMCMD.msgfile = [filepath '\' name '_msg.txt'];
PSIMdata.PSIMCMD.inifile = [filepath '\' name '.ini']; % Arquivo ini simview
PSIMdata.PSIMCMD.extracmd = '-g'; % -g :  Run Simview after the simulation is complete.

% Cria string de comando
infile = ['"' PSIMdata.PSIMCMD.infile '"'];
outfile = ['"' PSIMdata.PSIMCMD.outfile '"'];
msgfile = ['"' PSIMdata.PSIMCMD.msgfile '"'];
totaltime = ['"' num2str(PSIMdata.PSIMCMD.totaltime) '"'];  %   -t :  Followed by total time of the simulation.
steptime = ['"' num2str(PSIMdata.PSIMCMD.steptime) '"']; %   -s :  Followed by time step of the simulation.
printtime = ['"' num2str(PSIMdata.PSIMCMD.printtime) '"']; %   -pt : Followed by print time of the simulation.
printstep = ['"' num2str(PSIMdata.PSIMCMD.printstep) '"']; %   -ps : Followed by print step of the simulation.

PsimCmdsrt= ['-i ' infile ' -o ' outfile ' -m ' msgfile ' -t ' totaltime ' -s ' steptime ' -pt ' printtime ' -ps ' printstep ' ' PSIMdata.PSIMCMD.extracmd];

tic
disp(PsimCmdsrt)
disp('Simulating PSIM file...')
[status,cmdout] = system(['PsimCmd ' PsimCmdsrt]); % Executa simula��o
toc
disp(cmdout)
PSIMdata.PSIMCMD.cmdout=cmdout;
% temp=PSIMdata.PSIMCMD;

% disp(PSIMdata.PSIMCMD.outfile)
if ~status % Simulated OK!    
    if exist([filepath '\' name '.txt'],'file')
        PSIMdata = psim2matlab(PSIMdata);
    end
    
    if exist([filepath '\' name '.fra'],'file')
        PSIMdata = psimfra2matlab(PSIMdata);
    end
    
    if exist([filepath '\' name '.ini'],'file')
        PSIMdata = simview2matlab(PSIMdata); % Read simview data
    end
end




