run_analysis <- function(directory = getwd()) {
        
        #directory - directory to folder where 'UCI HAR Dataset' folder is placed
        
        if (!file.exists(paste(directory, "/UCI HAR Dataset", sep = ""))) {stop('UCI HAR Dataset folder doesn\'t exist in directory!')}
        
        #library data.table should be installed
        require(data.table)
        
        #Reading train data
        X_train <- read.table(paste(directory, "/UCI HAR Dataset/train/X_train.txt", sep = ""), header = FALSE, quote="\"")
        y_train <- read.table(paste(directory, "/UCI HAR Dataset/train/y_train.txt", sep = ""), header = FALSE, quote="\"")
        subject_train <- read.table(paste(directory, "/UCI HAR Dataset/train/subject_train.txt", sep = ""), header = FALSE, quote="\"")
        
        #Reading test data
        X_test <- read.table(paste(directory, "/UCI HAR Dataset/test/X_test.txt", sep = ""), header = FALSE, quote="\"")
        y_test <- read.table(paste(directory, "/UCI HAR Dataset/test/y_test.txt", sep = ""), header = FALSE, quote="\"")
        subject_test <- read.table(paste(directory, "/UCI HAR Dataset/test/subject_test.txt", sep = ""), header = FALSE, quote="\"")
        
        #Reading activity_labels
        activity_labels <- read.table(paste(directory, "/UCI HAR Dataset/activity_labels.txt", sep = ""), header = FALSE, quote="\"")
        
        #Reading features
        features <- read.table(paste(directory, "/UCI HAR Dataset/features.txt", sep = ""), header = FALSE, quote="\"")
        
        #Concatenating data sets
        X <- rbind(X_train, X_test)
        y <- rbind(y_train, y_test)
        subject <- rbind(subject_train, subject_test)
        
        #Labeling the data set with descriptive variable names (replacing all "-" with "." and removing "(", ")" in names)
        features[,2] <- gsub("\\)", "", gsub("\\(", "", gsub("-",".",features[,2])))
        names(X) <- features[,2]
        
        #Adding column with subject, labeling the 'subject' column with descriptive variable name
        data1 <- cbind(X, subject)
        names(data1)[names(data1)=="V1"] <- "subject"
        
        #Merging features and activity data.frames, labeling the 'activity' column with descriptive variable name
        data1 <- cbind(data1, y)
        names(data1)[names(data1)=="V1"] <- "activity"
        
        #Using descriptive activity names to name the activities in the data set
        data1$activity <- as.factor(unlist(lapply(data1$activity, function (i) {activity_labels[activity_labels$V1 == i, ]$V2})))
        
        #Extracting only the measurements on the mean and standard deviation for each measurement
        data1 <- data1[, c(grep("mean()",names(data1)), grep("std()",names(data1)), which(names(data1) %in% c("activity", "subject")))]
        
        #Creating a independent tidy data set with the average of each variable for each activity and each subject
        data2 <- data.table(data1)
        data2 <- data2[, lapply(.SD, mean), by = .(subject, activity)]
        
        return(list(data_cleaned=data1, data_grouped=data2))
}
