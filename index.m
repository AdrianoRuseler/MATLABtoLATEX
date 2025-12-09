% =========================================================================
% *** INDEX file
% *** Sets and tests the MATLAB enviroment for using this pakage
% *** Some examples are tested

clc % Lets clear some junk output in comand window
%% Lets test the MATLAB enviroment 
status = testenviroment();
% status = 0; % All fine
% status = 1; % Something got wrong
disp(' ')
if status
    disp('Something got wrong! See list above for more details!')
else
    disp('System enviroment seems to be OK!')
end
disp(' ')

%% PSIM 




%% Lets plot some figures

[TEK0003] = csv2struct();

power_fftscope



