% Junkcode van damme
%

% Just a collection of maybe some usefull code

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

if ~isfield(dirstruct,'simulatedir') % Check if directory for simulations is defined
    dirstruct.simulatedir=uigetdir(pwd,'Select directory for PSIM simulations');
    if isequal(dirstruct.simulatedir,0)
        disp('User selected Cancel')        
        return
    end
end



% FFTSCOPEdata= power_fftscope
if isfield(dirstruct,'fftscopestorage')
    if isequal(exist(dirstruct.fftscopestorage,'dir'),7)
        cd(dirstruct.fftscopestorage)
    end
else
    fftscopestorage = uigetdir(pwd,'Folder to store fftscope tikz file');
    if isequal(fftscopestorage,0)
        return
    end
    dirstruct.fftscopestorage=fftscopestorage;
    assignin('base','dirstruct',dirstruct);
    cd(dirstruct.root)
    save('dirstruct.mat','dirstruct')
    cd(dirstruct.fftscopestorage)
end

%%

h5create	Create HDF5 data set
h5disp	Display contents of HDF5 file
h5info	Return information about HDF5 file
h5read	Read data from HDF5 data set
h5readatt	Read attribute from HDF5 file
h5write	Write to HDF5 data set
h5writeatt	Write HDF5 attribute