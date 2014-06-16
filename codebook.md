Codebook
=================

We first describe the variables contained in the original dataset, then describe the variables appearing in the final tidy dataset, TidyData.txt. [The grader may wish to skip ahead to the Tidy Data section.]

Original Data
==============

The original data comes from the UCI HAR Dataset, available at 
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

In the study, conducted by Davide Anguita, Alessandro Ghio, Luca Oneto, Xavier Parra and Jorge L. Reyes-Ortiz, 30 subjects performed 6 activities (some multiple times) while wearing a Samsung Galaxy smartphone. The smartphone’s accelerometer and gyroscope were used to measure the movement of the phone. The subjects were divided into two subsets, training and testing subsets; the data for each subset appears in different subfolders, train and test.  The subject identification numbers are listed in the files train/subject_train.txt and test/subject_test.txt. The activity labels (1 through 6) appear in the files train/y_train.txt and test/y_test.txt. The rows of the two types of files match up; the first rows both describe the first experiment (subject and activity), the second rows describe the second experiment, etc. 
 
The smartphone recorded 3-axial raw signals tAcc-XYZ and tGyro-XYZ. The raw data of these measurements appears in the folders test\Inertial_Signals and train\Intertial_Signals. The 
acceleration and the acceleration after removing the effects of gravity are reported in total_acc_xyz.txt and body_acc_xyz.txt (where xyz stands for one of x, y or z, depending on the file). Each row of these datasets is a vector with 128 components, time measurements sampled as described in README.txt.

The file features_info.txt contains information about how the raw data was processed: “These time domain signals (prefix 't' to denote time) were captured at a constant rate of 50 Hz. Then they were filtered using a median filter and a 3rd order low pass Butterworth filter with a corner frequency of 20 Hz to remove noise. Similarly, the acceleration signal was then separated into body and gravity acceleration signals (tBodyAcc-XYZ and tGravityAcc-XYZ) using another low pass Butterworth filter with a corner frequency of 0.3 Hz. 

Subsequently, the body linear acceleration and angular velocity were derived in time to obtain Jerk signals (tBodyAccJerk-XYZ and tBodyGyroJerk-XYZ). Also the magnitude of these three-dimensional signals were calculated using the Euclidean norm (tBodyAccMag, tGravityAccMag, tBodyAccJerkMag, tBodyGyroMag, tBodyGyroJerkMag). 

Finally a Fast Fourier Transform (FFT) was applied to some of these signals producing fBodyAcc-XYZ, fBodyAccJerk-XYZ, fBodyGyro-XYZ, fBodyAccJerkMag, fBodyGyroMag, fBodyGyroJerkMag. (Note the 'f' to indicate frequency domain signals).” 

These signals were used to estimate variables of the following 33 feature vectors, each transformed to a [-1,1] scale (details were not provided in the descriptions, but this transform makes the measurements unit-less): 
tBodyAcc-X
tBodyAcc-Y
tBodyAcc-Z
tGravityAcc-X
tGravityAcc-Y
tGravityAcc-Z
tBodyAccJerk-X
tBodyAccJerk-Y
tBodyAccJerk-Z
tBodyGyro-X
tBodyGyro-Y
tBodyGyro-Z
tBodyGyroJerk-X
tBodyGyroJerk-Y
tBodyGyroJerk-Z
tBodyAccMag
tGravityAccMag
tBodyAccJerkMag
tBodyGyroMag
tBodyGyroJerkMag
fBodyAcc-X
fBodyAcc-Y
fBodyAcc-Z
fBodyAccJerk-X
fBodyAccJerk-Y
fBodyAccJerk-Z
fBodyGyro-X
BodyGyro-Y
BodyGyro-Z
fBodyAccMag
fBodyAccJerkMag
fBodyGyroMag
fBodyGyroJerkMag

A variety of new variables were computed by applying standard (and not so standard) transforms. This produced 561 summary variables for each record. We were particularly interested in the mean() and std() transforms; there were 66 of these, two for each of the variables listed above. The complete list of variables of each feature vector is available in 'features.txt’. The computed values can be found in the files train\X-train.txt and test\X-test.txt. 

Tidy Data Dataset Variables
===========================

To produce the tidy dataset (TidyData.txt) we first combined the various training and testing files to produce a raw dataset with 10299 and 68 columns (one listed the subject, one the activity, and the other 66 listed the mean or standard deviation of the 33 variables listed above). The exact details of how this was accomplished are documented in the file run_analysis.R. 

The TidyData.txt file contains a tidy dataset with 180 rows, one for each subject/activity pair. There are 68 columns (variables) in the dataset. The variable Subject records the subject number (1 through 30) and the variable Activity records the name of the activity (WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, or LAYING). The remaining 66 variables are The variable names are somewhat technical but are easily interpreted. For instance, the variable tBodyGyroJerk-mean()-Y is the  mean (or average) of the Jerk (the third derivative of position) of the body of the gyroscope in the Y-direction (see the Samsung Galaxy documentation for details about how this is measured) in the time domain, suitably transformed to the [-1,1] scale. This is computed across all the records with the subject and activity expressed in columns 1 and 2 of the row. There are also measurements that involve Fourier transforms (and a low pass band filter); these are denoted by f in place of the t in our example. Those variables including the string std() measure the standard deviation of the associated feature variable. For explicit descriptions of how the raw data was processed using R code, please see the file run_analysis.R at https://github.com/traves/DataCleaningProject.

