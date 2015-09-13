
% =========================================================================
% *** compile2tikz
% ***  
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


function compile2tikz(filename)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if isequal(exist(dirstruct.tikzdir,'dir'),7)
    cd(dirstruct.tikzdir)
end

if nargin <1  %
    [texfilename, texpathname] = uiputfile('*.tex', 'Save tex file as');
    if isequal(txtfilename,0)
        disp('User selected Cancel')
        return
    end
    filename=[texpathname texfilename];
end


[pathstr, name, ext] = fileparts(filename);
switch ext % Make a simple check of file extensions
    case '.tex'
        % Good to go!!
    otherwise
        disp('We expect an *.tex file.')
        cd(dirstruct.wdir)
        return
end


matlab2tikz([name ext],'standalone',true,'showInfo', false);

% copyfile('Makefile',dirstruct.wdir)

tic
[status,cmdout] = system('make','-echo');
toc

cd(dirstruct.wdir)

winopen(dirstruct.tikzdir)


