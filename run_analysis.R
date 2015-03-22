# run_analyis.R - Coursera Getting and Cleaning Data Project
#
# Using the UCI HAR Dataset create a tidy data set with the average of std and mean 
# variables for each activity and each subject
# 
# we make the assumption that the zip file has been downloaded, and unzipped
# and all the files are in place. We do a quick check for some of the
# files just in case.
#
# The dataset can be downloaded from
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
#

library(reshape2)

# steps 1 and 2 
# 1. merge all of the data into one large data frame
# 2. extract only mean and std-deviation measurements

combineData <- function () { 

  # sanity check, if we are missing features.txt or the test and train
  # directorys we don't have the data set

  if ( !file.exists("features.txt") | !file.exists("test") | !file.exists("train") ) {
    print("You do not appear to have the correct data downloaded")
    print("Download the dataset from https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip")
    quit() 
  }
 
  # read the feature names in
  
  featureNamesDf <- read.table("features.txt", sep = " ", 
                               col.names = c("FeatureID", "Feature"))
  
  # Read our test data in

  testSubjectDf <- read.table("test/subject_test.txt", 
                              col.names= c("SubjectID"))
  # read in our X_test values, we assign columnnames from featureNamesDf$Feature
  # repated again below for train values 
  testXValsDf <- read.table("test/X_test.txt", col.names = featureNamesDf$Feature)
  testActivityValsDf <- read.table("test/y_test.txt", col.names= c("ActivityID"))

  # colbind the three data frames together
  testDf <- cbind(testSubjectDf, testActivityValsDf, testXValsDf)

  # Read our train data in 
  
  trainSubjectDf <- read.table("train/subject_train.txt", col.names= c("SubjectID"))
  trainXValsDf <- read.table("train/X_train.txt", col.names = featureNamesDf$Feature)
  trainActivityValsDf <- read.table("train/y_train.txt", col.names= c("ActivityID"))
  
  # colbind the three data frames together
  trainDf <-cbind(trainSubjectDf, trainActivityValsDf, trainXValsDf) 

  # rbind our test and train data frames together
  ourDf <- rbind(testDf, trainDf)

  # bring ur data frame down to the mean and stds required
  # we have already added labels for SubjectID and ActivityID
  # so we also want to keep these, so we include them in our grepl
  #

  ourDf <- ourDf[grepl("SubjectID|ActivityID|std|mean", names(ourDf))]
  # eliminate the Freq values
  ourDf <- ourDf[!grepl("Freq", names(ourDf))]
  # return our dataframe
  ourDf
}


# load our combined data
combinedDf <- combineData()

# steps 3 and 4 
# we use the activity_labels.txt source as our descriptive activity names
# load these into a dataframe which we will then merge with our combined data
# data frame to provide labels.

activesNameDf <- read.table("activity_labels.txt", 
                            col.names = c("ActivityID", "Activity"))
newDf <- merge(combinedDf, activesNameDf)

# we also want to make our column names more readable, do a tidy up
# on the names we have read in

ourCols <- colnames(newDf)
ourCols <- gsub("\\.+std\\.+", "Std", ourCols)
ourCols <- gsub("\\.+mean\\.+", "Mean", ourCols)
colnames(newDf) <- ourCols

# step 5 
# creates an independent tidy data set with the average of each variable 
# for each activity and each subject.
#
# we will use the melt and dcast functions to create this dataframe
#
# firstly we need to set our ids and variables to use with melt

meltIds <- c("ActivityID", "Activity", "SubjectID")
meltVariables = setdiff(colnames(newDf), meltIds)

# we melt our dataframe and set our ids and variables
# refer to ?melt.data.frame for more details

meltedData <- melt(newDf, id=meltIds, measure.vars=meltVariables)

# recast our data, getting the average of each variable by 
# activity and subject

tidyData <- dcast(meltedData, Activity + SubjectID ~ variable, mean)

write.table(tidyData, "tidy-data.txt", row.name=FALSE)
