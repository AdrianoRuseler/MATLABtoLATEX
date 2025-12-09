% =========================================================================
% *** 
% ***  
% ***  
% =========================================================================

% Load from GeckoCIRCUITS
% checkdirstruct();
setpaths();

% Clear all data
clear all 
clc


% Read simulated data
GeckoData = gecko2matlab();

% Export to Simview
[status]=matlab2simview(GeckoData);

