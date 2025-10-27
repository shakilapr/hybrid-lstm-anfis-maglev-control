% =========================================================
% Section 6: LSTM Model Development
% =========================================================
% 
% Part of: Hybrid LSTM-ANFIS Control System for Magnetic Levitation
% Author: Shakila Praveen Rathnayake
% Contact: shakilabeta@gmail.com
% GitHub: github.com/shakilapr/hybrid-lstm-anfis-maglev-control
% 
% Description:
% This script implements section 6: lstm model development.
% 
% Dependencies:
% - MATLAB R2020b or later
% - Deep Learning Toolbox (for LSTM sections)
% - Fuzzy Logic Toolbox (for ANFIS sections)
% 
% =========================================================

% =====================================
% Section 6: LSTM Model Development
% =====================================

% Define figure folder for this section
figureFolder = 'figures/Section6';
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

% Load LSTM prepared data
load('lstm_prepared_data.mat');

% Define LSTM architecture
inputSize = length(input_features_lstm);
numHiddenUnits = 64;
numResponses = 1;

layers = [ ...
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits, 'OutputMode', 'sequence')
    dropoutLayer(0.2)
    lstmLayer(32, 'OutputMode', 'last')
    fullyConnectedLayer(numResponses)
    regressionLayer];
