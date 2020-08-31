
## Download the dataset
if(!dir.exists("./UCI HAR Dataset")){
  if(!dir.exists("./data.zip")){
    download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip",
                  destfile = "./data.zip")
  }
  unzip("./data.zip")
}


## Read the x and y train and test data into data.tables

xtestdata <- read.table("./UCI HAR Dataset/test/X_test.txt")
ytestdata <- read.table("./UCI HAR Dataset/test/y_test.txt")
xtraindata <- read.table("./UCI HAR Dataset/train/X_train.txt")
ytraindata <- read.table("./UCI HAR Dataset/train/y_train.txt")
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

## convert to dplyr tibble
if("dplyr" %in% rownames(installed.packages()) == FALSE) {
  install.packages("dplyr")
}
library(dplyr)
xtestdata <- tibble::as_tibble(xtestdata)
ytestdata <- tibble::as_tibble(ytestdata)
xtraindata <- tibble::as_tibble(xtraindata)
ytraindata <- tibble::as_tibble(ytraindata)
trainsubject <- tibble::as_tibble(trainsubject)
testsubject <- tibble::as_tibble(testsubject)

## merge test and train data
xdata <- xtraindata %>% add_row(xtestdata)
ydata <- ytraindata %>% add_row(ytestdata)
subject <- trainsubject %>% add_row(testsubject)

rm("xtestdata", "xtraindata", "ytestdata", "ytraindata","trainsubject", "testsubject")

## read variable names
vnames <- read.table("./UCI HAR Dataset/features.txt")
activitynames <- read.table("./UCI HAR Dataset/activity_labels.txt")
vnames <- tibble::as_tibble(vnames)
vnames$V2 <- tolower(vnames$V2) # convert to lower case


activitynames <- tibble::as_tibble(activitynames)

## filter out mean and std variables with using stringr package
if("stringr" %in% rownames(installed.packages()) == FALSE) {
  install.packages("stringr")
}
library(stringr)
xdata <- xdata%>%select(filter(vnames, str_detect(V2, "mean\\(\\)|std\\(\\)"))$V1)

## Renaming the variables
vnames$V2 <-sapply(vnames$V2, 
       function(x){gsub("[^[:alnum:][:blank:]+?&/\\]", "", x)})
colnames(xdata) <- vnames$V2


## using descriptive activity names
## convert ydata from (int) to represent activity create column with each activity name
## and assign 1 if true and 0 if false
xdata <- mutate(xdata,
      activity = sapply(ydata$V1, function(x){as.character(activitynames$V2[x])}),
      !!as.character(activitynames$V2[1]) := sapply(ydata$V1, function(x){if (x==1) 1 else 0}),
      !!as.character(activitynames$V2[2]) := sapply(ydata$V1, function(x){if (x==2) 1 else 0}),
      !!as.character(activitynames$V2[3]) := sapply(ydata$V1, function(x){if (x==3) 1 else 0}),
      !!as.character(activitynames$V2[4]) := sapply(ydata$V1, function(x){if (x==4) 1 else 0}),
      !!as.character(activitynames$V2[5]) := sapply(ydata$V1, function(x){if (x==5) 1 else 0}),
      !!as.character(activitynames$V2[6]) := sapply(ydata$V1, function(x){if (x==6) 1 else 0}))

xdata <- mutate(xdata, subject = subject, .before = 1)

# write.csv(xdata, "./tidy_data.csv")

## group by to summarize (create independent data)
xdata <- group_by(xdata, activity, subject)
xdata <- summarise(xdata, across(everything(), mean))
write.csv(xdata, "./tidy_data_summarized.csv")