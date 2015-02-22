### Getting-and-Cleaning-Data-Course-Project
####Course Project

#####Objective is to merge components of data to create a single data set that is tidy and descriptive.

*Number in parenthesis denote line number in run_analysis.R*

(2) library(reshape2) -- melt function in reshape2 library is used to melt dataset into tall and skinny dataset.

(5) X_train <- read.table("./UCI HAR Dataset/train/X_train.txt") -- reading a set of data from 7352 training observations.

(6) X_test <- read.table("./UCI HAR Dataset/test/X_test.txt") -- reading a set of data from 2947 test observations.

(7) X_set <- rbind(X_train, X_test) -- merging both sets of data into a single dataset of 10299 observations.

(11) features <- read.table("./UCI HAR Dataset/features.txt", stringsAsFactors=FALSE) --reading a set of variables computed.

(12) colnames(X_set) <- features[,2] -- naming the variables in X_set. 

(13) extracted_set <- cbind(X_set[, grepl("mean()", colnames(X_set))], X_set[, grepl("std()", colnames(X_set))]) -- grepl searches for column names with "mean()" or "std()"; cbind combines only the columns that grepl matches. Resulted in 79 variables match.

(17) subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt") -- reading data of 7352 subject records from training subjects.

(18) subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt") -- reading data of 2947 subject records from test subjects.

(19) subject <- rbind(subject_train, subject_test) -- merging both sets of data into a single dataset of 10299 observations.

(21) y_train <- read.table("./UCI HAR Dataset/train/y_train.txt") -- reading data of 7352 sets of activity code recorded by training subjects.

(22) y_test <- read.table("./UCI HAR Dataset/test/y_test.txt") -- reading data of 2947 sets of activity code recorded by training subjects.

(23) activity <- rbind(y_train, y_test) -- merging both sets of data into a single dataset of 10299 observations.

(25) data_set <- cbind(subject, activity, extracted_set) -- merging subjectID, activity code and extracted data set to form a binded dataset.

(26) colnames(data_set)[1:2] <- c("SubjectID", "Activity") --renaming variable 1 and 2 to descriptive names.

(28-33) -- Following lines convert activity code to a descriptive activity names.

`data_set$Activity[data_set$Activity==1] <- "WALKING"`

`data_set$Activity[data_set$Activity==2] <- "WALKING UPSTAIRS"`

`data_set$Activity[data_set$Activity==3] <- "WALKING DOWNSTAIRS"`

`data_set$Activity[data_set$Activity==4] <- "SITTING"`

`data_set$Activity[data_set$Activity==5] <- "STANDING"`

`data_set$Activity[data_set$Activity==6] <- "LAYING"`

(37-44) -- Following lines label the dataset with descriptive variable names.

`colnames(data_set) <- gsub("\\()", "", names(data_set))`

`colnames(data_set) <- gsub("BodyBody", "Body", names(data_set))`

`colnames(data_set) <- gsub("fBody", "FreqBody", names(data_set))`

`colnames(data_set) <- gsub("tBody", "TimeBody", names(data_set))`

`colnames(data_set) <- gsub("tGravity", "TimeGravity", names(data_set))`

`colnames(data_set) <- gsub("-std", "Std", names(data_set))`

`colnames(data_set) <- gsub("-mean", "Mean", names(data_set))`

`colnames(data_set) <- gsub("-", "", names(data_set))`

(48) dataMelt <- melt(data_set, id=c("SubjectID", "Activity"), measure.vars= -(1:2)) -- Reshaping the data by passing melt function. Telling function to set ID variables SubjectID and Activity, set measured variables to all other variables. 

(49) dataCast <- dcast(dataMelt, SubjectID + Activity ~ variable, mean) -- Using dcast function on data, summarize SubjectID and Activity using mean of all variables.

(50) colnames(dataCast)[-(1:2)] <- paste("Average(", colnames(dataCast)[-(1:2)], ")", sep="") -- This final step renames all measured variables to say Average(variable).


