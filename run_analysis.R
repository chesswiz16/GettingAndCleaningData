###############################################################
# run_analysis.R
#
# Generates a tidy dataset from the raw data available from
# UCI's machine learning data repository. Performs the 
# following steps:
#
# 0. Download the raw data and unpack into 'UCI HAR Dataset'
# if it does not already exist from 
# https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip# 
# 1. Merge the training and the test sets to create one 
# data set.
# 2. Extract only the measurements on the mean and standard 
# deviation for each measurement.
# 3. Use descriptive activity names to name the activitues in 
# the data set.
# 4. Appropriately label the data set with descriptive 
# activity names.
# 5. Creates a second, independent tidy data set with the average 
# of each variable for each activity and each subject.
###############################################################

# 0. Unpack the UCI dataset in current working directory if it does not already exist.
data.directory <- './UCI HAR Dataset'
data.exists <- file.info(data.directory)$isdir
if (is.na(data.exists) || !data.exists) {
  data.url <- 'https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip'
  dir.create(data.directory)
  data.path <- paste(data.directory, 'UCI-HAR-dataset.zip', sep = '/')
  download.file(data.url, data.path)
  unzip(data.path)
}

# 1. Merge the training and the test sets to create one data set.
data.merged <- list()
for (tag in c('X', 'Y', 'subject')) {
  train <- read.table(paste(data.directory, gsub('%s', tag, 'train/%s_train.txt'), sep = '/'))
  test <- read.table(paste(data.directory, gsub('%s', tag, 'test/%s_test.txt'), sep = '/'))
  data.merged[[tag]] <- rbind(train, test)
}

# 2. Extract only the measurements on the mean and standard deviation for each measurement.
features <- read.table(paste(data.directory, 'features.txt', sep = '/'))
# Mean and std dev measures will contain -mean() or -std() in the column name
measures <- grep("-mean\\(\\)|-std\\(\\)", features[, 2])
data.measures <- data.merged[['X']][, measures]

# 3. Use descriptive activity names to name the activities in the data set.
names <- tolower(features[measures, 2])
# Remove the annoying () on the end of every measure
names <- gsub('\\(|\\)', '', names)
names(data.measures) <- names
# Get cleaned activity labels and update the data set
activities <- read.table(paste(data.directory, 'activity_labels.txt', sep = '/'))
activities[, 2] <- gsub('_', '', tolower(activities[, 2]))
data.activity <- data.merged[['Y']]
data.activity[, 1] <- activities[data.activity[, 1], 2]

# 4. Appropriately label the data set with descriptive activity names
data.subject <- data.merged[['subject']]
colnames(data.subject) <- ('subject')
colnames(data.activity) <- c('activity')
# Stack everything together
data <- cbind(data.subject, data.activity, data.measures)
# Write the cleaned dataset.
write.table(data, 'UCI-HAR-dataset-clean.txt')

# 5. Create a second, independent tidy data set with the average of each variable for each activity and each subject.
data.averages <- aggregate(data[, names(data) != c('subject', 'activity')], by = list(activity = data$activity, subject=data$subject), FUN = mean)
write.table(data.averages, 'UCI-HAR-dataset-averages.txt')