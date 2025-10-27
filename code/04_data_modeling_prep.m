% =========================================================
% Section 4: Data Preparation for Modeling
% =========================================================
% 
% Part of: Hybrid LSTM-ANFIS Control System for Magnetic Levitation
% Author: Shakila Praveen Rathnayake
% Contact: shakilabeta@gmail.com
% GitHub: github.com/shakilapr/hybrid-lstm-anfis-maglev-control
% 
% Description:
% This script implements section 4: data preparation for modeling.
% 
% Dependencies:
% - MATLAB R2020b or later
% - Deep Learning Toolbox (for LSTM sections)
% - Fuzzy Logic Toolbox (for ANFIS sections)
% 
% =========================================================

% =====================================
% Section 4: Data Preparation for Modeling
% =====================================

% Define figure folder for this section
figureFolder = 'figures/Section4';
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

% 4.1 LSTM Data Preparation

% Define input and output features for LSTM
input_features_lstm = {'Error', 'ErrorRate', 'Feedback', 'GeneratedSignal'};
target_feature_lstm = 'ControlSignal';

% Extract inputs and target
data_inputs_lstm = data{:, input_features_lstm};
data_target_lstm = data{:, target_feature_lstm};

% Define sequence length
sequence_length = 10;
num_samples_lstm = size(data_inputs_lstm, 1) - sequence_length;

% Initialize sequences and targets
X_seq_lstm = zeros(num_samples_lstm, sequence_length, length(input_features_lstm));
y_seq_lstm = zeros(num_samples_lstm, 1);

% Create sequences
for i = 1:num_samples_lstm
    X_seq_lstm(i, :, :) = data_inputs_lstm(i:i+sequence_length-1, :);
    y_seq_lstm(i) = data_target_lstm(i+sequence_length);
end

% Split into training and testing sets
train_ratio = 0.8;
train_size_lstm = floor(train_ratio * num_samples_lstm);

X_train_lstm = X_seq_lstm(1:train_size_lstm, :, :);
y_train_lstm = y_seq_lstm(1:train_size_lstm);
X_test_lstm = X_seq_lstm(train_size_lstm+1:end, :, :);
y_test_lstm = y_seq_lstm(train_size_lstm+1:end);

% Convert to cell arrays for LSTM input
trainInputsCell_lstm = cell(size(X_train_lstm, 1), 1);
for i = 1:size(X_train_lstm, 1)
    trainInputsCell_lstm{i} = squeeze(X_train_lstm(i, :, :))';
end

testInputsCell_lstm = cell(size(X_test_lstm, 1), 1);
for i = 1:size(X_test_lstm, 1)
    testInputsCell_lstm{i} = squeeze(X_test_lstm(i, :, :))';
end

% Validate training and testing split
figure;
pie([train_size_lstm, num_samples_lstm - train_size_lstm], {'Training Data', 'Testing Data'});
title('Training vs Testing Data Split');
figureFileName = 'Figure1_TrainTestSplit.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Compare target distributions
figure;
subplot(1,2,1);
histogram(y_train_lstm, 50);
title('Training Data Target Distribution');
xlabel('Control Signal');
ylabel('Frequency');

subplot(1,2,2);
histogram(y_test_lstm, 50);
title('Testing Data Target Distribution');
xlabel('Control Signal');
ylabel('Frequency');

figureFileName = 'Figure2_TargetDistribution_TrainTest.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Visualize sample sequences
figure;
for i = 1:3 % Plot first 3 sequences
    seqData = squeeze(X_train_lstm(i, :, :));
    for j = 1:length(input_features_lstm)
        subplot(length(input_features_lstm),1,j);
        plot(seqData(:, j));
        title(['Sequence ', num2str(i), ' - ', input_features_lstm{j}]);
        ylabel(input_features_lstm{j});
    end
    xlabel('Time Steps');
    figureFileName = ['Figure3_SequenceVisualization_', num2str(i), '.png'];
    saveas(gcf, fullfile(figureFolder, figureFileName));
    close(gcf);
end

% Save LSTM prepared data
save('lstm_prepared_data.mat', 'trainInputsCell_lstm', 'y_train_lstm', 'testInputsCell_lstm', 'y_test_lstm', 'train_size_lstm', 'sequence_length', 'input_features_lstm');
