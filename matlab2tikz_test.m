
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



 
