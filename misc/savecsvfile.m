% =========================================================================
% *** savecsvfile
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

function status=savecsvfile(csvdata, csvheader, csvfilename)

[pathstr, csvname, ext] = fileparts(csvfilename);

wdir=pwd;

if isequal(exist(pathstr,'dir'),7)
    cd(pathstr)
end

% Save csv file
filemane = [csvname '.csv'];
[fileID,errmsg]  = fopen(filemane,'w','n','UTF-8');

if fileID<0
    disp(errmsg)
    resturn
end

fprintf(fileID,'%s\r\n',csvheader); % Begin axis
fclose(fileID); % Close it.

% write data
% disp('Data size to record:')
% size(csvdata)

dlmwrite(filemane, csvdata, '-append','newline','pc');

cd(wdir)


status=0; % if everything its ok

