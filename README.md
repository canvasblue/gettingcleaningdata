The final project for "Getting and Cleaning Data" course is streod in an R script called run_analysis.R that does the following: 
1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

####################
Step 1: Merge data
####################
Load the test data and supporting info:
1.1 Read test data file. The test file is stored at the following path in the working directory: UCI HAR Dataset/test/X_test.txt
1.2 Read test activity IDs. These are the IDs for various activities for which data is collected & stored in the test data file. This information is stored at the following path in the working directory: UCI HAR Dataset/test/y_test.txt
1.3 Read test subject IDs. These are the IDs for subjects for which data is collected and stored in the test data file. This information is stored at the following path in the working directory: UCI HAR Dataset/test/subject_test.txt

Then repeat the steps 1.1-1.3 for training data set
1.4 Read training data file. The training file is stored at the following path in the working directory: UCI HAR Dataset/train/X_train.txt
1.2 Read training activity IDs. These are the IDs for various activities for which data is collected & stored in the training data file. This information is stored at the following path in the working directory: UCI HAR Dataset/train/y_train.txt
1.3 Read training subject IDs. These are the IDs for subjects for which data is collected and stored in the training data file. This information is stored at the following path in the working directory: UCI HAR Dataset/train/subject_train.txt

Then merge the data sets togther:
- first column bind the corresponding subject IDs and activity IDs to the test and training data sets
- then row bind the test and training data set (including the subject IDs and activity IDs)
The result is a combined/merged data set that includes all the IDs and all the corresponding observations (test & training) across 561 measures. Resulting dataset is 10299 R x 563 C (two additional columns correspond to the IDs)

####################
Step 2: Extract mean and std deviation measurements
####################
2.1 Load the names of all the features measured/captured in the data set. The names of features is stored at the following path in the working directory: UCI HAR Dataset/features.txt
2.2 Find a list of index values that contain "mean" or "std" in the name
2.3 Use the index values to subset the merged data created at the end of Step 1. 
Note: the index values are adjusted by a count of 2 to accound for the two ID columns.

####################
Step 3: Name the activities
####################
3.1 Load the mapping between the acitivity IDs and activity names using the following file in the working directory: UCI HAR Dataset/activity_labels.txt
3.2 Label the column names of the resulting data frame and then inner join the subsetted the data set obtained from previous step.
3.3 Post-join since the activity name will be at the end of the dataframe, move/relocate it after the activity ID column
The resulting dataset now has named activities in it.

####################
Step 4: Name the measurements
####################
4.1 Subset the names of the measurements (features) loaded in Step 2.1 using the index values in step 2.2
4.2 Use the resulting set of measurement names to assign column names for the data set from Step 3. Note that first 3 columns already contain subject ID, activity ID and activity name, so column names will be assigned from 4th column onwards

####################
Step 5: Create tidy data set with average of all measurements
####################
5.1 Group by resulting data from Step 4 by subject ID, activity ID and activity name
5.2 Use summarize_each function to calculate the mean for each group
The resulting dataset is a tidy data set.
