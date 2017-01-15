
## This script performs the following data transformations:
##      REQ 1. Merges the training and the test sets to create one data set.
##      REQ 2.Extracts only the measurements on the mean and standard deviation for each
##      measurement.
##      REQ 3. Uses descriptive activity names to name the activities in the data set
##      REQ 4. Appropriately labels the data set with descriptive variable names.
##      REQ 5. From the data set in step 4, creates a second, independent tidy data set 
##      with the average of each variable for each activity and each subject.
##
## Script Output:
##      1. New file with average values per activity and subject in working dir --> feature_means.txt
##
## This script assumes the following:
##      1. Data used is from http://bit.ly/1p1sdWC
##      2. Downloaded data is unzipped
##      3. The folder "UCI HAR Dataset" is placed in the working directory

run_analysis <-function(){

    library(data.table)
    
    ## Check if the needed data folder is present in working directory
    if ( !("UCI HAR Dataset" %in% dir()) ){
        stop("Data file not in working directory")
    }
    
    setwd("UCI HAR Dataset")
    
    ## Read variables common to the 2 datasets
    measures <- read.table("features.txt", header= FALSE)
    activities <- read.table("activity_labels.txt", header=FALSE)
    
    ## Read Test and Train data
    s_test <- read.table("test/subject_test.txt", header= FALSE)
    x_test <- read.table("test/X_test.txt", header= FALSE)
    y_test <- read.table("test/Y_test.txt", header= FALSE)
    s_train <- read.table("train/subject_train.txt", header= FALSE)
    x_train <- read.table("train/X_train.txt", header= FALSE)
    y_train <- read.table("train/Y_train.txt", header= FALSE)
    
    ## REQ 4: Use descriptive names for variables
    setnames(s_test, names(s_test), "subject")
    setnames(x_test,names(x_test), as.character(measures$V2))
    setnames(y_test, names(y_test), "activity")
    setnames(s_train, names(s_train), "subject")
    setnames(x_train,names(x_train), as.character(measures$V2))
    setnames(y_train, names(y_train), "activity")
    
    ## REQ 2: Get only the mean() and std() variables from x_test
    ## I did this first to minimize dataset size before merging
    ## Then I realized I didn't need to because I'm using rbind, not merge
    ## Oh well..
    usemeasure <- grep("mean\\(\\)|std\\(\\)", measures$V2)
    x_test <- x_test[,usemeasure]
    x_train <- x_train[,usemeasure]
    
    # Create a column identifying which dataset an observaion belongs to
    # Appended to y_test for a better column order
    # y_test$dataset <- "test"
    ## y_train$dataset <- "train"
    
    # create merged files for both test and train data
    merged_test <- cbind(s_test, y_test, x_test)
    merged_train <- cbind(s_train, y_train, x_train)
    
    
    ## REQ 1: Merge train and test data
    merged_dat <- rbind(merged_test, merged_train)

    ## REQ 3: Use descriptive activity names for the activity variable
    merged_dat$activity <- as.factor(merged_dat$activity)
    levels(merged_dat$activity) <- activities$V2
    
    ## Trying out melting data
    ## meas_vars <- measures[usemeasure, 2]
    ## melted_data <- melt(merged_dat, id=c("subject","activity"), measure.vars = meas_vars)
    ## setnames(melted_data, names(melted_data), 
    ##         c("subject", "activity", "features", "featurevalue"))
    
    
    ## REQ 5: Create a table with averages of each variable per subject and activity
    summary_dat <- aggregate(. ~subject + activity, merged_dat, mean)
    
    ## Rename the measure files so that we know that they have been changed
    new_col_names <- paste("ave-", sep="", names(summary_dat)[3:68])
    new_col_names <- append("activity", new_col_names)
    new_col_names <- append("subject", new_col_names)
    colnames(summary_dat) <- new_col_names
    
    # Write data to data file
    write.table(summary_dat, file="../feature_means.txt", row.name = FALSE)
    
}