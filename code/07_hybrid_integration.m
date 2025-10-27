% =========================================================
% Section 7: Hybrid Integration of LSTM and ANFIS
% =========================================================
% 
% Part of: Hybrid LSTM-ANFIS Control System for Magnetic Levitation
% Author: Shakila Praveen Rathnayake
% Contact: shakilabeta@gmail.com
% GitHub: github.com/shakilapr/hybrid-lstm-anfis-maglev-control
% 
% Description:
% This script implements section 7: hybrid integration of lstm and anfis.
% 
% Dependencies:
% - MATLAB R2020b or later
% - Deep Learning Toolbox (for LSTM sections)
% - Fuzzy Logic Toolbox (for ANFIS sections)
% 
% =========================================================

% ======================================
% Section 7: Hybrid Integration of LSTM and ANFIS
% ======================================

% 7.1 LSTM Prediction and Data Preparation

% Load LSTM trained network
load('lstm_net.mat', 'net_lstm');

% Full dataset for LSTM input
numSamples = size(data_inputs_lstm, 1);
fullInputsCell = cell(numSamples - sequence_length, 1);
for i = 1:(numSamples - sequence_length)
    fullInputsCell{i} = data_inputs_lstm(i:i+sequence_length-1, :)';
end

% Predict using LSTM
lstm_predictions = predict(net_lstm, fullInputsCell);

% Prepare hybrid dataset
hybrid_dataset = table(...
    data.Error(1:end-sequence_length), ...
    data.ErrorRate(1:end-sequence_length), ...
    lstm_predictions, ...
    data.ControlSignal(sequence_length+1:end), ...
    'VariableNames', {'Error', 'ErrorRate', 'LSTM_Prediction', 'ControlSignal'});

% Save the dataset
writetable(hybrid_dataset, 'hybrid_dataset.csv');
disp('Hybrid dataset saved as "hybrid_dataset.csv".');
