
url<-"https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url,destfile="./data/Data.zip")
unzip(zipfile="./data/Data.zip",exdir="./data")
files<-list.files("./data/UCI HAR Dataset",recursive=TRUE)
datasubject_test<-read.table("./data/UCI HAR Dataset/test/subject_test.txt",header=FALSE)
datax_test<-read.table("./data/UCI HAR Dataset/test/X_test.txt",header=FALSE)
datay_test<-read.table("./data/UCI HAR Dataset/test/y_test.txt",header=FALSE)
datasubject_train<-read.table("./data/UCI HAR Dataset/train/subject_train.txt",header=FALSE)
datax_train<-read.table("./data/UCI HAR Dataset/train/X_train.txt",header=FALSE)
datay_train<-read.table("./data/UCI HAR Dataset/train/y_train.txt",header=FALSE)

datasubject<- rbind(datasubject_test, datasubject_train)
datax<- rbind(datax_test, datax_train)
datay<- rbind(datay_test, datay_train)

dim(datasubject)
dim(datax)
dim(datay)
names(datasubject)<-c("subject")
names(datay)<-c("activity")
names<-read.table("./data/UCI HAR Dataset/features.txt",header=FALSE)
names(datax)<-names$V2
dataone<-cbind(datasubject,datax,datay)
head(dataone)


index<-names$V2[grep("mean\\(\\)|std\\(\\)", names$V2)]
names_new<-c(as.character(index), "subject", "activity" )
data_new<-subset(dataone,select=names_new)

activity<-read.table("./data/UCI HAR Dataset/activity_labels.txt",header = FALSE)
data_new<-merge(data_new,activity,by.x="activity",by.y="V1",all.x=TRUE)
data_new<-data_new[,-1]
colnames(data_new)[68]<-"activity"

names(data_new)<-gsub("^t", "time", names(data_new))
names(data_new)<-gsub("^f", "frequency", names(data_new))
names(data_new)<-gsub("Acc", "Accelerometer", names(data_new))
names(data_new)<-gsub("Gyro", "Gyroscope", names(data_new))
names(data_new)<-gsub("Mag", "Magnitude", names(data_new))
names(data_new)<-gsub("BodyBody", "Body", names(data_new))


library(plyr)
data2<-aggregate(. ~subject + activity, data_new, mean)
data2<-data2[order(data2$subject,data2$activity),]
write.table(data2, file = "tidydata.txt",row.name=FALSE)
