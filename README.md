# Readme file for Getting & Cleaning Data Assignment #2

##Description of the Data

. The final data is grouped by volunteer_id (subject) and activity_name as per the activities mentioned in the activity_labels.txt file.
. The final result of the data is set as wide data where every row represents a unique pair of volunteer_id & activity_name, along with the means of all the variables that contain mean or std as per the description of the features.

##Sequence of the file
#Read data and load libraries
. load the dplyr library
. read data into different variables and rename them when necessary. e.g. activities
. read test data and labels
. read train data and labels
. read subjects

## Q1: merge the data into 1 dataset

. cbind test dataset with volunteer_id & acitivity
. cbind train dataset with volunteer_id & acitivity
. rbind test dataset and train dataset

## Q3: use descriptive activity names (from activity dataframe above) in final datasets
#note that I found it easier to not do the questions in sequence as it helped the flow more

. change activity code to activity name in the merged dataset called complete

## Q4: appropriately label the dataset with the names from the features.txt file
. read the feature names
. set a temp variable with the names
I've done this because I've merged the volunteer_id and activity_code first and I wanted the renaming to be correct

## Q2: extract measurements of mean and std
note that using select(contains()) did not work due to having special characters in the column names which it saw as duplicates
. get column IDs for mean and std then combine them in 1 vector along with 
. volunteer_id & activity_code

## complete_means_std is the final "tidy" dataset for the first part of this assignment (Q1 - Q4)

## Q5: create data set with the average of each variable for each activity and each subject

1. group by volunteer_id (subject) & activity_name
2. use summarise_each to get the mean of all the non-grouped variables

## write the final set to the text file assignment2.txt as required
