
## Download the dataset
if(!dir.exists("./UCI HAR Dataset")){
  if(!dir.exists("./data.zip")){
    download.file("http://archive.ics.uci.edu/ml/machine-learning-databases/00240/UCI%20HAR%20Dataset.zip",
                  destfile = "./data.zip")
  }
  unzip("./data.zip")
}


testdata <- read.table("./data/UCI HAR Dataset/test/X_test.txt")

