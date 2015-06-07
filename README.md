##run_analysis for 'UCI HAR Dataset' dataset

directory - directory to folder where 'UCI HAR Dataset' folder is placed. By default - current working directory.  
In case 'UCI HAR Dataset' folder does not exist in provided directory, error message: "UCI HAR Dataset folder doesn't exist in directory!" appears.

1. Reading *train data*, *test data*, *activity_labels*, *feature names*  

```
X_train <- read.table(paste(directory, "/UCI HAR Dataset/train/X_train.txt", sep = ""), header = FALSE, quote="\"")
y_train <- read.table(paste(directory, "/UCI HAR Dataset/train/y_train.txt", sep = ""), header = FALSE, quote="\"")
subject_train <- read.table(paste(directory, "/UCI HAR Dataset/train/subject_train.txt", sep = ""), header = FALSE, quote="\"")
X_test <- read.table(paste(directory, "/UCI HAR Dataset/test/X_test.txt", sep = ""), header = FALSE, quote="\"")
y_test <- read.table(paste(directory, "/UCI HAR Dataset/test/y_test.txt", sep = ""), header = FALSE, quote="\"")
subject_test <- read.table(paste(directory, "/UCI HAR Dataset/test/subject_test.txt", sep = ""), header = FALSE, quote="\"")

activity_labels <- read.table(paste(directory, "/UCI HAR Dataset/activity_labels.txt", sep = ""), header = FALSE, quote="\"")

features <- read.table(paste(directory, "/UCI HAR Dataset/features.txt", sep = ""), header = FALSE, quote="\"")
```

2. Concatenating training and test data sets  

```
X <- rbind(X_train, X_test)
y <- rbind(y_train, y_test)
subject <- rbind(subject_train, subject_test)
```

3. Labeling the data set with descriptive variable names (deleting all "-" from names)  

```
features[,2] <- gsub("\\)", "", gsub("\\(", "", gsub("-",".",features[,2])))
names(X) <- features[,2]
```

4. Adding column with subject, labeling the 'subject' column with descriptive variable name  

```
data1 <- cbind(X, subject)
names(data1)[names(data1)=="V1"] <- "subject"
```

5. Merging features and activity data.frames, labeling the 'activity' column with descriptive variable name  

```
data1 <- cbind(data1, y)
names(data1)[names(data1)=="V1"] <- "activity"
```

6. Using descriptive activity names to name the activities in the data set  

```
data1$activity <- as.factor(unlist(lapply(data1$activity, function (i) {activity_labels[activity_labels$V1 == i, ]$V2})))
```

7. Extracting only the measurements on the mean and standard deviation for each measurement  

```
data1$activity <- as.factor(unlist(lapply(data1$activity, function (i) {activity_labels[activity_labels$V1 == i, ]$V2})))
```

8. Creating a independent tidy data set with the average of each variable for each activity and each subject  

```
data2 <- data.table(data1)
data2 <- data2[, lapply(.SD, mean), by = .(subject, activity)]
```

Script return two data sets:  
* data_cleaned - data, received after 6th step  
* data_grouped - data, received after 7th step (grouped by activity and subject)