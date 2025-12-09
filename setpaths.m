
% =========================================================================
% ***
% *** This code is intended to verify all m files required to properly run this
% *** pakage;
% ***
% *** status = 0; % All fine
% *** status = 1; % Something got wrong
% ***

function status = setpaths()
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
addfolder{11}=[folder '\gecko2matlab']; % For GeckoCIRCUITS related functions


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

















