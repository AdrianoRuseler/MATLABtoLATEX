
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2017 AdrianoRuseler
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

function [status,dirstruct] = checkdirstruct()

status = 0; % All good

wdir = pwd; % Updates actual working directory

[filefolder] = fileparts(which('checkdirstruct')); % Locate this file
dirstruct.root=[filefolder '\dirstruct'];
cd(dirstruct.root) % Change to dirstruct root directory

% if exist('dirstruct.mat','file')% if dirstruct file exist, load it.
%     load('dirstruct.mat')
%     %     check if all folders exist
%     dirnames = fieldnames(dirstruct); % find all dirs
%     for d=1:length(dirnames)
%         dirname=getfield(dirstruct, dirnames{d});
%         if exist(dirname,'dir')
%             continue
%         else
%             disp([ dirname ' NOT FOUND!'])
%             dirstruct = rmfield(dirstruct,dirnames{d}); % Remove field with invalid path
%         end
%     end
%     disp(dirstruct)
%     cd(wdir)
%     assignin('base','dirstruct',dirstruct); % Assign dirs structure in workspace
%     return    
% end

% Just create default dir structure
dirstruct.wdir = wdir; % Actual working directory
dirstruct.defaultdir=[dirstruct.root '\defaultdir'];
dirstruct.psimdir=[dirstruct.root '\psimdir'];
dirstruct.scopedir=[dirstruct.root '\scopedir'];
dirstruct.tikzdir=[dirstruct.root '\tikzdir'];
dirstruct.fftscopedir=[dirstruct.root '\fftscopedir'];
dirstruct.bodedir=[dirstruct.root '\bodedir'];
dirstruct.plecsdir=[dirstruct.root '\plecsdir'];
dirstruct.geckodir=[dirstruct.root '\geckodir'];

disp(' ')
disp('******************* Directory structure ***************************')
disp(dirstruct) % Displays directory structure
 
assignin('base','dirstruct',dirstruct); % Well, is this really necessary?

save('dirstruct.mat', 'dirstruct') % Save dirstruct 

cd(dirstruct.wdir) % change to working directory

 