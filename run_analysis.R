## read in the training data and the test data
SubjTrain <- read.table("subject_train.txt")
TrainY <- read.table("y_train.txt")
TrainX <- read.table("x_train.txt")

SubjTest <- read.table("subject_test.txt")
TestY <- read.table("y_test.txt")
TestX <- read.table("x_test.txt")

## read activity labels
actL <- read.table("activity_labels.txt")

## create a dataset with features that contain mean and std measurements
## exclude "meanFreq" values, clean up some names
feat <- read.table("features.txt")
feat <- feat[grepl("mean|std",feat$V2) & grepl("meanFreq",feat$V2)==0,]
feat$V2 <- gsub("-mean()-","Mean",feat$V2,fixed=TRUE)
feat$V2 <- gsub("-mean()","Mean",feat$V2,fixed=TRUE)
feat$V2 <- gsub("-std()-","Std",feat$V2,fixed=TRUE)
feat$V2 <- gsub("-std()","Std",feat$V2,fixed=TRUE)

# Make sure dplyr package is installed to use below
if(!("dplyr" %in% installed.packages()[,"Package"])) {
  install.packages("dplyr")
}
require(dplyr)

## combine the training and the test data and take the subset of columns found above
allData <- (rbind(TestX,TrainX))[,feat$V1]
names(allData) <- feat$V2

## combine subjects for train and test data
allSubj <- rbind(SubjTest,SubjTrain)
names(allSubj) <- "Subject"

## combine activities for train and test data and use descriptive activity names
allAct <- rbind(TestY,TrainY)
allAct$V1 <- actL$V2[allAct$V1]
names(allAct) <- "Activity"

## use cbind to combine the subjects, labels, and data
finData <- cbind(allSubj,allAct,allData)

##create the summarized data set (step 5)
#finData <- arrange(finData,Subject)
newTab <- group_by(finData,Subject,Activity)
newTab <- summarize_each(newTab,funs(mean))

##write the file
write.table(newTab,file="tidy_data.txt",row.names=FALSE)

