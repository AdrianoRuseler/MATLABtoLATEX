% =========================================================================
% *** 
% ***  
% ***  
% =========================================================================

% Load from PLECS
checkdirstruct();

clear all 
% Read simulated data
PLECSdata = plecs2matlab();

% PSIMdata = csv2matlab();

matlab2simview(PSIMdata);