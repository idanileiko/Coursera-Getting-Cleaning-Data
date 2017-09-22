# Peer-graded Assignment: Getting and Cleaning Data Course Project

library(dplyr)

# Get data
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl, "dataset.zip", mode = "wb")
unzip("dataset.zip")

# Load training data
trainSubjects <- read.table("./UCI HAR Dataset/train/subject_train.txt")
trainSet <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainLabels <- read.table("./UCI HAR Dataset/train/y_train.txt")

# Load test data
testSubjects <- read.table("./UCI HAR Dataset/test/subject_test.txt")
testSet <- read.table("./UCI HAR Dataset/test/X_test.txt")
testLabels <- read.table("./UCI HAR Dataset/test/y_test.txt")

# Load activity labels and features
activity <- read.table("./UCI HAR Dataset/activity_labels.txt")
features <- read.table("./UCI HAR Dataset/features.txt")

# (1) Merges the training and the test sets to create one data set
trainData <- cbind(trainSubjects, trainSet, trainLabels)
testData <- cbind(testSubjects, testSet, testLabels)
data <- rbind(trainData, testData)
colnames(data) <- c("Subject", as.character(features[, 2]), "Activity")

# (2) Extracts only the measurements on the mean and standard deviation for each measurement
index <- grepl("Subject|mean|std|Activity", colnames(data))
data <- data[, index]

# (3) Uses descriptive activity names to name the activities in the data set
data$activity <- factor(data$activity, levels = activity[, 1], labels = activity[, 2])

# (4) Appropriately labels the data set with descriptive variable names
names <- colnames(data)
names <- gsub("^t", "Time", names)
names <- gsub("^f", "Freq", names)
names <- gsub("-mean", "_Mean", names)
names <- gsub("-std", "_StdDev", names)
names <- gsub("BodyBody", "Body", names)
colnames(data) <- names


# (5) Creates a second, independent tidy data set with the average of each variable for each activity and each subject
dataAvg <- group_by(data, Subject, Activity)
dataAvg <- summarize_all(dataAvg, funs(mean))
write.table(dataAvg, "tidyData.txt", row.names = FALSE)
