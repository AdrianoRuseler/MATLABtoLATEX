
%% Generate .tex files

wdir=pwd; % Get current directory
[folder, name, ext] = fileparts(which('runMatlab2TikzTests')); % Change directory
cd(folder)

runMatlab2TikzTests % Executes test routine

%% Compiles all test .tex files
outfile=[folder '\output\current\data\converted'];
cd(outfile)
texfiles = ls('*.tex');

[status,cmdout] = system('make','-echo');

cd(wdir)

%% Build reference


% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if isequal(exist(dirstruct.tikzdir,'dir'),7)
    cd(dirstruct.tikzdir)
end

matlab2tikz('myfile.tex','standalone',true);

% copyfile('Makefile',dirstruct.wdir)

tic
[status,cmdout] = system('make','-echo');
toc

cd(dirstruct.wdir)
winopen(dirstruct.tikzdir)



 
