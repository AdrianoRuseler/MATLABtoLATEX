
function status=testenviroment()
% *** Test system enviroment for using this package
% *** status = 0; % All fine
% *** status = 1; % Something got wrong

status = 0; % Lets assume that we are good to go!

%% Test GNU make and Latex intallation
% clc % clears command windos
disp(' ')
disp('*********************  Testing MATLAB enviroment ******************')
disp(' ')
disp('************************ Test GNU make ****************************')
disp(' ')
[status,cmdout] = system('make -version'); % verifies if GNU make is present
if ~status
    disp(cmdout)   
    disp('<a href = " http://www.gnu.org/software/make/manual/make.html">GNU make</a>')
    disp(' ')
else
    status = xor(status,1); % Well, something is missed
    warning('make.exe is NOT present via system cmd')
    disp('Install GNU make (MinGW MSYS) and set System Enviroment Variables')
    disp('PATH to point bin directory (ex: C:\msys\1.0\bin)')    
    disp('<a href = "http://downloads.sourceforge.net/mingw/MSYS-1.0.11.exe">http://downloads.sourceforge.net/mingw/MSYS-1.0.11.exe</a>')
end


disp(' ')
disp('************************ Test GNU bash ****************************')
disp(' ')
[status,cmdout] = system('bash --version'); % verifies if GNU bash is present
if ~status
    disp(cmdout)   
    disp('<a href = " https://www.gnu.org/software/bash/manual/">GNU Bash manual</a>')
    disp(' ')
else
    status = xor(status,1); % Well, something is missed
    warning('bash.exe is NOT present via system cmd')
    disp('Install GNU bash (MinGW MSYS) and set System Enviroment Variables')
    disp('PATH to point bin directory (ex: C:\msys\1.0\bin)')    
    disp('<a href = "http://downloads.sourceforge.net/mingw/MSYS-1.0.11.exe">http://downloads.sourceforge.net/mingw/MSYS-1.0.11.exe</a>')
end

disp(' ')
disp('************************ Test Git ****************************')
disp(' ')
[status,cmdout] = system('git --version'); % verifies if GNU bash is present
if ~status
    disp(cmdout)   
    disp('<a href = "https://git-scm.com/docs">Git manual</a>')
    disp(' ')
else
    status = xor(status,1); % Well, something is missed
    warning('bash.exe is NOT present via system cmd')
    disp('Install Git and set System Enviroment Variables')
%     disp('PATH to point bin directory (ex: C:\Program Files\Git)')    
    disp('<a href = "https://git-scm.com/downloads">https://git-scm.com/downloads</a>')
end

% Verifica se � possivel executar o PSIM via CMD
disp(' ')
disp('************************ PSIM from CMD  ****************************')
disp(' ')
[status,cmdout] = system('PsimCmd');
disp(cmdout)

if status % Verifica se � possivel executar o PSIM pelo prompt do DOS
    warning('PsimCmd.exe not found!')
    [PSIMexeFile,PSIMPath] = uigetfile('PsimCmd.exe','Set PSIM install dir!');
    if isequal(PSIMexeFile,0)
        disp('User selected Cancel')
    else
        setenv('PATH', [getenv('PATH') [';' PSIMPath]]); % Coloca nas vari�veis de ambiente o local do PSIM
        [status,cmdout] = system('PsimCmd');
        disp(cmdout)
    end
end


disp('*************** Test Latex intallation - pdflatex.exe **************')
disp(' ')
% verifies if pdflatex is present via system cmd
[status,cmdout] = system('pdflatex -version'); 
if ~status
    disp(cmdout)    
    disp('<a href = "http://docs.miktex.org/manual/pdftex.html">miktex-pdftex</a>')
    disp(' ')
else
    status = xor(status,1); % Well, something is missed
     warning('pdflatex.exe is NOT present via system cmd')
     disp('Install a implementation of TeX and related programs (ex: MiKTeX)')
     disp('and set System Enviroment Variables PATH to point bin directory')
     disp('(ex: C:\Program Files\MiKTeX 2.9\miktex\bin\x64)')
     disp('<a href = "http://miktex.org/download">http://miktex.org/download</a>')
end

disp('*************** Test Latex intallation - lualatex.exe **************')
disp(' ')
% verifies if lualatex is present via system cmd
[status,cmdout] = system('lualatex -version');
if ~status
    disp(cmdout)
    disp('<a href = "http://www.luatex.org/documentation.html">Luatex documentation</a>')
    disp(' ')    
else
    status = xor(status,1); % Well, something is missed
     warning('lualatex.exe is NOT present via system cmd')
     disp('Install a implementation of TeX and related programs (ex: MiKTeX)')
     disp('and set System Enviroment Variables PATH to point bin directory')
     disp('(ex: C:\Program Files\MiKTeX 2.9\miktex\bin\x64)')
     disp('<a href = "http://miktex.org/download">http://miktex.org/download</a>')
end

disp('************** Test Latex intallation - xelatex.exe ****************')
disp(' ')
% verifies if xelatex is present via system cmd
[status,cmdout] = system('xelatex -version');
if ~status
    disp(cmdout)
    disp('<a href = "https://tug.org/xetex/">Xetex on the web</a>')
    disp(' ')  
    
else
    status = xor(status,1); % Well, something is missed
     warning('xelatex.exe is NOT present via system cmd')
     disp('Install a implementation of TeX and related programs (ex: MiKTeX)')
     disp('and set System Enviroment Variables PATH to point bin directory')
     disp('(ex: C:\Program Files\MiKTeX 2.9\miktex\bin\x64)')
     disp('<a href = "http://miktex.org/download">http://miktex.org/download</a>')
end

disp('************** Test Latex intallation - latex.exe ******************')
disp(' ')
% verifies if latex is present via system cmd
[status,cmdout] = system('latex -version');
if ~status
    disp(cmdout)
    disp('<a href = "http://docs.miktex.org/manual/pdftex.html">miktex-pdftex</a>')
    disp(' ')
else
    status = xor(status,1); % Well, something is missed
     warning('latex.exe is NOT present via system cmd')
     disp('Install a implementation of TeX and related programs (ex: MiKTeX)')
     disp('and set System Enviroment Variables PATH to point bin directory')
     disp('(ex: C:\Program Files\MiKTeX 2.9\miktex\bin\x64)')
     disp('<a href = "http://miktex.org/download">http://miktex.org/download</a>')
end


% =========================================================================
%% Is matlab2tikz present?

disp('******************   Is matlab2tikz present?  *********************')
disp(' ')

[folder, name, ext] = fileparts(which('matlab2tikz'));
if isempty(folder)
    statuspaths = setpaths(); % Sets and verifies all relevant folders and files
    status = xor(status,statuspaths);
else
    disp('matlab2tikz is present via MATLAB search path')
end
disp(' ')

%% checkdirstruct

[statusdir, dirstruct]=checkdirstruct();
status = xor(status,statusdir);

disp(' ')
disp('***************************  END **********************************')






    