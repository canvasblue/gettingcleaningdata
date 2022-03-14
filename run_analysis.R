########## STEP 1 ####################################################################
## Merge the training and the test sets to create one data set.

## read test data file
testdata <- read.table("UCI HAR Dataset/test/X_test.txt")

## inspect test data
head(testdata,1)
dim(testdata)
str(testdata)
class(testdata)

## load & inspect test activity IDs
testactivityID <- read.table("UCI HAR Dataset/test/y_test.txt")
dim(testactivityID)
unique(testactivityID)

## load & inspect test activity IDs
testsubjectID <- read.table("UCI HAR Dataset/test/subject_test.txt")
dim(testsubjectID)
unique(testsubjectID)

## read training data file
traindata <- read.table("UCI HAR Dataset/train/X_train.txt")

## inspect training data
head(traindata,1)
dim(traindata)
str(traindata)
class(traindata)

## load & inspect training activity IDs
trainactivityID <- read.table("UCI HAR Dataset/train/y_train.txt")
dim(trainactivityID)
unique(trainactivityID)

## load & inspect training subject IDs
trainsubjectID <- read.table("UCI HAR Dataset/train/subject_train.txt")
dim(trainsubjectID)
unique(trainsubjectID)

## additional checks on subject ID data
# intersect(unique(testsubjectID[[1]]), unique(trainsubjectID[[1]]))
# sort((union(unique(testsubjectID[[1]]), unique(trainsubjectID[[1]]))))

## merge the training and test data set
mergedata <- rbind(cbind(testsubjectID, testactivityID, testdata), cbind(trainsubjectID, trainactivityID, traindata))

## inspect merged data
head(mergedata,1)
dim(mergedata)
str(mergedata)
colnames(mergedata)

## Rename first two columns of the merged data set
## First column is subject ID and the second column is activity ID
colnames(mergedata)[1:2] <- c("subject_id", "activity_id")

## inspect first two columns (now named) of merged data 
# unique(mergedata[["subject_id"]])
# unique(mergedata[["activity_id"]])


########## STEP 2 ####################################################################
## Extract only the measurements on the mean and standard deviation for each measurement.

## load the names of all the features measured/captured in the data set
features <- read.table("UCI HAR Dataset/features.txt")

# length(features[[2]])

## find the index of feature names that contain "mean" or "std" in the name
meanstdindex <- grep("mean|std", features[[2]])
# length(meanstdindex)

## since subject ID and activity ID columns were added to the data set, shift the indices by 2
## add add the first two column numbers to the list to retain subject ID and activity ID
## and use the indices to extract the corresponding measurements from the merged data
meanstddata <- mergedata[,c(1,2, meanstdindex+2)]
dim(meanstddata)
colnames(meanstddata)

########## STEP 3 ####################################################################
## Use descriptive activity names to name the activities in the data set

## load dplyr library
library(dplyr)

## load the activity id and activity name
actlabels <- read.table("UCI HAR Dataset/activity_labels.txt")
## rename columns
colnames(actlabels) <- c("activity_id", "activity")
## add activity name to the data set matching/joining based on activity_id
meanstddata <- inner_join(meanstddata, actlabels, by="activity_id")
## move the activty name column next to activity_id column
meanstddata <- relocate(meanstddata, activity, .after = activity_id)


########## STEP 4 ####################################################################
## Appropriately label the data set with descriptive variable names. 

## set the column names from the features data frame
## second column of features data frame has the descriptive variable names
## use the indices previously identified using grep for mean or std to label the columns
## first 3 columns of meanstddata are student ID, activity ID and activity
## so, the name/label for measurements need to start from col 4 onwards
colnames(meanstddata)[4:length(meanstddata)] <- features[meanstdindex,2]
colnames(meanstddata)


########## STEP 5 ####################################################################
## From the data set in step 4, creates a second, independent tidy data set with
## the average of each variable for each activity and each subject.
summarydata <- meanstddata %>%
  group_by(subject_id, activity_id, activity) %>%
  summarize_each(mean)

dim(summarydata)

## write the summary data into a text file
write.table(summarydata, row.names=FALSE, file="HAR_dataset_summary.txt")


###
# library(codebook)
# library(tidyverse)
# library(dataMaid)
# 
# makeCodebook(features)
# 
# attributes(features)$label
# 
# codebook <- map_df(features, function(x) attributes(x)$label) %>% 
#   gather(key = Code, value = Label)
# 
# codebook
###

write.csv(summarydata, "test.csv")