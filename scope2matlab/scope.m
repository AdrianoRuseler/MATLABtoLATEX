% =========================================================================
%  SCOPE INDEX file
%   
%   
% =========================================================================
% 
%  The MIT License (MIT)
%  
%  Copyright (c) 2015 AdrianoRuseler
%  
%  Permission is hereby granted, free of charge, to any person obtaining a copy
%  of this software and associated documentation files (the Software), to deal
%  in the Software without restriction, including without limitation the rights
%  to use, copy, modify, merge, publish, distribute, sublicense, andor sell
%  copies of the Software, and to permit persons to whom the Software is
%  furnished to do so, subject to the following conditions
%  
%  The above copyright notice and this permission notice shall be included in all
%  copies or substantial portions of the Software.
%  
%  THE SOFTWARE IS PROVIDED AS IS, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
%  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
%  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
%  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
%  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
%  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
%  SOFTWARE.
% 
% =========================================================================


%% Load scope data points

SCOPEdata = csv2struct();


%% Load settings file

SCOPEdata = set2struct();


%% Load all at once
 [status, dirstruct]= checkdirstruct(); % Well, check this out
 
  [csvfilename, csvpathname] = uigetfile('*.csv', 'Select scope data aquisition', 'MultiSelect', 'off');
    if isequal(csvfilename,0)
        disp('User selected Cancel')
        return
    end
    SCOPEcsv=[csvpathname csvfilename];
[pathstr, name, ext] = fileparts(SCOPEcsv);

SCOPEdata = csv2struct([pathstr '\' name '.csv']);
SCOPEdata = set2struct([pathstr '\' name '.set']);

%% Plot scope data to tikz

scope2tikz(SCOPEdata)