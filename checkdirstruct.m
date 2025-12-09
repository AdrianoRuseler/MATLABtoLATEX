
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

 