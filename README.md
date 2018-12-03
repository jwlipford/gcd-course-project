# gcd-course-project

The course project for the third course, Getting and Cleaning Data, in Coursera's Data Science specialization. Deals with human activity recognition using smartphones.

### Links (from instructions):

[Data description](http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones)

[Dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

### Original data

UCI_HAR_analysis is an analysis of a [dataset](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip) that contains information from an experiment in the field of wearable computing. In this experiment, 30 volunteers ("subjects") were selected, and each performed six activities -- walking, walking upstairs, walking downstairs, sitting, standing, and laying -- with a smartphone attached to their hip. The smartphone's accelerometer and gyroscope recorded information at regular time intervals while the subjects performed their activities, generating several records for each subject-activity pair. For each such record, hundreds of statistics -- means, standard deviations, mins, maxs, etc. -- were calculated. These data were later split by volunteer into two groups: test, which contained 9 volunteers (30% of them), and train, which contained 21 volunteers (70% of them). For more information, see README.txt in the above dataset.

In the original dataset, vectors of subjects, activities, and statistic names are contained in files separate from the main data. Names of statistics are contained in features.txt, names of subjects are contained in subject_train.txt and subject_test.txt, and the main data are contained in two main data tables, X_train.txt and X_test.txt. Additionally, vectors of activity _numbers_ (integers from 1 to 6) are provided in y_train.txt and y_test.txt, and the six strings corresponding to the numbers are recorded in activity_labels.txt. In my analysis table, UCI_HAR_analysis.txt, the two main tables are combined back together; all activities are recorded as strings; and subjects, activity strings, and statistic names are included directly in the table.

In the original dataset, statistic names are stored in column headers, but in my analysis table, I have gathered them into a single column (I have used the narrow format for tidy data). Further, I have extracted only statistics related to means or standard deviations (86 total). Further, to make them easier to type, I have converted statistic names to lowercase and removed non-letter characters.

### What is analyzed

For each combination of a subject, an activity, and a statistic, I have calculated the _means_ across time of the values for that combination. See the Code Book for more details. 

### Explanation of script (how UCI_HAR_analysis.txt is generated):

I perform my analysis in a single script, run_analysis.R. This script uses two non-standard packages: `dplyr` and `tidyr`.

The script first creates a data directory, if it does not exist already, and then downloads and unzips the dataset from the link given above to the data directory. It prints the date downloaded to the console.

Next, a vector `col_names` is created from the file features.txt. To make them easier to type, the names given in features.txt are converted to lowercase, and non-letter characters (hyphens, commas, periods, and parentheses) found therein are removed.

A vector of indices for the columns that will be extracted is created. Only columns with names that contain "mean" or "std" (standard deviation) are relevant to the analysis.

Vectors of subjects and activities are created from included files; they will be inserted as columns at the left of future tables (technically, `tibble`s created by `dplyr`) since they are not included in the main tables X_train.txt and X_test.txt.

The files X_train.txt and X_test.txt are imported as tables `training_set` and `test_set`. New tables `training_means_stds` and `test_means_stds` are created that include only the relevant columns (ones related to means or standard deviations) from the first two tables. Once these new tables are created, `training_set` and `test_set` are removed, since they are very large tables that take up a significant amount of a computer's RAM. `training_means_stds` and `test_means_stds` each have 86 columns.

Further tables `training` and `test` are created, in which subjects and activities are inserted as columns at the left of `training_means_stds` and `test_means_stds`. `training_means_stds` and `test_means_stds` are removed. `training` and `test` each have 88 columns.

Using the `rbind` function, `training` and `test` are combined into a single table `combined`. The `merge` function would not be appropriate here since the two tables have common columns but no common records.  `training` and `test` are removed.

A table `means` of is created by applying `dplyr`'s `group_by` and `summarize_all` functions and `tidyr`'s `gather` function to `combined`. `means` is in the narrow format for tidy data and has four columns: subject, activity, statistic, and mean.  `means` is written as a table to file UCI_HAR_analysis.txt. This file name is printed.
