% =========================================================================
% *** PSIM data file to MATLAB data struct
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

function PSIMdata = psim2struct(filename)

% Convert PSIM txt data to simulink struct data
 exist('dirstruct','var')
start_path=pwd;

if nargin <1
    
        if exist('last_path.mat','file')
        load('last_path.mat')
        if exist(last_path,'dir')
            cd(last_path)
        end
        end
    
    % fora do diretorio   {'*.txt';'*.fra';'*.*'}
    [filename, pathname] = uigetfile({'*.txt;*.fra;*.smv','PSIM Files (*.txt,*.fra,*.smv)'; ...
        '*.txt','PSIM-Data (*.txt)';'*.fra','AC-Sweed (*.fra)';...
        '*.smv','Frequency-Data (*.smv)';'*.*','All files'}, 'Pick an PSIM-file');
    if isequal(filename,0)
        disp('User selected Cancel')
        PSIMdata =[];
        return
        %     else
        %         [pathstr, name, ext, versn] = fileparts(filename);
        
    end
    
    
    [FileName_ini,PathName_ini] = uigetfile('*.ini','Select the ini file');
    if isequal(FileName_ini,0)
        disp('User selected Cancel')
        return
        %     else
        %         [pathstr, name, ext, versn] = fileparts(filename);
    end
  
    cd(start_path)
    inistrct = ini2struct( [PathName_ini FileName_ini]);  
    
    cd(pathname)
end

last_path=pwd;
%

%%  Carrega arquivo .txt
tic
fid = fopen(filename);
if fid==-1
    return
end
% BufSize -> Maximum string length in bytes -> 4095
tline = fgetl(fid);
[header] = strread(tline,'%s','delimiter',' ');

fstr='%f';
 for tt=2:length(header)
    fstr=[fstr '%f']; 
 end
 
M = cell2mat(textscan(fid,fstr));            
fclose(fid);



%% Convert data

 
 % Converte para o formato de estruturas utilizado pelo simulink.
 PSIMdata.time=single(M(:,1));
 PSIMdata.signals.values=single(M(:,2:end));
 PSIMdata.signals.dimensions=size(M,2)-1;
 
  for i=2:length(header)
     U = matlab.lang.makeValidName(header{i});
    PSIMdata.signals.label{i-1}=U;
  end
  
 PSIMdata.signals.title='';
 PSIMdata.signals.plotStyle=[0,0]; 
 PSIMdata.blockName='';
 

PSIMdata.main.xaxis=inistrct.main.xaxis;
PSIMdata.main.numscreen=str2double(inistrct.main.numscreen);
PSIMdata.main.xfrom= str2double(inistrct.main.xfrom); % x limit
PSIMdata.main.xto= str2double(inistrct.main.xto);
PSIMdata.main.scale= str2double(inistrct.main.scale);
PSIMdata.main.xinc= str2double(inistrct.main.xinc);
PSIMdata.main.fft= logical(str2double(inistrct.main.fft));
PSIMdata.main.default= logical(str2double(inistrct.main.default));

PSIMdata.view.fontheight=str2double(inistrct.view.fontheight);
PSIMdata.view.bkcolor=str2double(inistrct.view.bkcolor);
PSIMdata.view.fontweight=str2double(inistrct.view.fontweight);
PSIMdata.view.grid=logical(str2double(inistrct.view.grid));
PSIMdata.view.fgcolor=str2double(inistrct.view.fgcolor);
PSIMdata.view.fontitalic=str2double(inistrct.view.fontitalic);
PSIMdata.view.gridcolor=str2double(inistrct.view.gridcolor);
PSIMdata.view.hideaxistext=logical(str2double(inistrct.view.hideaxistext));


for s=0:str2double(inistrct.main.numscreen)-1 % Screens Loop
    %      eval(['PSIMdata.screen' num2str(s) '= inistrct.screen' num2str(s) ';'])
    
    eval(['PSIMdata.screen' num2str(s) '.scale=str2double(inistrct.screen' num2str(s) '.scale);'])
    eval(['PSIMdata.screen' num2str(s) '.yinc=str2double(inistrct.screen' num2str(s) '.yinc);'])
    eval(['PSIMdata.screen' num2str(s) '.default=logical(str2double(inistrct.screen' num2str(s) '.default));'])
    eval(['PSIMdata.screen' num2str(s) '.yfrom=str2double(inistrct.screen' num2str(s) '.yfrom);'])
    eval(['PSIMdata.screen' num2str(s) '.curvecount=str2double(inistrct.screen' num2str(s) '.curvecount);'])
    eval(['PSIMdata.screen' num2str(s) '.db=logical(str2double(inistrct.screen' num2str(s) '.db));'])
    eval(['PSIMdata.screen' num2str(s) '.auto=logical(str2double(inistrct.screen' num2str(s) '.auto));'])
    eval(['PSIMdata.screen' num2str(s) '.yto=str2double(inistrct.screen' num2str(s) '.yto);'])
    
    % Curves Loop
    for c=0:str2double(eval(['inistrct.screen' num2str(s) '.curvecount']))-1
        eval(['PSIMdata.screen' num2str(s) '.curve' num2str(c) '.formula=inistrct.screen' num2str(s) '.curve_'  num2str(c) '_formula;'])
        eval(['PSIMdata.screen' num2str(s) '.curve' num2str(c) '.label=inistrct.screen' num2str(s) '.curve_'  num2str(c) '_label;'])
        eval(['PSIMdata.screen' num2str(s) '.curve' num2str(c) '.symbol=str2double(inistrct.screen' num2str(s) '.curve_'  num2str(c) '_symbol);'])
        eval(['PSIMdata.screen' num2str(s) '.curve' num2str(c) '.source=str2double(inistrct.screen' num2str(s) '.curve_'  num2str(c) '_source);'])
        eval(['PSIMdata.screen' num2str(s) '.curve' num2str(c) '.connect=str2double(inistrct.screen' num2str(s) '.curve_'  num2str(c) '_connect);'])
        eval(['PSIMdata.screen' num2str(s) '.curve' num2str(c) '.thickness=str2double(inistrct.screen' num2str(s) '.curve_'  num2str(c) '_thickness);'])
        eval(['PSIMdata.screen' num2str(s) '.curve' num2str(c) '.color=str2double(inistrct.screen' num2str(s) '.curve_'  num2str(c) '_color);'])
    end 
    
end

cd(start_path)
save('last_path.mat', 'last_path')

toc

