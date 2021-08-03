# First we load in some of the packages often used in this course

library(tidyverse)
library(lubridate)
library(data.table)


# We need to unzip the files. Setting the working directory where files (unzipped) are placed and then unzipping is first step 
wd<-setwd("~/coursera/R data science/cleaning data/peer_folder1/Cleaning-peer-assignemnet")

unzip(zipfile="~/coursera/R data science/cleaning data/peer_folder1/Cleaning-peer-assignemnet/getdata_projectfiles_UCI HAR Dataset.zip",exdir=wd)

# path to the zipped files need to be set and files need to be listed

pathdata = file.path("~/coursera/R data science/cleaning data/peer_folder1/Cleaning-peer-assignemnet", "UCI HAR Dataset")


files = list.files(pathdata, recursive=TRUE)

# step 1 loading in all the data- the headers are not given in raw data

xtrain = read.table(file.path(pathdata, "train", "X_train.txt"),header = FALSE)
ytrain = read.table(file.path(pathdata, "train", "y_train.txt"),header = FALSE)
subjecttrain = read.table(file.path(pathdata, "train", "subject_train.txt"),header = FALSE)
xtest = read.table(file.path(pathdata, "test", "X_test.txt"),header = FALSE)
ytest = read.table(file.path(pathdata, "test", "y_test.txt"),header = FALSE)
subjecttest = read.table(file.path(pathdata, "test", "subject_test.txt"),header = FALSE)
features = read.table(file.path(pathdata, "features.txt"),header = FALSE)
activitylabels = read.table(file.path(pathdata, "activity_labels.txt"),header = FALSE)

#The data needs to be tidy- mainly there should be names to the columns- column features are used for x

colnames(xtrain) = features[,2]
colnames(ytrain) = "activityId"
colnames(subjecttrain) = "subjectId"
colnames(xtest) = features[,2]
colnames(ytest) = "activityId"
colnames(subjecttest) = "subjectId"
colnames(activitylabels) <- c('activityId','activityType')


# next the datasets are merge by cbind followed by rbind
train_m = cbind(ytrain, subjecttrain, xtrain)
test_m = cbind(ytest, subjecttest, xtest)
all = rbind(train_m, test_m)

# step 2:next we need to only extract the relevant measures: mean and std
# reading all available variables
colNames = colnames(all)

colNames
#get mean and sd- as logical vector 
mean_and_std = (grepl("activityId" , colNames) | grepl("subjectId" , colNames) | grepl("mean.." , colNames) | grepl("std.." , colNames))

mean_and_std
#apply vector to all dataset
meanstd_with <- all[ , mean_and_std == TRUE]
meanstd_with

#now in step 3 using descriptive names to name the activities in the dataset

a_names_with = merge(meanstd_with, activitylabels, by='activityId', all.x=TRUE)


#all,meanstd_with are the answers to question 4

# finally in step 5 with previous datasets an independent tidy data set with the average of each variable for each activity and each subject is created
tidy<- a_names_with %>% group_by(subjectId,activityId) %>% summarise_all(mean,na.rm=TRUE) %>% arrange(subjectId, activityId)





#Saving the new data

#and keeping format as to begin with storing to folder
write.table(tidy, "tidy.csv", row.name=FALSE)
write.table(tidy, "tidy.txt", row.name=FALSE)




