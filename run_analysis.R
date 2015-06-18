

# read data
testLabels <- read.table("UCI HAR DATASET/test/y_test.txt", col.names="label")
testSubjects <- read.table("UCI HAR DATASET/test/subject_test.txt", col.names="subject")
testData <- read.table("UCI HAR DATASET/X_test.txt")
trainLabels <- read.table("UCI HAR DATASET/train/y_train.txt", col.names="label")
trainSubjects <- read.table("UCI HAR DATASET/train/subject_train.txt", col.names="subject")
trainData <- read.table("UCI HAR DATASET/train/X_train.txt")

# merge data using rbind & cbind
data <- rbind(cbind(testSubjects, testLabels, testData),
              cbind(trainSubjects, trainLabels, trainData))


# read the features
features <- read.table("features.txt", strip.white=TRUE, stringsAsFactors=FALSE)

# only retain features of mean and standard deviation
features.mean.std <- features[grep("mean\\(\\)|std\\(\\)", features$V2), ]

# select only the means and standard deviations from data
# increment by 2 because data has subjects and labels in the beginning
data.mean.std <- data[, c(1, 2, features.mean.std$V1+2)]


# read the labels (activities)
labels <- read.table("activity_labels.txt", stringsAsFactors=FALSE)
# replace labels in data with label names
data.mean.std$label <- labels[data.mean.std$label, 2]


# first make a list of the current column names and feature names
good.colnames <- c("subject", "label", features.mean.std$V2)
# then tidy that list
# by removing every non-alphabetic character and converting to lowercase
good.colnames <- tolower(gsub("[^[:alpha:]]", "", good.colnames))
# then use the list as column names for data
colnames(data.mean.std) <- good.colnames


# find the mean for each combination of subject and label
aggr.data <- aggregate(data.mean.std[, 3:ncol(data.mean.std)],
                       by=list(subject = data.mean.std$subject, 
                               label = data.mean.std$label),
                       mean)

# write the data for the course upload
write.table(format(aggr.data, scientific=T), "tidy.txt",
            row.names=F, col.names=F, quote=2)