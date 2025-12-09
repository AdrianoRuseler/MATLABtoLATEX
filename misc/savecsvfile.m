% =========================================================================
% *** savecsvfile
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
    return;
end

fprintf(fileID,'%s\r\n',csvheader); % Begin axis
fclose(fileID); % Close it.

% write data
% disp('Data size to record:')
% size(csvdata)
disp(['Saving ' csvname '.csv data file...'])
tic
dlmwrite(filemane, csvdata, '-append','newline','pc');
toc

cd(wdir)


status=0; % if everything its ok

