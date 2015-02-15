% Junkcode van damme
%

% Just a collection of maybe some usefull code


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

%% Gets all *exe files available via system enviroment PATH.

% Gets system enviroment variable PATH
pathsys = strsplit(getenv('PATH'),';'); % Splits the line with the delimiter ';'

disp(pathsys) % Paths present in PATH enviroment variable


wdir=pwd; % gets working directory

for p=1:length(pathsys)
  cd(pathsys{p}) % changes to each PATH 
  list_exe{p} =cellstr(ls('*.exe')); % Finds all *.exe binaries files
  disp(list_exe{p})
end
cd(wdir); % Returns to working dir;


%%

h5create	Create HDF5 data set
h5disp	Display contents of HDF5 file
h5info	Return information about HDF5 file
h5read	Read data from HDF5 data set
h5readatt	Read attribute from HDF5 file
h5write	Write to HDF5 data set
h5writeatt	Write HDF5 attribute