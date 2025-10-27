# Data Directory

## Required Data Format

Place your magnetic levitation system data files in this directory.

### File Naming Convention
- Files must be named: `output_*.csv` (e.g., `output_1.csv`, `output_2.csv`)
- Multiple files will be automatically processed and combined

### Required Columns
Each CSV file must contain the following columns:
1. **Error**: Position error signal
2. **ErrorRate**: Rate of change of error (derivative)
3. **Feedback**: Sensor feedback signal
4. **GeneratedSignal**: System generated control input
5. **ControlSignal**: Actual control signal applied

### Data Requirements
- Minimum chunk size: 1000 samples per file
- Numeric values only
- No missing values (NaN)
- Sampling rate should be consistent across files

### Example Data Structure
```csv
Error,ErrorRate,Feedback,GeneratedSignal,ControlSignal
0.125,-0.032,2.456,1.234,1.189
0.118,-0.028,2.478,1.245,1.201
...
```

## Processing
The data will be:
1. Read from all `output_*.csv` files
2. Split into chunks of minimum size 1000
3. Randomized for training
4. Combined into `dataset.csv` (saved in parent directory)
5. Preprocessed and prepared for LSTM/ANFIS training

## Note
- This directory should contain your raw input data
- Processed datasets will be saved in the parent directory
- Keep original data files for reproducibility
