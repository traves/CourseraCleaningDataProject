# This is an R script that takes the test and 
# training datasets from the UCI HAR Dataset folder
# and merges them with the aim of producing 
# a tidy data set consisting of one row for each 
# subject and activity pair. The columns of the final
# data set contain information identifying the subject,
# the activity type, and also the average of each 
# measurement involving a mean or standard deviation
# in the original data set. There are 561 variables in
# the original dataset (each is obtained from 128 
# measurements in the original study) but only 66 
# are means or standard deviations. For details, see
# the file "features_info.txt" in the UCI HAR Dataset 
# folder. 
#
# This file is intended to be run with the working
# directory containing the contents of the extracted
# folder UCI HAR Dataset. For example, the user might
# first try a command such as: 
# setwd("/Users/traves/Desktop/Cleaning Data/project/UCI HAR Dataset")
# to set the working directory properly. 
#
# We read in the test subject and training subject 
# data and then bind them into a single variable,
# Subject.
#
TestSubject<-read.table("./test/subject_test.txt")
TrainSubject<-read.table("./train/subject_train.txt")
Subject = rbind(TestSubject,TrainSubject)
#
# We read in the test activity and training activity 
# data and then bind them into a single variable,
# Activity.
#
TestActivity <- read.table("./test/y_test.txt")
TrainActivity <- read.table("./train/y_train.txt")
Activity = rbind(TestActivity,TrainActivity)
#
# We read in the test feature and training feature 
# data (the 561 computed variables based on the 
# measurements on each subject/activity pair) and 
# then bind them into a single variable,
# Feature. The data frame Feature is the answer 
# to the first question/instruction in the 
# project description.
#
TestFeature <- read.table("./test/X_test.txt")
TrainFeature <- read.table("./train/X_train.txt")
Feature = rbind(TestFeature,TrainFeature)
#
# For step 2, we use the file "features.txt" to find
# which of the 561 variables are computed using a mean
# or standard deviation of the 33 variables listed in 
# paragraph 4 of the file "features_info.txt". We use 
# the stringr package to search the variable names
# for the substring "mean()" or "std()". The script 
# checks to see if this package is installed and if 
# it is not installed, then the script installs the 
# package. The list ColsWithMeansOrStd contains a list 
# of the columns of Features that we are interested in. 
# We construct the data.frame FeaturesMeanOrStd 
# consisting only of the required columns/variables. 
# The data set FeaturesMeanOrStd satisfies the 
# requirements in step 2 of the project description. 
#
FeaturesNames = read.table("./features.txt")
if (!"stringr" %in% installed.packages()) install.packages("stringr")
require("stringr")
ColsWithMeansOrStd=which(str_detect(FeaturesNames$V2, fixed("mean()")) | str_detect(FeaturesNames$V2, fixed("std()")))
FeaturesMeansOrStd = Feature[,ColsWithMeansOrStd]
#
# We move on to step 3 in the project description. 
# In order to provide more readable data, we first 
# determine which activity names correspond to which 
# numerical activity labels and then construct a new 
# variable ActivityNames which records the proper 
# activity name in place of each numerical activity 
# label. The list ActivityNames satisfies step 3 of 
# the project description and will be used to build 
# the final tidy dataset. 
#
ActivityLabels1 <- read.table("./activity_labels.txt")
ActivityLabels = ActivityLabels1[,2]
replace_activity = function(x){
  return(ActivityLabels[x])
}
ActivityNames = sapply(X=Activity$V1,FUN=replace_activity)
#
# For step 4, we build the list of feature column names 
# (FeatureColNames), taking the feature names from the  
# list of feature names that involve a mean() or std() 
# computation. The variable names are somewhat technical
# but are easily interpreted. For instance, the variable
# tBodyGyroJerk-mean()-Y is a transformation (to a [-1,1]
# scale) of the mean (or average) of the Jerk (the third 
# derivative of position) of the body of the gyroscope in
# the Y-direction (see the Samsung Galaxy documentation 
# for details about how this is measured) in the time 
# domain. There are also measurements that involve Fourier
# transforms (and a low pass band filter); these are 
# denoted by f in place of the t in our example. We rename 
# the variables in our FeaturesMeansOrStd data frame 
# with these descriptive names to satisfy the requirement
# in step 4 of the project description.
#
FeatureColNames <- sapply(FeaturesNames$V2[ColsWithMeansOrStd],as.character)
names(FeaturesMeansOrStd) = FeatureColNames
#
# Finally we are ready to produce the tidy data frame 
# required in step 5 of the project description. First we 
# bind the Subject, ActivityNames, and FeaturesMeansOrStd 
# dataframes into a single dataframe, RawData. 
#
RawData <- data.frame(Subject,ActivityNames,FeaturesMeansOrStd)
ColNames <- append(c("Subject","Activity"),names(FeaturesMeansOrStd))
names(RawData) = ColNames
#
# Now we build an empty dataframe with a column for each
# column in the RawData dataframe. Then we loop over
# the subject/activity pairs and create a row starting
# with the subject/activity identifiers and then consisting
# of the average of the remaining variables in the RawData
# dataframe. 
#
TidyData=data.frame(matrix(vector(),0,length(ColNames)))
for (s in 1:30){
  for (a in ActivityLabels){
    row = cbind(s,a)
    for (v in 3:length(ColNames)){
      avg = mean(RawData[which(RawData$Subject==s & RawData$Activity==a),v])
      row = cbind(row,avg)
    }
    TidyData = rbind(TidyData,row)
  }
}
#
# We add the prefix "avg-" to the name of each averaged 
# variable in the TidyData dataframe. 
#
for (v in 3:length(ColNames)){
  ColNames[v]=paste("avg-",ColNames[v],sep="")
}
names(TidyData) = ColNames
#
# The dataframe TidyData satisfies the requirements of 
# step 5 in the project description. We write this 
# dataframe to the file "TidyData.txt" in the working 
# directory so that it can be uploaded as part of the 
# solution to the project. 
#
write.table(TidyData,file="./TidyData.txt",row.names=FALSE,quote=FALSE,sep="\t")