% =========================================================
% Section 5: ANFIS Model Development
% =========================================================
% 
% Part of: Hybrid LSTM-ANFIS Control System for Magnetic Levitation
% Author: Shakila Praveen Rathnayake
% Contact: shakilabeta@gmail.com
% GitHub: github.com/shakilapr/hybrid-lstm-anfis-maglev-control
% 
% Description:
% This script implements section 5: anfis model development.
% 
% Dependencies:
% - MATLAB R2020b or later
% - Deep Learning Toolbox (for LSTM sections)
% - Fuzzy Logic Toolbox (for ANFIS sections)
% 
% =========================================================

% =====================================
% Section 5: ANFIS Model Development
% =====================================

% Load ANFIS prepared data
load('anfis_prepared_data.mat');

% Define figure folder for this section
figureFolder = 'figures/Section5';
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

% Prepare input and output data
inputs = trainData_ANFIS(:, 1:2); % Error and ErrorRate (non-normalized)
outputs = trainData_ANFIS(:, 3);  % ControlSignal (non-normalized)

% Number of membership functions per input
numMFs_input1 = 7; % Set 7 membership functions for input 1 (Error)
numMFs_input2 = 2; % Set 2 membership functions for input 2 (ErrorRate)

% Generate initial FIS structure using genfis1
fis = genfis1([inputs(:,1) inputs(:,2) outputs], [numMFs_input1 numMFs_input2], 'gbellmf');

% Visualize initial membership functions
figure;
subplot(2,1,1);
plotmf(fis, 'input', 1);
title('Initial Membership Functions for Error');
subplot(2,1,2);
plotmf(fis, 'input', 2);
title('Initial Membership Functions for ErrorRate');
figureFileName = 'Figure1_InitialMembershipFunctions.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Save the initial FIS
writeFIS(fis, 'anfis_initial.fis');
