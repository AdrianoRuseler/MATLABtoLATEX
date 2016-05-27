
% =========================================================================
% *** compile2tikz
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


function compile2tikz(filename,papertype,FIGUREHANDLE)

% figurescale
% usesiunitx? true false
% Loads directory structure
try
    dirstruct = evalin('base', 'dirstruct'); % Load dirstruct from base workspace
catch
    [status, dirstruct]= checkdirstruct(); % Well, check this out
end

if isequal(exist(dirstruct.tikzdir,'dir'),7)
    cd(dirstruct.tikzdir)
end

if nargin <3  %
    FIGUREHANDLE=gcf;
end

if nargin <2  %
%         papertype 
    papertype='A5';   
end


if nargin <1  %
    [texfilename, texpathname] = uiputfile('*.tex', 'Save tex file as');
    if isequal(txtfilename,0)
        disp('User selected Cancel')
        return
    end
    filename=[texpathname texfilename];
end

% axoptions={'scaled y ticks = false',...
%            'y tick label style={/pgf/number format/.cd, fixed, fixed zerofill,precision=3}'};
       
       
switch papertype
    case 'A4'
        widthCHAR='512pt';
        %             heightCHAR='3.566in'; % Is defined by matlab2tikz
        extraCodestr=sprintf([  '\\usepackage{siunitx}\n',...
            '\\usepackage{anyfontsize}\n',...
            '\\renewcommand{\\normalsize}{\\fontsize{9pt}{11pt}}\n',...
            '\\pgfplotsset{/pgf/number format/use comma}\n',...
            '\\renewcommand{\\familydefault}{ptm} \n',...
            '\\renewcommand{\\sfdefault}{cmss} \n',...
            '\\renewcommand{\\rmdefault}{cmr} \n',...
            '\\renewcommand{\\ttdefault}{cmtt} \n']);
    case 'A4d' % A4 double column 
        widthCHAR='248pt';
        %             heightCHAR='3.566in';
        extraCodestr=sprintf([  '\\usepackage{siunitx}\n',...
            '\\usepackage{anyfontsize}\n',...
            '\\renewcommand{\\normalsize}{\\fontsize{9pt}{11pt}}\n',...
            '\\pgfplotsset{/pgf/number format/use comma}\n',...
            '\\renewcommand{\\familydefault}{ptm} \n',...
            '\\renewcommand{\\sfdefault}{cmss} \n',...
            '\\renewcommand{\\rmdefault}{cmr} \n',...
            '\\renewcommand{\\ttdefault}{cmtt} \n']);
    case 'A5'
        widthCHAR='307pt';
        %             heightCHAR='3.566in';
        extraCodestr=sprintf([  '\\usepackage{siunitx}\n',...
            '\\usepackage{anyfontsize}\n',...
            '\\renewcommand{\\normalsize}{\\fontsize{9.5pt}{10.5pt}}\n',...
            '\\pgfplotsset{/pgf/number format/use comma}\n',...
            '\\renewcommand{\\familydefault}{cmr} \n',...
            '\\renewcommand{\\sfdefault}{cmss} \n',...
            '\\renewcommand{\\rmdefault}{cmr} \n',...
            '\\renewcommand{\\ttdefault}{cmtt} \n']);
    case 'A5d' % A5 double column 
        widthCHAR='148pt';
        %             heightCHAR='3.566in';
        extraCodestr=sprintf([  '\\usepackage{siunitx}\n',...
            '\\usepackage{anyfontsize}\n',...
            '\\pgfplotsset{/pgf/number format/use comma}\n',...
            '\\renewcommand{\\normalsize}{\\fontsize{9.5pt}{10.5pt}}\n',...
            '\\renewcommand{\\familydefault}{cmr} \n',...
            '\\renewcommand{\\sfdefault}{cmss} \n',...
            '\\renewcommand{\\rmdefault}{cmr} \n',...
            '\\renewcommand{\\ttdefault}{cmtt} \n']);
        
    otherwise
        widthCHAR='307pt';
        extraCodestr=sprintf([  '\\usepackage{siunitx}\n',...
            '\\usepackage{anyfontsize}\n',...
            '\\pgfplotsset{/pgf/number format/use comma}\n',...
            '\\renewcommand{\\normalsize}{\\fontsize{9.5pt}{10.5pt}}\n',...
            '\\renewcommand{\\familydefault}{cmr} \n',...
            '\\renewcommand{\\sfdefault}{cmss} \n',...
            '\\renewcommand{\\rmdefault}{cmr} \n',...
            '\\renewcommand{\\ttdefault}{cmtt} \n']);
end

%  \renewcommand{\normalsize}{\fontsize{15pt}{18pt}}
% \renewcommand{\defaultfont}{\usefont{T1}{cmr}{bx}{n}}
% \renewcommand{\normalsize}{\fontsize{10.5pt}{12pt}}


                    
  % Settings for siunitx package
% \sisetup{scientific-notation = fixed, fixed-exponent = 0, round-mode = places,round-precision = 2,output-decimal-marker = {,}}
                    
%  encoding: T1, family:cmr, series: m, shape: n, size: 9.5, baseline: 10.5pt

% tikzoptionsstr=sprintf('\\tikzstyle{every node}=[font=\\fontsize{9.5}{10.5}, text=\\usefont{T1}{cmr}{bx}{n}\n');   


% ipp = ipp.addParamValue(ipp, 'extraCode', {}, @isCellOrChar);
% ipp = ipp.addParamValue(ipp, 'extraCodeAtEnd', {}, @isCellOrChar);
% ipp = ipp.addParamValue(ipp, 'extraAxisOptions', {}, @isCellOrChar);
% ipp = ipp.addParamValue(ipp, 'extraTikzpictureOptions', {}, @isCellOrChar);

[pathstr, name, ext] = fileparts(filename);
switch ext % Make a simple check of file extensions
    case '.tex'
        % Good to go!!
    otherwise
        disp('We expect an *.tex file.')
        cd(dirstruct.wdir)
        return
end

% matlab2tikz([name ext],'standalone',true,'width','showInfo',false,'figurehandle',FIGUREHANDLE);

% matlab2tikz([name ext],'standalone',true,'width',widthCHAR,'showInfo', false,'figurehandle',FIGUREHANDLE,...
%     'extraCode',extraCodestr,'extraTikzpictureOptions',tikzoptionsstr);

matlab2tikz([name ext],'standalone',true,'width',widthCHAR,'showInfo', false,'figurehandle',FIGUREHANDLE,...
    'extraCode',extraCodestr);

% 
% matlab2tikz('filehandle',FILEHANDLE,...) stores the LaTeX code in the file
%     referenced by FILEHANDLE. (default: [])
%  
%     matlab2tikz('figurehandle',FIGUREHANDLE,...) explicitly specifies the
%     handle of the figure that is to be stored. (default: gcf)

%     matlab2tikz('strict',BOOL,...) tells matlab2tikz to adhere to MATLAB(R)
%     conventions wherever there is room for relaxation. (default: false)
%  
%     matlab2tikz('strictFontSize',BOOL,...) retains the exact font sizes
%     specified in MATLAB for the TikZ code. This goes against normal LaTeX
%     practice. (default: false)
    
    
    
% copyfile('Makefile',dirstruct.wdir)

tic
    [status,cmdout] = system('make','-echo');
toc

cd(dirstruct.wdir)

winopen(dirstruct.tikzdir)

%% 




% [status,cmdout] = system('latexindent -o CH00.tex CH00_2.tex','-echo')



