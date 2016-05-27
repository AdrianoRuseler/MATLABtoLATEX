

 %% Convert pdf to png
%  tic
%  [status,cmdout] = system('convert "tek0047full.pdf" "tek0047full.png"','-echo');
%  toc
%  
%  tic
%  command='convert -density 300 -depth 8 -quality 85 "tek0047full.pdf" "tek0047full.png"';
%  [status,cmdout] = system(command,'-echo');
%  toc % Elapsed time is 5364.397533 seconds.
%  
%  tic
%  command='convert -density 300  "tek0047full.pdf" "tek0047full.eps"';
%  [status,cmdout] = system(command,'-echo');
%  toc % Elapsed time is 5507.070117 seconds.
%  
%  
% [status,cmdout] = system('gswin64c -version','-echo'); % Verifies gs version
% 
%  tic
%   command='gswin64c -q -dNOPAUSE -dBATCH -sDEVICE=pngalpha -r300 -dEPSCrop -sOutputFile=tek0035full.png tek0035full.pdf';
%   [status,cmdout] = system(command,'-echo');
%   toc % Elapsed time is 5951.422537 seconds.
%  
%  

[status,cmdout] = system('convert ','-echo');


