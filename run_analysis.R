library(reshape2)

# Load activity labels + features
activityLabels = read.csv("UCI HAR Dataset/activity_labels.txt", sep="", header=FALSE)
features <- read.csv("UCI HAR Dataset/features.txt", sep="", header=FALSE)

# Extract mean and std
featureIndex <- grep(".*mean.*|.*std.*", features[,2])
featureNames <- features[featureIndex,2]
featureNames = gsub('-mean', 'Mean', featureNames)
featureNames = gsub('-std', 'Std', featureNames)
featureNames <- gsub('[-()]', '', featureNames)

# Load the datasets
train <- read.csv("UCI HAR Dataset/train/subject_train.txt", sep="", header=FALSE)
train[,ncol(train)+1] <- read.csv("UCI HAR Dataset/train/Y_train.txt", sep="", header=FALSE)
trainData <- read.csv("UCI HAR Dataset/train/X_train.txt", sep="", header=FALSE)
train <- cbind(train,trainData[featureIndex])

test <- read.csv("UCI HAR Dataset/test/subject_test.txt", sep="", header=FALSE)
test[,ncol(test)+1] <- read.csv("UCI HAR Dataset/test/Y_test.txt", sep="", header=FALSE)
testData <- read.csv("UCI HAR Dataset/test/X_test.txt", sep="", header=FALSE)
test <- cbind(test,testData[featureIndex])

# merge datasets
Data <- rbind(train, test)
colnames(Data) <- c("subject", "activity", featureNames)

# turn activities & subjects into factors
Data$activity <- factor(Data$activity, levels = activityLabels[,1], labels = activityLabels[,2])
Data$subject <- as.factor(Data$subject)

melted <- melt(Data, id = c("subject", "activity"))
meanData <- dcast(melted, subject + activity ~ variable, mean)

write.table(meanData, "tidy.txt", row.names = FALSE, quote = FALSE)