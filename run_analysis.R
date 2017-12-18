## install.packages("reshape2")
library(reshape2)

# Load data from the file
filePathUCIHAR = "C:/Sharanya_R_Workspace/Assignments/Cleaning_Data_week4/UCI HAR Dataset"


# read train data into data frames
subject_train <- read.table("./train/subject_train.txt")
X_train <- read.table("./train/X_train.txt")
y_train <- read.table("./train/y_train.txt")

# read test data into data frames
subject_test <- read.table("./test/subject_test.txt")
X_test <- read.table("./test/X_test.txt")
y_test <- read.table("./test/y_test.txt")
## str(y_test)

# add column name for subject files
names(subject_train) <- "subjectID"
names(subject_test) <- "subjectID"

# add column names for measurement files
featureNames <- read.table("./features.txt")
names(X_train) <- featureNames$V2
names(X_test) <- featureNames$V2

# add column name for label files
names(y_train) <- "activity"
names(y_test) <- "activity"


## Merge the training and the test sets to create one data set
##train2 <-  dplyr::left_join(subject_train, y_train) %>%  dplyr::left_join(.,X_train)
train <- cbind(subject_train, y_train, X_train)
test <- cbind(subject_test, y_test, X_test)
combined <- rbind(train, test)

# determine which columns contain "mean()" or "std()" for each measurement
meanstdcols <- grepl("mean\\(\\)", names(combined)) |
               grepl("std\\(\\)", names(combined))
meanstdcols[1:2] <- TRUE
combined <- combined[, meanstdcols]

# naming the activities accordingly
combined$activity <- factor(combined$activity, labels=c("Walking", "Walking Upstairs", 
                                                        "Walking Downstairs", "Sitting", 
                                                        "Standing", "Lying"))


## create the independant tidy data set with the average of each variable 
## for each activity and each subject
meltedData<- melt(combined, id=c("subjectID","activity"))
tidyData <- dcast(meltedData, subjectID+activity ~ variable, mean)
##str(tidyData)

# write the tidy data set to a file
##write.csv(tidyData, "tidyData.csv", row.names=FALSE)
write.table(tidyData, "tidyData.txt", row.names=FALSE)
