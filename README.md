# Cleaning-Data-Course-Project

This script merges and summarizes/ averages data from the Human Activity Recognition Using Smartphones dataset.  It is being submitted as a course project for Coursera's Getting and Cleaning Data course.

The sources and references are listed below:

1. Details of the Samsung Galaxy Human Activity Recognition project from which the data was pulled from are here -> 

2. The data cleaned and summarized by the script are from here -> https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

3. The course project specifications are here ->https://www.coursera.org/learn/data-cleaning/peer/FIZtT/getting-and-cleaning-data-course-project

The script produces an output in the working directory called "feature_means.txt" which contains the average of all standard deviation and mean measures, grouped by subject and activity.

You may refer to any of the following files for more details on variables and source data:

1. UCI HAR Dataset/README.txt --> for more background on how the source data was collected and recorded
2. UCI HAR Dataset/features_info.txt -> for more info on the source dataset itself
3. Feature Means Codebook.txt --> for more info on the output data

### Prerequisites

The following need to be true in order for run_analysis.R to run properly:
1. run_analysis.R needs to be in your working directory
2. UCI HAR dataset needs to be downloaded from and unzipped https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

3. The folder "UCI HAR Dataset" has to be placed in your working directory, along with the run_analysis.R. It is important that all filenames, files and file structures within the folder are not modified, otherwise, the script may not run properly.

4. the package "data.tables" has to be installed in R


### Input and Output

Data Source/ Input: Data from the "UCI HAR Dataset"
Data Output: feature_means.txt (refer to Feature Means Codebook.txt for more info on this)

### Data Transformations and Summarizations

The following process summarizes the data transformation done in run_analysis.R 
1. The following data is loaded into R into the variables indicated below: 
   * s_test <- UCI HAR Dataset/test/subject_test.txt 
   * x_test <-UCI HAR Dataset/test/X_test.txt
   * y_test <- UCI HAR Dataset/test/Y_test.txt
   * s_train <- UCI HAR Dataset/train/subject_train.txt
   * x_train <- UCI HAR Dataset/train/X_train.txt
   * y_train <- UCI HAR Dataset/train/Y_train.txt

2. Variable names of the dataframes are updated to make them more readable
   * the data frames s_test and s_train have their only variable/ column renamed to "subject"
   * the data frames y_test and y_train have their only variable/ column renamed to "activity"
   * the data frames x_test and y_test have their variables named based on the names in UCI HAR Dataset/features.txt file

3.  We update x_test and x_train so that only the average and standard deviation measures remain. This is done using the following steps:
    * grep with the regex "mean\\(\\)|std\\(\\)", is used with the complete list of ordered measures to get the indices of the desired columns
    * the derived idices are used to subset x_test and x_train so that only the variables for mean and standard deviation remain

4. The test data frames (s_test, x_test and y_test) are merged together using cbind into the frame merged_test

5. The activity variable of merged_test is factorized, and given levels as defined in UCI HAR Dataset/activity_labels.txt

6. The train data frames (s_train, x_train and y_train) are merged together using cbind into the frame merged_train

7. The merged_test and merged_train dataframes are merged together with rbind into merged_dat, effectively merging the test and train datasets.

8. merged_test is summarized into summary_dat. The aggregate function is used so that all the measure variables (columns 3-68) are averaged by subject and activity 

9. Rename the measure variables in summary)dat. Add "ave-" as a prefix to help identify that measures have been averaged

10. Write data into a file called featu


