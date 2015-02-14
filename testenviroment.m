% The MIT License (MIT)
% 
% Copyright (c) 2015 AdrianoRuseler
% 
% Permission is hereby granted, free of charge, to any person obtaining a copy
% of this software and associated documentation files (the "Software"), to deal
% in the Software without restriction, including without limitation the rights
% to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
% copies of the Software, and to permit persons to whom the Software is
% furnished to do so, subject to the following conditions:
% 
% The above copyright notice and this permission notice shall be included in all
% copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
% IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
% FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
% AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
% LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
% OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
% SOFTWARE.



%% Find if latex and make are available

% Gets system enviroment vaiable PATH
pathsys = strsplit(getenv('PATH'),';'); % Splits the line with the delimiter ';'
wdir=pwd; % gets working directory

for p=1:length(pathsys)
  cd(pathsys{p}) % changes to each PATH 
  list_exe{p} =cellstr(ls('*.exe')); % Finds all *.exe binaries files   
end
cd(wdir); % Returns to working dir;


%% Test GNU make and Latex intallation
clc % clears command windos
disp('************************ Test GNU make ****************************')
disp(' ')
[status,cmdout] = system('make -version'); % verifies if GNU make is present
if ~status
    disp(cmdout)   
    disp('<a href = " http://www.gnu.org/software/make/manual/make.html">GNU make</a>')
    disp(' ')
else
    disp('Install GNU make (MinGW MSYS) and set System Enviroment Variables')
    disp('PATH to point bin directory (ex: C:\msys\1.0\bin)')    
    disp('<a href = "http://downloads.sourceforge.net/mingw/MSYS-1.0.11.exe">http://downloads.sourceforge.net/mingw/MSYS-1.0.11.exe</a>')
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
     disp('Install a implementation of TeX and related programs (ex: MiKTeX)')
     disp('and set System Enviroment Variables PATH to point bin directory')
     disp('(ex: C:\Program Files\MiKTeX 2.9\miktex\bin\x64)')
     disp('<a href = "http://miktex.org/download">http://miktex.org/download</a>')
end

disp('***************************  END **********************************')




%% Single matlab2tikz test 96 max



wdir=pwd; % Get current directory
[folder, name, ext] = fileparts(which('matlab2tikz_acidtest')); % Change directory

cd(folder)
ok=0;
er=0;
for t=1:96
    matlab2tikz_acidtest(t)
    cd tex
    [status,cmdout] = system('make','-echo');
    
    if status % error
        testERROR{er+1}=t;
        er=er+1;
    else
        testOK{ok+1}=t;
        ok=ok+1;
        
        copyfile('acid.pdf',['acid_test' num2str(t) '.pdf'])
    end
    
    % winopen('acid.pdf')
     cd(folder)
end
cd(wdir)

%% 






    