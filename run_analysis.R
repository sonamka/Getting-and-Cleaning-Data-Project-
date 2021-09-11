##Step 1
merged_data <- rbind(
  cbind(x_train, y_train, subject_train),
  cbind(x_test, y_test, subject_test))
colnames(merged_data) 
##Step 2
library(dplyr)
SelectedData <- merged_data %>% select(subject, code, contains("mean"), contains("std"))
View(SelectedData)
##Step 3 
SelectedData$code <- activities[SelectedData$code, 2]
##Step 4
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
##Step 5
TidyData <- TidyData <- SelectedData %>% 
  arrange(subject, activity) %>% 
  group_by(subject, activity) %>% 
  summarize_all(mean)
write.table(TidyData, "TidyData.txt", row.names=FALSE)
View(TidyData)