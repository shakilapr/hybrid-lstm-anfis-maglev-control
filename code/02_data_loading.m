% =========================================================
% Section 2: Data Loading and Exploration
% =========================================================
% 
% Part of: Hybrid LSTM-ANFIS Control System for Magnetic Levitation
% Author: Shakila Praveen Rathnayake
% Contact: shakilabeta@gmail.com
% GitHub: github.com/shakilapr/hybrid-lstm-anfis-maglev-control
% 
% Description:
% This script implements section 2: data loading and exploration.
% 
% Dependencies:
% - MATLAB R2020b or later
% - Deep Learning Toolbox (for LSTM sections)
% - Fuzzy Logic Toolbox (for ANFIS sections)
% 
% =========================================================

% =====================================
% Section 2: Data Loading and Exploration
% =====================================

% Clear workspace and close all figures
clear; clc; close all;

% Define figure folder for this section
figureFolder = 'figures/Section2';
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

% Define column names
columnNames = {'Error', 'ErrorRate', 'ControlSignal', 'Feedback', 'GeneratedSignal'};

% Load dataset
data = readtable('dataset.csv', 'ReadVariableNames', false);
data.Properties.VariableNames = columnNames;

% Display first few rows
disp('First 5 rows of the combined dataset:');
disp(head(data, 5));

% Summary statistics
disp('Summary statistics of the combined dataset:');
summary(data);

% Visualize data
figure;
subplot(5,1,1); plot(data.Error); title('Error'); ylabel('Error');
subplot(5,1,2); plot(data.ErrorRate); title('Error Rate'); ylabel('Error Rate');
subplot(5,1,3); plot(data.ControlSignal); title('Control Signal'); ylabel('Control Signal');
subplot(5,1,4); plot(data.Feedback); title('Feedback'); ylabel('Feedback');
subplot(5,1,5); plot(data.GeneratedSignal); title('Generated Signal'); ylabel('Generated Signal');
xlabel('Time Steps');
figureFileName = 'Figure1_VariablesOverTime.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Histogram of variables
figure;
for i = 1:length(columnNames)
    subplot(3,2,i);
    histogram(data{:, i}, 50);
    title(columnNames{i});
    xlabel(columnNames{i});
    ylabel('Frequency');
end
figureFileName = 'Figure2_VariableHistograms.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Combined distribution plot
figure;
hold on;
for i = 1:length(columnNames)
    histogram(data{:, i}, 50, 'Normalization', 'pdf', 'DisplayName', columnNames{i});
end
title('Combined Variable Distributions');
xlabel('Value');
ylabel('Probability Density');
legend('show');
figureFileName = 'Figure3_CombinedVariableDistributions.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Correlation matrix heatmap
corrMatrix = corr(data{:,:});
figure;
heatmap(columnNames, columnNames, corrMatrix, 'Colormap', parula, 'ColorbarVisible', 'on');
title('Correlation Matrix Heatmap');
figureFileName = 'Figure4_CorrelationMatrixHeatmap.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Pairwise scatter plots
figure;
plotmatrix(data{:,:});
title('Pairwise Scatter Plots');
figureFileName = 'Figure5_PairwiseScatterPlots.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Box plots for outlier detection
figure;
for i = 1:length(columnNames)
    subplot(3,2,i);
    boxplot(data{:, i});
    title(columnNames{i});
    ylabel(columnNames{i});
end
figureFileName = 'Figure6_BoxPlots_OutlierDetection.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Time-Series Zoomed Plots
figure;
startIdx = 1;
endIdx = 1000; % Zoomed in for first 1000 samples
subplot(5,1,1); plot(data.Error(startIdx:endIdx)); title('Error (Zoomed)'); ylabel('Error');
subplot(5,1,2); plot(data.ErrorRate(startIdx:endIdx)); title('Error Rate (Zoomed)'); ylabel('Error Rate');
subplot(5,1,3); plot(data.ControlSignal(startIdx:endIdx)); title('Control Signal (Zoomed)'); ylabel('Control Signal');
subplot(5,1,4); plot(data.Feedback(startIdx:endIdx)); title('Feedback (Zoomed)'); ylabel('Feedback');
subplot(5,1,5); plot(data.GeneratedSignal(startIdx:endIdx)); title('Generated Signal (Zoomed)'); ylabel('Generated Signal');
xlabel('Time Steps');
figureFileName = 'Figure7_TimeSeriesZoomedPlots.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Moving average trend analysis
figure;
windowSize = 100;
for i = 1:length(columnNames)
    subplot(5,1,i);
    movAvg = movmean(data{:, i}, windowSize);
    plot(movAvg);
    title([columnNames{i}, ' Moving Average']);
    ylabel(columnNames{i});
end
xlabel('Time Steps');
figureFileName = 'Figure8_MovingAverageTrendAnalysis.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Scatter plots for interaction terms
figure;
scatter(data.Error .* data.ErrorRate, data.ControlSignal, 'filled');
xlabel('Error × ErrorRate');
ylabel('Control Signal');
title('Interaction between Error × ErrorRate and Control Signal');
figureFileName = 'Figure9_InteractionScatterPlot.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);
