# File name:  run_analysis.R
# Programmer: J W Lipford
# Script for the course project for Getting and Cleaning Data


require(dplyr)


url <- paste0( "https://d396qusza40orc.cloudfront.net/",
               "getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip" )
if( !file.exists("./data") ){ dir.create("./data") }
# I am not sure why the examples do not use dir.exists instead of file.exists,
# but I followed their lead.

download.file( url, destfile = "./data/Dataset.zip" )
datedownloaded <- date()
print( paste0( "Date downloaded: ", datedownloaded ) )

unzip( "./data/Dataset.zip", exdir = "./data" )
setwd( "./data/UCI HAR Dataset" ) # will change back later

col_names <- tolower(
    gsub( "[-,\\.\\(\\)]", "", read.table( "features.txt" )[,2] ) )
# col_names formatted as recommended in video "Editing Text Variables"
relevant_cols <- grep( "(mean)|(std)" , col_names ) # the ones to extract

training_subjects <- read.table( "./train/subject_train.txt" )[,1]
test_subjects     <- read.table( "./test/subject_test.txt" )[,1]

# I do not know what in the world 'y' means, but the following files refer to
# *activities performed*.
training_activity_nums <- read.table( "./train/y_train.txt" )[,1]
test_activity_nums     <- read.table( "./test/y_test.txt" )[,1]

activities_1to6     <- read.table( "activity_labels.txt" )[,2]
training_activities <- activities_1to6[ training_activity_nums ]
test_activities     <- activities_1to6[ test_activity_nums ]

# The following is a gigantic file!
training_set <- as_tibble( read.table( "./train/X_train.txt",
                                          colClasses = "numeric" ) )
names( training_set ) <- col_names
training_means_stds <- training_set[ , relevant_cols ]
rm( training_set ) # to save space

# The following is also a gigantic file!
test_set <- as_tibble( read.table( "./test/X_test.txt",
                                   colClasses = "numeric" ) )
names( test_set ) <- col_names
test_means_stds <- test_set[ , relevant_cols ]
rm( test_set )

setwd( "../.." ) # wd now at original location

training <- cbind( subject = training_subjects,
                   activity = training_activities, training_means_stds )
rm( training_means_stds )
test     <- cbind( subject = test_subjects,
                   activity = test_activities, test_means_stds )
rm( test_means_stds )

# According to README.txt, "The obtained dataset has been randomly partitioned
# into two sets, where 70% of the volunteers was selected for generating the
# training data and 30% the test data." Therefore, even though the instructions
# say to "merge" the two datasets, I think they actually mean "bind".
combined <- rbind( training, test )

rm( training, test ) # Still saving space


# Step 5 (data frame of grouped means):
means <- combined %>% group_by( subject, activity ) %>% summarize_all( mean )
write.table( means, file = "UCI_HAR_analysis.txt" )
print( "Analysis saved as UCI_HAR_analysis.txt" )
