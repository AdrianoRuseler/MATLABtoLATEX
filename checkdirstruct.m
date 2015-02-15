
function status = checkdirstruct()

% =========================================================================
% *** checkdirstruct
% ***  
% *** This code it intended to colect working directories in dirstruct
% variable
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
status = 0; % All good

wdir = pwd; % Updates actual working directory

[filefolder] = fileparts(which('checkdirstruct')); % Locate this file
dirstruct.root=[filefolder '\dirstruct'];
cd(dirstruct.root) % Change to dirstruct root directory

if exist('dirstruct.mat','file')% if dirstruct file exist, load it.
    load('dirstruct.mat')
    %     check if all folders exist
    dirnames = fieldnames(dirstruct); % find all dirs
    for d=1:length(dirnames)
        if isequal(exist(getfield(dirstruct, dirnames{d}),'dir'),7)
            continue
        else
            %             Invalid directory!! Ask for valid directory
            tdir=uigetdir(wdir,['Select Directory for ' dirnames{d}]);
            if isequal(tdir,0)
                disp('User selected Cancel')
                status = 1; % Return 
                return
            end
        end        
    end    
    disp(dirstruct)
    cd(wdir) 
    assignin('base','dirstruct',dirstruct); % Well, is this really necessary?
    return
end


% Just create default dir structure
dirstruct.wdir = wdir; % Actual working directory
dirstruct.defaultdir=[dirstruct.root '\defaultdir'];
dirstruct.psimdir=[dirstruct.root '\psimdir'];
dirstruct.scopedir=[dirstruct.root '\scopedir'];
dirstruct.tikzdir=[dirstruct.root '\tikzdir'];

disp(dirstruct) % Displays directory structure
 
assignin('base','dirstruct',dirstruct); % Well, is this really necessary?

save('dirstruct.mat', 'dirstruct') % Save dirstruct 

cd(dirstruct.wdir) % change to working directory

 