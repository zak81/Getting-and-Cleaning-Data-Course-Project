# run_analysis.R
library(reshape2) # melt function in reshape2 library is used to melt dataset into tall and skinny dataset.

# Merge the training and the test sets to create one data set.
X_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
X_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
X_set <- rbind(X_train, X_test)


# Extract measurements on the mean and standard deviation for each measurement.
features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE)
colnames(X_set) <- features[,2]
extracted_set <- cbind(X_set[, grepl("mean()", colnames(X_set))], X_set[, grepl("std()", colnames(X_set))])


# Use descriptive activity names to name the activities in the data set.
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subject <- rbind(subject_train, subject_test)

y_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
y_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
activity <- rbind(y_train, y_test)

data_set <- cbind(subject, activity, extracted_set)
colnames(data_set)[1:2] <- c("SubjectID", "Activity") # renaming columns 1 and 2 in dataset.

data_set$Activity[data_set$Activity==1] <- "WALKING"
data_set$Activity[data_set$Activity==2] <- "WALKING UPSTAIRS"
data_set$Activity[data_set$Activity==3] <- "WALKING DOWNSTAIRS"
data_set$Activity[data_set$Activity==4] <- "SITTING"
data_set$Activity[data_set$Activity==5] <- "STANDING"
data_set$Activity[data_set$Activity==6] <- "LAYING"


# Label the data set with descriptive variable names
colnames(data_set) <- gsub("\\()", "", names(data_set))
colnames(data_set) <- gsub("BodyBody", "Body", names(data_set))
colnames(data_set) <- gsub("fBody", "FreqBody", names(data_set))
colnames(data_set) <- gsub("tBody", "TimeBody", names(data_set))
colnames(data_set) <- gsub("tGravity", "TimeGravity", names(data_set))
colnames(data_set) <- gsub("-std", "Std", names(data_set))
colnames(data_set) <- gsub("-mean", "Mean", names(data_set))
colnames(data_set) <- gsub("-", "", names(data_set))


# From the data set in step 4, create a second, independent tidy data set with the average of each variable for each activity and each subject.
dataMelt <- melt(data_set, id=c("SubjectID", "Activity"), measure.vars= -(1:2))
dataCast <- dcast(dataMelt, SubjectID + Activity ~ variable, mean)
colnames(dataCast)[-(1:2)] <- paste("Average(", colnames(dataCast)[-(1:2)], ")", sep="")


