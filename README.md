# gcd-course-project
The course project for the third course, Getting and Cleaning Data, in Coursera's Data Science specialization. Deals with human activity recognition using smartphones. 

### Links (from instructions):

Data description: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

Dataset: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

### Explanation of output file

For an explanation of the output file UCI_HAR_analysis.txt, see the CodeBook.

### Explanation of script (how UCI_HAR_analysis.txt is generated):

I performed my analysis in a single script, run_analysis.R. This script uses one non-standard package: `dplyr`.

The script first creates a data directory, if it does not exist already, and then downloads and unzips the dataset from the above link to the data directory. It prints the date downloaded to the console.

Next, a vector `col_names` (which will be used as the third to 88th column names in the final analysis file) is created from the file features.txt. To tidy the variable names, the names given in features.txt are converted to lowercase, and non-letter characters (hyphens, commas, periods, and parentheses) found therein are removed.

A vector of indices for the columns that will be extracted is created. Only columns with names that contain "mean" or "std" (standard deviation) are relevant to the analysis. Vectors of subjects and activities are also created; they will be inserted as columns at the left of future tables (technically, `tibble`s created by `dplyr`) since they are not included in the main tables X_train.txt and X_test.txt.

The files X_train.txt and X_test.txt are imported as tables `training_set` and `test_set`. New tables `training_means_stds` and `test_means_stds` are created that extract only the relevant columns (ones related to means or standard deviations) from the first two tables. Once these new tables are created, `training_set` and `test_set` are removed, since they are very large tables that take up a significant amount of a computer's RAM. `training_means_stds` and `test_means_stds` each have 86 columns.

Further tables `training` and `test` are created, in which subjects and activities are inserted as columns at the left of `training_means_stds` and `test_means_stds`. `training_means_stds` and `test_means_stds` are removed. `training` and `test` each have 88 columns.

Using the `rbind` function, `training` and `test` are combined into a single table `combined`. The `merge` function would not be appropriate here since the two tables have common columns but no common records.  `training` and `test` are removed.

A table `means` of is created by applying `dplyr`'s `group_by` and `summarize_all` functions to `combined`. `means` is written as a table to file UCI_HAR_analysis.txt. This file name is printed.
