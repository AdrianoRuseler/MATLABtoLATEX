
% =========================================================================
% ***
% *** The MIT License (MIT)
% *** 
% *** Copyright (c) 2017 AdrianoRuseler
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

function PSIMdata = simview2matlab(PSIMdata)

% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end



if ~isfield(PSIMdata.PSIMCMD,'inifile')
    disp('Field inifile not Found!')
    [PSIMFile, PSIMPath] = uigetfile('*.ini','Select the SIMVIEW *.ini file','MultiSelect', 'off');   
    if isequal(PSIMFile,0)
        disp('User selected Cancel')
        return
    end
    PSIMdata.PSIMCMD.inifile=[PSIMPath PSIMFile];
else
    if ~exist(PSIMdata.PSIMCMD.inifile,'file')
         disp('File inifile not Found!')
        [PSIMFile, PSIMPath] = uigetfile('*.ini','Select the SIMVIEW *.ini file','MultiSelect', 'off');          
        if isequal(PSIMFile,0)
            disp('User selected Cancel')
            return
        end
        PSIMdata.PSIMCMD.inifile=[PSIMPath PSIMFile];
    end    
end



[pathstr, name, ext] = fileparts(PSIMdata.PSIMCMD.inifile);
switch ext % Make a simple check of file extensions
    case '.ini'
        % Good to go!!
    otherwise
        disp('Save simview Settings and load the *.ini file.')
        cd(dirstruct.wdir)
        return
end

% Make name valid in MATLAB
name = matlab.lang.makeValidName(name);
name = strrep(name, '_', ''); % Removes umderscore


inidata = ini2struct(PSIMdata.PSIMCMD.inifile);  
% PSIMdata.simview.inidata = inidata;
tic
%% Creates the simview structure
simview.main.xaxis=inidata.x1main.xaxis;
simview.main.numscreen=str2double(inidata.x1main.numscreen);
simview.main.xfrom= str2double(inidata.x1main.xfrom); % x limit
simview.main.xto= str2double(inidata.x1main.xto);
simview.main.scale= str2double(inidata.x1main.scale);
simview.main.xinc= str2double(inidata.x1main.xinc);
simview.main.fft= logical(str2double(inidata.x1main.fft));
simview.main.default= logical(str2double(inidata.x1main.default));

simview.view.fontheight=str2double(inidata.x1view.fontheight);
simview.view.bkcolor=str2double(inidata.x1view.bkcolor);
simview.view.fontweight=str2double(inidata.x1view.fontweight);
simview.view.grid=logical(str2double(inidata.x1view.grid));
simview.view.fgcolor=str2double(inidata.x1view.fgcolor);
simview.view.fontitalic=str2double(inidata.x1view.fontitalic);
simview.view.gridcolor=str2double(inidata.x1view.gridcolor);
simview.view.hideaxistext=logical(str2double(inidata.x1view.hideaxistext));


for s=0:str2double(inidata.x1main.numscreen)-1 % Screens Loop
    eval(['simview.screen' num2str(s) '.scale=str2double(inidata.x1screen' num2str(s) '.scale);'])
    eval(['simview.screen' num2str(s) '.yinc=str2double(inidata.x1screen' num2str(s) '.yinc);'])
    eval(['simview.screen' num2str(s) '.default=logical(str2double(inidata.x1screen' num2str(s) '.default));'])
    eval(['simview.screen' num2str(s) '.yfrom=str2double(inidata.x1screen' num2str(s) '.yfrom);'])
    eval(['simview.screen' num2str(s) '.curvecount=str2double(inidata.x1screen' num2str(s) '.curvecount);'])
    eval(['simview.screen' num2str(s) '.db=logical(str2double(inidata.x1screen' num2str(s) '.db));'])
    eval(['simview.screen' num2str(s) '.auto=logical(str2double(inidata.x1screen' num2str(s) '.auto));'])
    eval(['simview.screen' num2str(s) '.yto=str2double(inidata.x1screen' num2str(s) '.yto);'])
    
    % Curves Loop
    for c=0:str2double(eval(['inidata.x1screen' num2str(s) '.curvecount']))-1
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.formula=inidata.x1screen' num2str(s) '.curve_'  num2str(c) '_formula;'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.label=inidata.x1screen' num2str(s) '.curve_'  num2str(c) '_label;'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.symbol=str2double(inidata.x1screen' num2str(s) '.curve_'  num2str(c) '_symbol);'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.source=str2double(inidata.x1screen' num2str(s) '.curve_'  num2str(c) '_source);'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.connect=str2double(inidata.x1screen' num2str(s) '.curve_'  num2str(c) '_connect);'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.thickness=str2double(inidata.x1screen' num2str(s) '.curve_'  num2str(c) '_thickness);'])
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.color=str2double(inidata.x1screen' num2str(s) '.curve_'  num2str(c) '_color);'])   
    end
end

%%

xfrom = simview.main.xfrom;
xto = simview.main.xto;

xdata=PSIMdata.time(PSIMdata.time>=xfrom&PSIMdata.time<=xto);
if isempty(xdata)
    warndlg('Vetor xdata vazio!! Salve o arquivo *.ini via SINVIEW!!','!! Warning !!')
end
simview.main.xdata=xdata; % save time data (x axis data)

for i=1:length(PSIMdata.signals) % Associa dados a cada variável de medição
    ydata = PSIMdata.signals(:,i).values(PSIMdata.time>=xfrom&PSIMdata.time<=xto);
    if isempty(xdata)
        warndlg('Vetor ydata vazio!! Salve o arquivo *.ini via SINVIEW!!','!! Warning !!')
    end
    assignin('base',PSIMdata.signals(i).label,ydata); % Cada leitura vira uma variável
end

% plot(xdata,ydata)
% Evaluate screen formula
for s=0:simview.main.numscreen-1 % Screens Loop
    for c=0:eval(['simview.screen' num2str(s) '.curvecount'])-1 % Curves Loop
        formula{s+1,c+1}= eval(['simview.screen' num2str(s) '.curve' num2str(c) '.formula']);
        if verLessThan('matlab', '8.2.0')
            form = genvarname(formula{s+1,c+1});
            modified=1; % Just force update
        else
            [form, modified] = matlab.lang.makeValidName(formula{s+1,c+1},'ReplacementStyle','delete'); % Problem here for minus signal
        end          
        formuladata=evalin('base',form);        
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.data=formuladata;'])        
        ymean=mean(formuladata);
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.ymean=ymean;'])
        ymax=max(formuladata);
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.ymax=ymax;'])
        ymin=min(formuladata);
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.ymin=ymin;'])    
        ydelta=abs(ymax-ymin);
        eval(['simview.screen' num2str(s) '.curve' num2str(c) '.ydelta=ydelta;']) 
    end
end

% Clear variables from workspace
% disp('Clear variables from workspace:')
for i=1:length(PSIMdata.signals)
    evalin('base', ['clear ' PSIMdata.signals(i).label])     
end

PSIMdata.simview=simview;
PSIMdata.simview.inidata=inidata;

toc


