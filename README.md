# Getting And Cleaning Data
Peer-reviewed assignment for [Getting and Cleaning Data](https://www.coursera.org/learn/data-cleaning/home/welcome) on Coursera offered by Johns Hopkins University.

Everything is handled by running `run_analysis.R`. This will:
1. Download and extracts the [UCI Heart Rate Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip# ) to the folder **UCI HAR Dataset** in the current working directory. Skips this step if the folder already exists (but makes no checks as to the contents of this folder).
1. Merge the test and traing datasets together.
1. Extract only the mean and standard deviation columns for each measurement.
1. Join the various datasets together into a single table labels for activity type along with tidy measure names.
1. Write the tidy dataset to **UCI-HAR-dataset-clean.txt** in the local working directory and save the same data to the global variable `data`.
1. Write a second dataset which groups the above by subject and activity, averaging each measure, to **UCI-DAR-dataset-average.txt** and the global variable `data.averages`.
