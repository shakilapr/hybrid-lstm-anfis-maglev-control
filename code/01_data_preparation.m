% =========================================================
% Section 1: Data Preparation
% =========================================================
% 
% Part of: Hybrid LSTM-ANFIS Control System for Magnetic Levitation
% Author: Shakila Praveen Rathnayake
% Contact: shakilabeta@gmail.com
% GitHub: github.com/shakilapr/hybrid-lstm-anfis-maglev-control
% 
% Description:
% This script implements section 1: data preparation.
% 
% Dependencies:
% - MATLAB R2020b or later
% - Deep Learning Toolbox (for LSTM sections)
% - Fuzzy Logic Toolbox (for ANFIS sections)
% 
% =========================================================

% =====================================
% Section 1: Data Preparation
% =====================================

% Clear workspace and close all figures
clear; clc; close all;

% Parameters
chunkSize = 1000; % Minimum size of each chunk
dataFolder = 'data'; % Folder containing the data files
outputFileName = 'dataset.csv';
figureFolder = 'figures/Section1'; % Folder to save figures

% Create figures folder if it doesn't exist
if ~exist(figureFolder, 'dir')
    mkdir(figureFolder);
end

% Initialize storage for all chunks
allChunks = [];
chunkCounts = [];
fileSummary = {}; % For summary table

% Loop through all output files in the data folder
filePattern = fullfile(dataFolder, 'output_*.csv');
files = dir(filePattern);

if isempty(files)
    error('No files matching the pattern "%s" found in folder "%s".', filePattern, dataFolder);
end

disp('Reading and processing files...');

for i = 1:length(files)
    fileName = files(i).name;
    fullFileName = fullfile(dataFolder, fileName);
    disp(['Processing file: ', fullFileName]);
    
    % Read the file
    dataFile = readtable(fullFileName);
    
    % Assign variable names if not present
    dataFile.Properties.VariableNames = {'Error', 'ErrorRate', 'ControlSignal', 'Feedback', 'GeneratedSignal'};
    
    % Display first few rows
    disp(['First 5 rows of ', fileName, ':']);
    disp(head(dataFile, 5));
    
    % Visualize data in the file
    figure;
    subplot(5,1,1); plot(dataFile.Error); title('Error'); ylabel('Error');
    subplot(5,1,2); plot(dataFile.ErrorRate); title('Error Rate'); ylabel('Error Rate');
    subplot(5,1,3); plot(dataFile.ControlSignal); title('Control Signal'); ylabel('Control Signal');
    subplot(5,1,4); plot(dataFile.Feedback); title('Feedback'); ylabel('Feedback');
    subplot(5,1,5); plot(dataFile.GeneratedSignal); title('Generated Signal'); ylabel('Generated Signal');
    xlabel('Time Steps');
    
    % Save the figure
    figureFileName = sprintf('Figure%d_DataVisualization_%s.png', i, fileName);
    saveas(gcf, fullfile(figureFolder, figureFileName));
    close(gcf);
    
    % Get the number of rows in the file
    numRows = size(dataFile, 1);
    
    % Calculate the number of chunks needed
    numChunks = ceil(numRows / chunkSize);
    
    % Recalculate rows per chunk to ensure all chunks are larger than 1000
    rowsPerChunk = ceil(numRows / numChunks);
    
    % Split into chunks
    for j = 1:numChunks
        startIdx = (j-1) * rowsPerChunk + 1;
        endIdx = min(j * rowsPerChunk, numRows);
        chunk = dataFile(startIdx:endIdx, :);
        allChunks = [allChunks; {chunk}]; %#ok<AGROW>
    end
    chunkCounts = [chunkCounts; numChunks];
    fileSummary = [fileSummary; {fileName, numRows, numChunks, rowsPerChunk}];
end

disp('Splitting into chunks completed.');

% Plot chunk size distribution
figure;
bar(chunkCounts);
title('Number of Chunks per File');
xlabel('File Index');
ylabel('Number of Chunks');
figureFileName = 'Figure_ChunkSizeDistribution.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Shuffle the chunks randomly
disp('Randomizing chunks...');
originalIndices = 1:length(allChunks);
shuffledIndices = randperm(length(allChunks));
randomizedChunks = allChunks(shuffledIndices);

% Visualize randomization
figure;
subplot(2,1,1);
stem(originalIndices, 'filled');
title('Original Chunk Indices');
xlabel('Chunk Index');
ylabel('Value');

subplot(2,1,2);
stem(shuffledIndices, 'filled');
title('Shuffled Chunk Indices');
xlabel('Shuffled Index');
ylabel('Original Chunk Index');

figureFileName = 'Figure_ChunkRandomization.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Combine randomized chunks into a single dataset
disp('Combining chunks...');
finalDataset = vertcat(randomizedChunks{:});

% Save the combined dataset as 'dataset.csv' in the default folder
disp(['Saving combined dataset to "', outputFileName, '"...']);
writetable(finalDataset, outputFileName);

disp('Data preparation completed. The combined dataset is saved as "dataset.csv".');

% Additional plot: Randomly combined dataset
figure;
subplot(5,1,1); plot(finalDataset.Error); title('Error'); ylabel('Error');
subplot(5,1,2); plot(finalDataset.ErrorRate); title('Error Rate'); ylabel('Error Rate');
subplot(5,1,3); plot(finalDataset.ControlSignal); title('Control Signal'); ylabel('Control Signal');
subplot(5,1,4); plot(finalDataset.Feedback); title('Feedback'); ylabel('Feedback');
subplot(5,1,5); plot(finalDataset.GeneratedSignal); title('Generated Signal'); ylabel('Generated Signal');
xlabel('Data Points');
figureFileName = 'Figure_RandomizedCombinedDataset.png';
saveas(gcf, fullfile(figureFolder, figureFileName));
close(gcf);

% Summary table of files
fileSummaryTable = cell2table(fileSummary, 'VariableNames', {'FileName', 'NumRows', 'NumChunks', 'RowsPerChunk'});
disp('Summary of files and chunks:');
disp(fileSummaryTable);

% Save summary table
writetable(fileSummaryTable, fullfile(figureFolder, 'FileSummary.csv'));
