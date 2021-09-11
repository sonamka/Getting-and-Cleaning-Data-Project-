# Getting and Cleaning Data Project 
 
 # Download Data (zip file)

 
filename <- "Coursera_GCD.zip"
if (!file.exists(filename)){
  fileURL <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
  download.file(fileURL, filename, method="curl")
} 

## Unzip file

if (!file.exists("UCI HAR Dataset")) { 
  unzip(filename) 
}

# Load Package dplyr

library(dplyr)

## Assign data frames and using read.table

For each data frame, assign unique names and read the data from the unzipped file

features <- read.table("UCI HAR Dataset/features.txt", col.names = c("n","functions"))
activities <- read.table("UCI HAR Dataset/activity_labels.txt", col.names = c("code", "activity"))
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "subject")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$functions)
y_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "code")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "subject")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$functions)
y_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "code")


# Create R Script for run_analysis.R 

## Step 1

Merge all training and test sets to create a data set named "merged_data" using rbind and cbind.  

merged_data <- rbind(
  cbind(x_train, y_train, subject_train),
  cbind(x_test, y_test, subject_test))

  
Then, view column names of the merged data set to check the new data set.

colnames(merged_data) 

## Step 2

Extract measurements on the mean and standard deviation for each measurement using the select() function from dplyr

SelectedData <- merged_data %>% select(subject, code, contains("mean"), contains("std"))

Now look at the selected data again

View(SelectedData)

## Step 3

Name the activities in the data set using descriptive activity names 

SelectedData$code <- activities[SelectedData$code, 2]

## Step 4 

Label the data set with descriptive variable names using gsub, which replaces the strings.

names(SelectedData)[2] = "activity"
names(SelectedData)<-gsub("Acc", "Accelerometer", names(SelectedData))
names(SelectedData)<-gsub("Gyro", "Gyroscope", names(SelectedData))
names(SelectedData)<-gsub("BodyBody", "Body", names(SelectedData))
names(SelectedData)<-gsub("Mag", "Magnitude", names(SelectedData))
names(SelectedData)<-gsub("^t", "Time", names(SelectedData))
names(SelectedData)<-gsub("^f", "Frequency", names(SelectedData))
names(SelectedData)<-gsub("tBody", "TimeBody", names(SelectedData))
names(SelectedData)<-gsub("-mean()", "Mean", names(SelectedData), ignore.case = TRUE)
names(SelectedData)<-gsub("-std()", "Standard Deviation", names(SelectedData), ignore.case = TRUE)
names(SelectedData)<-gsub("-freq()", "Frequency", names(SelectedData), ignore.case = TRUE)

## Step 5

From the data set in step 4, create another tidy data set with the average of each variable for each activity and each subject using arrange(), groub_by(), and summarise_all().

TidyData <- TidyData <- SelectedData %>% 
  arrange(subject, activity) %>% 
  group_by(subject, activity) %>% 
  summarize_all(mean)
write.table(TidyData, "TidyData.txt", row.names=FALSE)

Now view the final data set:

str(TidyData) 

or

View(TidyData)

