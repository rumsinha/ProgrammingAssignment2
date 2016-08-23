The analysis script depends on data.table and dplyr packages.

The test dataset and the training dataset loaded into my local system: "C:/Big Data and Hadoop/R/R Tutorial/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/"


The supporting metadata features and the name of the activities loaded into the same folder as mentioned above.

Both training and test data sets are split up into subject, activity and features. They are present in three different files.

The script read training data and test data.

The two different datasets then combined into one complete dataset.

The script extracts only the measurements on the mean and standard deviation for each observation

The script extract the column indices that have either mean or std in them.

The script uses descriptive activity names to name the activities in the data set
The activity field in completeData is originally of numeric type. 
We need to change its type to character so that it can accept activity names. 
The activity names are taken from metadata activityLabels.

The script creates tidyData as a data set with average for each activity and subject. 
Then, we order the enties in tidyData and write it into data file Tidy.txt that contains the processed data.