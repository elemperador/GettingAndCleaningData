## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Load required packages
require("data.table")
require("dplyr")

# Load data
labels <- read.table("./UCI HAR Dataset/activity_labels.txt")[,2]
features <- read.table("./UCI HAR Dataset/features.txt")[,2]

testSetX <- read.table("./UCI HAR Dataset/test/X_test.txt")
testSetY <- read.table("./UCI HAR Dataset/test/y_test.txt")
subjectTest <- read.table("./UCI HAR Dataset/test/subject_test.txt")

testSetY[,2] <- labels[testSetY[,1]]
names(testSetY) <- c("Activity_ID", "Activity_Name")
names(subjectTest) <- "subject"

trainSetX <- read.table("./UCI HAR Dataset/train/X_train.txt")
trainSetY <- read.table("./UCI HAR Dataset/train/y_train.txt")
subjectTrain <- read.table("./UCI HAR Dataset/train/subject_train.txt")

trainSetY[,2] = labels[trainSetY[,1]]
names(trainSetY) = c("Activity_ID", "Activity_Name")
names(subjectTrain) = "subject"

# Name sets
names(testSetX) <- features
names(trainSetX) <- features

# Extract Information
measurementsIndex <- grep("mean|std", features)
testSetX <- testSetX[,measurementsIndex]
trainSetX = trainSetX[,measurementsIndex]

# Merge Data
mergedData <- rbind(cbind(subjectTest, testSetY, testSetX), 
             cbind(subjectTrain, trainSetY, trainSetX))

# Create new dataset
dataDplr <- tbl_df(mergedData)

# Calculate Means and store in indepedent tidy dataset
tidyDataSet <- dataDplr %>% group_by(Activity_Name) %>% summarise_each(funs(mean))

write.table(tidyDataSet, file = "./tidyDataSet.txt")