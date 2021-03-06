# Code Book

The code book for UCI_HAR_analysis.txt, which is generated by the R script run_analysis.R. This file is tidied in narrow format, so it only has four columns.

#### subject

Integer 1-30

The number of the volunteer who performed the test

#### activity

One of six character vectors: WALKING, WALKING_UPSTAIRS, WALKING_DOWNSTAIRS, SITTING, STANDING, LAYING

The activity the subject was performing

#### statistic

Character vector

In the original dataset, hundreds of statistics (or "variables") were calculated at different moments in time (separated by regular intervals) for each activity performed by each subject. The 'statistic' column in UCI_HAR_analysis.txt contains names of these statistics (formatted slightly differently from their original names). Each one included here is either a mean or a standard deviation ("std") of something. An x, y, or z, refers to an axis is space. For more information, see features_info.txt in the original dataset.

#### mean

Numeric

The mean over time of the corresponding statistic for the given subject and activity. Many of the statistics are means, so the mean column often contains means of means.
