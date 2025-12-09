% =========================================================================
% *** savetxtfile - Save simview txt file
% ***  
% =========================================================================

function status=savetxtfile(txtdata, txtheader, txtfilename)

[pathstr, txtname, ext] = fileparts(txtfilename);

wdir=pwd;

if isequal(exist(pathstr,'dir'),7)
    cd(pathstr)
end

% Save csv file
filemane = [txtname '.txt'];
[fileID,errmsg]  = fopen(filemane,'w','n','UTF-8');

if fileID<0
    disp(errmsg)
    return;
end

fprintf(fileID,'%s\r\n',txtheader); % Begin axis
fclose(fileID); % Close it.

% write data
% disp('Data size to record:')
% size(csvdata)
% dlmwrite('myFile.txt',M,'delimiter','\t','precision',15)

% 15.550297613166409  .15f

disp(['Saving ' txtname '.txt data file...'])
tic
dlmwrite(filemane, txtdata,'delimiter',' ','precision',6,'-append','newline','pc');
toc
cd(wdir)


status=0; % if everything its ok

