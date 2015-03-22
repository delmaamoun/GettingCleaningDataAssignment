## load dplyr library
library(dplyr)

## read data into different variables ##
        ##read activity
        activity<-read.table("activity_labels.txt",header = FALSE)
        ##rename activity headers
        activity =  rename(.data = activity, activity_code = V1, activity_name = V2)
        
        ##read subject, data, label files from test and train datasets
        ##test
        subject_test<-read.table("test/subject_test.txt",header = FALSE)
        y_test<-read.table("test/y_test.txt",header = FALSE)
        x_test<-read.table("test/x_test.txt",header = FALSE)
        ##train
        subject_train<-read.table("train/subject_train.txt",header = FALSE)
        y_train<-read.table("train/y_train.txt",header = FALSE)
        x_train<-read.table("train/x_train.txt",header = FALSE)
        
        ##rename y_train/y_test header as activity
        y_train = rename(y_train, activity_code = V1)
        y_test = rename(y_test, activity_code = V1)
        
        ##rename subject_test/subject_train header as Volunteer_id
        subject_train = rename(subject_train, volunteer_id = V1)
        subject_test = rename(subject_test, volunteer_id = V1)
        
## Q1: merge the data into 1 dataset ##
        
        ##cbind test dataset with volunteer_id & acitivity
        test_total<- cbind(subject_test, y_test, x_test)
        ##cbind train dataset with volunteer_id & acitivity
        train_total<- cbind(subject_train, y_train, x_train)
        ##rbind test dataset and train dataset
        complete<- rbind(train_total, test_total)

## Q3: use descriptive activity names (from activity dataframe above) in final datasets ##
        ##change activity code to activity name in the final dataset
        y_test2<- merge(y_test, activity)
        y_train2<- merge(y_train, activity)
        activity_names<- rbind(y_train2, y_test2)
        complete<- mutate(complete, activity_code = activity_names$activity_name)
        complete = rename(complete, activity_name = activity_code)
        
## Q4: appropriately label the dataset with the names from the features.txt file ##
        ##read the feature names 
        feature_names<- read.table("features.txt",stringsAsFactors = FALSE)
        ##set a temp variable with the names
        ##I've done this because I've merged the volunteer_id and activity_code first
        ##and I wanted the renaming to be correct
        a<- names(complete)
        a[3:563]<- feature_names$V2
        names(complete)<- a
        rm(a)
        
## Q2: extract measurements of mean and std ##
        ##note that using select(contains()) did not work due to having special characters
        ##in the column names which it saw as duplicates
        ##get column IDs for mean and std then combine them in 1 vector along with 
        ##volunteer_id & activity_code
        col_index1<- grep("mean", x = names(complete))
        col_index2<- grep("std", x = names(complete))
        total_col<- c(1,2,col_index1, col_index2)
        complete_means_std<- complete[,total_col]
        
## complete_means_std is the final "tidy" dataset for the first part of this assignment (Q1 - Q4)
        
## Q5: create data set with the average of each variable for each activity and each subject
        ##1. group by volunteer_id (subject) & activity_name
        ##2. use summarise_each to get the mean of all the non-grouped variables
        ##result looks like:
        ## volunteer_id    activity_name tBodyAcc-mean()-X tBodyAcc-mean()-Y tBodyAcc-mean()-Z tGravityAcc-mean()-X
        ##1             1          WALKING         0.2656969       -0.01829817        -0.1078457            0.7448674
        ##2             2          WALKING         0.2731131       -0.01913232        -0.1156500            0.6607829
        ##3             3          WALKING         0.2734287       -0.01785607        -0.1064926            0.7078144
        ##4             4          WALKING         0.2770345       -0.01334968        -0.1059161            0.7314565
        ##5             4 WALKING_UPSTAIRS         0.2696859       -0.01710851        -0.1100534            0.6673775
        ##6             5          WALKING         0.2791780       -0.01548335        -0.1056617            0.6981537
        ##7             6          WALKING         0.2694342       -0.01639111        -0.1179007            0.6705062
        ##8             6 WALKING_UPSTAIRS         0.2801791       -0.02069496        -0.1109400            0.7369519

        
        ans<- complete_means_std %>%
                group_by(volunteer_id,activity_name) %>%
                summarise_each(funs(mean))
        
## writing the final set to the text file assignment2.txt as required
        utils::write.table(x = ans, file = "assignment2.txt", row.names = FALSE)
        
