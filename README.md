# Getting-and-Cleaning-Data-Course-Project
Course project to perform cleaning and analysis on data collected from the accelerometers from the Samsung Galaxy S smartphone.

## To run analysis and tidyup dataset execute the run_analysis.R
The R code will take care of dependencies as the packages will be installed if not already present.
The version details is following: 
*R version 3.6.3 (2020-02-29)
*dplyr version 1.0.2
*stringr version 1.4.0
*Dataset download date (August 30, 2020)

The following functionality will be performed.

### Download the dataset
First script will check for dataset and if not in current working directory it will download the dataset form URL http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip, and then unzip it. It will create UCI HAR Dataset directory.

### Step 1: Merge test and train data 
First converted data.table to dplyr::tibble as working with dplyr is easy. Then merged xtest and train data to xdata and y train and test data to ydata. Removed the xtestdata, ytestdata, xtraindata and ytraindata to clear space from working environment (RAM).

### Step 2: Extract measurements on Mean and Std
Read the variable names (name="features.txt" path="./UCI HAR Dataset/features.txt").
Converted to dplyer::tibble. Then used "stringr" package to search for std and mean in variable names and used filter() to extract only mean and std variables. Then select the columns with filtered variables.

### Step 3: Use descriptiive activity name
Initially y_test.txt has one variable representing 1 of six states for each row in "x_test.txt". Instead of converting to factor type, add 6 columns with column name is activity name from file "activity_labels.txt" where if activity is true for row then value is 1 else 0.

### Step 4: Descriptive variable names
Removed the special characters("-,(,)") from variable names. Rename the columns of xdata. Add subject column to xdata.

### Step 5: Create second independent dataset
First use group_by activity and student and then apply summarize function to calculate mean for each column (for each group).

Write tidy_data_summarized to disk.