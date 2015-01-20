## This R Script is written to the specifications of the course project
##  description for the "Getting and Cleaning Data" Coursera course
##  Please see https://class.coursera.org/getdata-016 for details

## Prior to beginning this script, a specific copy of the data file was
## downloaded from
##   https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip
## This file was downloaded and unzipped into its own directory
##  directly beneath the ./03/data/ area that I set up for this class.

## We begin with a call to set our working directory to the top level 
## of the extracted dataset (note the following structure information)
## More information can be found about the contents of these files in the 
## top level README.txt and features_info.txt files.
#     > [UCI_HAR_Dataset]
#     >  > activity_labels.txt = 6 rows labels
#     >  > features.txt - 561 rows of label (187) * axis (3)
#     >  > features_info.txt - Informational text
#     >  > README.txt - Informational text
#     >  > [test]
#     >  >  > subject_test.txt
#     >  >  > X_test.txt
#     >  >  > y_test.txt
#     >  >  > [Inertial Signals]
#     >  >  >  > body_acc_(x/y/z)_test.txt
#     >  >  >  > body_gyro_(x/y/z)_test.txt
#     >  >  >  > total_acc_(x/y/z)_test.txt
#     >  > [train]
#     >  >  > subject_test.txt
#     >  >  > X_test.txt
#     >  >  > y_test.txt
#     >  >  > [Inertial Signals]
#     >  >  >  > body_acc_(x/y/z)_test.txt
#     >  >  >  > body_gyro_(x/y/z)_test.txt
#     >  >  >  > total_acc_(x/y/z)_test.txt

## The expected directory here is:
##  <root> = [UCI_HAR_Dataset] as shown above
##
##  To produce the output in your working directory while
##  keeping the data separate, copy the contents of the [UCI_HAR_Dataset]
##  into a temporary directory inside your working directory (such as "temp")
##  and store the name of that directory as the variable tmpdir
##    > tmpdir <- "temp"
##  
##  The output file will land in your working directory rather than inside the
##  data directory
##  
##  To read from data in another directory entirely (e.g. if you are using
##  your own project data and wish to read from there rather than inside the wd)
##  you can store the exact absolute path reference to the same folder mentioned
##  above (the [UCI_HAR_Dataset]) as the variable "topdir"
##    > topdir <- "C:\\myDataArea\\UCI HAR Dataset\\UCI HAR Dataset"
##      or
##    > topdir <- "/data/myCourseraData/UCI\ HAR\ Dataset/UCI\ HAR\ Dataset"
##  
##  The output file will still appear in your working directory
##  You should probably not use both of these, but I supposed you could.

# Initialize the directory to read the data from, default is here
dir <- "."

if (exists("topdir")) {
    dir <- topdir
}
if (exists("tmpdir") ){
  dir <- paste(dir,"/",tmpdir,sep="")
}

# I looked for the best practice way to ensure that the package below was both
# installed and loaded, this seems to be the best choice.  I used the reshape2
# package to meld and cast the tidy data set output
require("reshape2")

## Next we load the requisite tables into memory along with any preliminary
##  adjustments

activity_labels <- read.table(paste(dir,"/activity_labels.txt",sep=""))
colnames(activity_labels) <- c("activity","activityName")
a_lbls <- as.vector(activity_labels[,2]) # extracts just the activity names
features <- read.table(paste(dir,"/features.txt",sep=""))
f_lbls <- as.vector(features[,2]) # extracts just the feature names
## Some cleanup for f labels:
## These replacements just make their activity labels more like
## standard column labels.
f_lbls <- gsub("\\(\\)","",f_lbls)
f_lbls <- gsub("\\(",".",f_lbls)
f_lbls <- gsub(",",".",f_lbls)
f_lbls <- gsub("-",".",f_lbls)
f_lbls <- gsub("\\)$","",f_lbls)
f_lbls <- gsub("\\)",".",f_lbls)
f_lbls <- gsub("\\.+",".",f_lbls)
# for step 2, extract the columns that have either mean or std in them
mstd_cols <- as.logical(grepl("(mean)|(std)",f_lbls,ignore.case=TRUE))
# features_info.txt is basically a readme file with explanations

test_subject <- read.table(paste(dir,"/test/subject_test.txt",sep=""))
colnames(test_subject) <- "subject"
test_X <- read.table(paste(dir,"/test/X_test.txt",sep=""))
colnames(test_X) <- f_lbls
# select only those with means or standard deviations
test_X <- test_X[,mstd_cols]
test_Y <- read.table(paste(dir,"/test/y_test.txt",sep=""))
colnames(test_Y) <- "activity"

test <- cbind(test_subject,test_Y,test_X)

train_subject <- read.table(paste(dir,"/train/subject_train.txt",sep=""))
colnames(train_subject) <- "subject"
train_X <- read.table(paste(dir,"/train/X_train.txt",sep=""))
colnames(train_X) <- f_lbls
# select only those with means or standard deviations
train_X <- train_X[,mstd_cols]
train_Y <- read.table(paste(dir,"/train/Y_train.txt",sep=""))
colnames(train_Y) <- "activity"

train <- cbind(train_subject,train_Y,train_X)

rdf <- merge(activity_labels,rbind(test,train))
rdf <- rdf[,!(colnames(rdf)=="activity")]
#  pull all unneeded objects from memory to save room for processing
rm(list = c("activity_labels","a_lbls","features","f_lbls","mstd_cols","test_subject","test_X","test_Y","train_subject","train_X","train_Y","test","train","dir"))

rdf_melted <- melt(rdf,id=c("subject","activityName"))
tidy_rdf_mean <- dcast(rdf_melted, subject + activityName ~ variable, mean)

rm(rdf_melted)

write.table(tidy_rdf_mean,file="Project_tidy_data_output.txt",row.name=FALSE)
