function status = setpaths()
% =========================================================================
% ***
% *** This code is intended to verify all m files required to properly run this
% *** pakage;
% ***
% *** status = 0; % All fine
% *** status = 1; % Something got wrong
% ***
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
status = 0; % Lets assume that we are good to go!

%% Set all relevant folders in matlab serach path.
disp(' ')
disp('Setting all relevant folders in matlab search path...')
wdir=pwd; % gets actual working directory

%  which('setpaths') 
[folder, name, ext] = fileparts(which('setpaths')); 
 
% add to MATLAB search path 
addfolder{1}=folder;
addfolder{2}=[folder '\matlab2tikz\src'];
addfolder{3}=[folder '\matlab2tikz\test'];
addfolder{4}=[folder '\psim2matlab'];
addfolder{5}=[folder '\scope2matlab'];
addfolder{6}=[folder '\misc'];
addfolder{7}=[folder '\fftsope2tikz'];
addfolder{8}=[folder '\bode2tikz'];
addfolder{9}=[folder '\maxwell2matlab'];
addfolder{10}=[folder '\plecs2matlab']; % For PLECS related functions
addfolder{11}=[folder '\matlab-plot-big'];

for f=1:length(addfolder)
    if isequal(exist(addfolder{f},'dir'),7) % verifies if folder exist
        addpath(addfolder{f}) % add to MATLAB search path
        disp([addfolder{f} ' added to MATLAB search path!'])
        
        cd(addfolder{f})
          mfiles{f} =cellstr(ls('*.m'));       
        
    else
        disp([addfolder{f} ' Not found!!'])
    end
end

status = savepath;
if status
    disp('savepath error! Something got wrong!')
else
    disp('savepath successful saved folders MATLAB paths')
end

cd(wdir)


%% Verifies m files dependencies;
% This code is intended to verify all m files required to properly run this
% pakage;

nf=0; % Number of not found m files
for f=1:length(mfiles)
    for m=1:length(mfiles{f})
        if exist(mfiles{f}{m},'file') % is not empty or exist
            disp(' ')
            tic
            [fList{f}{m},pList{f}{m}] = matlab.codetools.requiredFilesAndProducts(mfiles{f}{m});
            disp(['Files dependencies for: ' mfiles{f}{m}])
            disp(fList{f}{m}')
            disp(' ')
            disp(['Programs dependencies for: ' mfiles{f}{m}])
            disp(pList{f}{m})
            disp(' ')
            
            for e=1:length(fList{f}{m})
                if exist(fList{f}{m}{e},'file')
                    disp([fList{f}{m}{e} ' Found!!' ])
                else
                    warning([fList{f}{m}{e} 'NOT Found!!' ])
                    notfound{nf+1}=fList{f}{m}{e};
                    nf=nf+1;
                end
            end
            toc
            disp('**************   ********************   ************')
        end
    end
end

if ~nf
    disp('All m files are present!')
end
    
status = nf;














