install.packages('data.table')
install.packages('dplyr')
library(data.table)
library(dplyr)

#The supporting metadata in this data are the name of the features and the name of the activities
featureNames <- read.table("C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt")
activityLabels <- read.table("C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt", header = FALSE)

#Both training and test data sets are split up into subject, activity and features. They are present in three different files.

#Read training data

dataSubjectTrain <- read.table("C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt", header = FALSE)
dataActivityTrain <- read.table("C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt", header = FALSE)
dataFeaturesTrain <- read.table("C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt", header = FALSE)

#Read test data

dataSubjectTest <- read.table("C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt", header = FALSE)
dataActivityTest <- read.table("C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt", header = FALSE)
dataFeaturesTest <- read.table("C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt", header = FALSE)

#We can use combine the respective data in training and test data sets corresponding to subject, activity and features. The results are stored in subject, activity and features.

subjectData <- rbind(dataSubjectTrain, dataSubjectTest)
activityData <- rbind(dataActivityTrain, dataActivityTest)
featuresData <- rbind(dataFeaturesTrain, dataFeaturesTest)

#Naming the columns

#The columns in the features data set can be named from the metadata in featureNames

colnames(featuresData) <- t(featureNames[2])

#Merge the data

#The data in features,activity and subject are merged and the complete data is now stored in completeData.

colnames(activityData) <- "Activity"
colnames(subjectData) <- "Subject"
completeData <- cbind(featuresData,activityData,subjectData)

names(completeData)

#Extracts only the measurements on the mean and standard deviation for each measurement(for each observation)

#Extract the column indices that have either mean or std in them.

columnsWithMeanSTD <- grep(".*mean.*|.*std.*", names(completeData), ignore.case=TRUE)
names(completeData[columnsWithMeanSTD])

# Taking only measurements for the mean and standard deviation and add "subject","activityNum"
dataFeaturesMeanStd <- union(c("Subject","Activity"), names(completeData[columnsWithMeanSTD]))
dataFeaturesMeanStd
completeData<- subset(completeData,select=dataFeaturesMeanStd) 

names(completeData)

View(completeData)

#Uses descriptive activity names to name the activities in the data set
#The activity field in extractedData is originally of numeric type. 
#We need to change its type to character so that it can accept activity names. 
#The activity names are taken from metadata activityLabels.

completeData$Activity <- as.character(completeData$Activity)

for (indx in 1:6){
  completeData$Activity[completeData$Activity == indx] <- as.character(activityLabels[indx,2])
}

#We need to factor the activity variable, once the activity names are updated.

completeData$Activity <- as.factor(completeData$Activity)

#Appropriately labels the data set with descriptive variable names

#current names

names(completeData)

names(completeData)<-gsub("Acc", "Accelerometer", names(completeData))
names(completeData)<-gsub("Gyro", "Gyroscope", names(completeData))
names(completeData)<-gsub("BodyBody", "Body", names(completeData))
names(completeData)<-gsub("Mag", "Magnitude", names(completeData))
names(completeData)<-gsub("^t", "Time", names(completeData))
names(completeData)<-gsub("^f", "Frequency", names(completeData))
names(completeData)<-gsub("tBody", "TimeBody", names(completeData))
names(completeData)<-gsub("-mean()", "Mean", names(completeData), ignore.case = TRUE)
names(completeData)<-gsub("-std()", "STD", names(completeData), ignore.case = TRUE)
names(completeData)<-gsub("-freq()", "Frequency", names(completeData), ignore.case = TRUE)
names(completeData)<-gsub("angle", "Angle", names(completeData))
names(completeData)<-gsub("gravity", "Gravity", names(completeData))


names(completeData)

#From the data set in step 4, creates a second, 
#independent tidy data set with the average of each variable for each activity and each subject

#set Subject as a factor variable.

completeData$Subject <- as.factor(completeData$Subject)
completeData <- data.table(completeData)

#We create tidyData as a data set with average for each activity and subject. 
#Then, we order the enties in tidyData and write it into data file Tidy.txt 
#that contains the processed data.

tidyData <- aggregate(. ~Subject + Activity, completeData, mean)
tidyData <- tidyData[order(tidyData$Subject,tidyData$Activity),]
write.table(tidyData, file = "C:/Big Data and Hadoop/R/R Tutorial/Tidy.txt", row.names = FALSE)
