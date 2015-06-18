Getting and cleaning data Course Project

The purpose of this project is to demonstrate your ability to collect, work with, and clean a data set. 
The goal is to prepare tidy data that can be used for later analysis. You will be graded by your peers on a series of 
yes/no questions related to the project. 

You will be required to submit: 
1) a tidy data set as described below, 
2) a link to a Github repository with your script for performing the analysis, and 
3) a code book that describes the variables, the data, and any transformations or work that you performed to clean up the 
data called CodeBook.md. 
You should also include a README.md in the repo with your scripts. 
This repo explains how all of the scripts work and how they are connected.  

One of the most exciting areas in all of data science right now is wearable computing - see for example this article . Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained: 

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

Here are the data for the project: 

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

You should create one R script called run_analysis.R that does the following. 
Merges the training and the test sets to create one data set.
Extracts only the measurements on the mean and standard deviation for each measurement. 
 Uses descriptive activity names to name the activities in the data set
Appropriately labels the data set with descriptive variable names. 
From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and 
each subject.

SOLUTION STEPS & EXPLANATIONS

# The "dplyr" library is used to aggregate variables to create the tidy data.

library(dplyr)

# Reading Data:

testLabels <- read.table("UCI HAR DATASET/test/y_test.txt", col.names="label")
testSubjects <- read.table("UCI HAR DATASET/test/subject_test.txt", col.names="subject")
testData <- read.table("UCI HAR DATASET/X_test.txt")
trainLabels <- read.table("UCI HAR DATASET/train/y_train.txt", col.names="label")
trainSubjects <- read.table("UCI HAR DATASET/train/subject_train.txt", col.names="subject")
trainData <- read.table("UCI HAR DATASET/train/X_train.txt")

# Merging data using rbind & cbind
data <- rbind(cbind(testSubjects, testLabels, testData),
              cbind(trainSubjects, trainLabels, trainData))


# Reading the features
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

# Limiting features to mean and standard deviation
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# Incrementing by 2, as data has subjects and labels in the beginning
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]


# Reading the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# Replacing with label names
data.mean.std$label <- labels[data.mean.std$label, 2]


# Making a list of existing column names and feature names
good.colnames <- c("subject", "label", features.mean.std$V2)

# Tidying column and feature names (removing non-alphabetic characters & eliminating uppercase characters)
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))

colnames(data.mean.std) <- good.colnames


# Finding the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

# Writing the data for the course upload
write.table(format(aggr.data, scientific=T), "tidy.txt",
            row.names=F, col.names=F, quote=2)
