# Coursera Getting and Cleaning Data Project results
------------------
#### Very Short Synopsis:

 * _The only thing complicated about this is making sure that the data is where the code expects it to be.  I have tried to make this as painless as possible, but if it doesn't work, you can hopefully figure out what you're missing by looking at the relevant sections below this._
 * Code will output a file (`Project_tidy_data_output.txt`) in the _working directory_ and will also store the data frames from both step 1 and 2 of the project in memory (called `rdf` and `tidy_rdf_mean`).  

#### A Note about submission dates:

* This project was completed by me during the previous month's offering of this same course, but due to problems with holiday travel and available internet, I was unable to complete the grading process and the fourth week's quiz.  For this reason, the submission dates on the project match up with the end of the third week of December 2014.  Thank you for understanding.

-------------------
#### Quick Checklist Help
 * Did I submit a Github repo?
  * Hopefully so. If not, something is strange.
 * Was codebook submitted that modifies and updates the codebooks available to you with the data to indicate all the variables and summaries you calculated along with units and any other relevant information?
  * I hope so.  If this were something I were doing for real, I would presumably be able to know exactly what to say here.  As it is it is kind of an afterthought because I didn't realize this was expected until I went to add this section to this file.
  * For ease, you can go directly to the section _V_ of this file to see the table, or you can look at it online [here](https://github.com/crhume/CourseraTidyDataProject/blob/master/codebook.txt)
 * Were you able to follow the README in the directory that explained what the analysis files do?
  * (see _IV_ below you can also read the comments in the script itself)  


=======================
## Outline:

- *I.* Contents of repository
- *II.* Installation and running code
- *III.* Details of what to expect in output
- *IV.* Explanations of methodology and output 
- *V.* A markdown copy of the `codebook.txt` file

========================
## I. Contents of repository

* Primary script named *run_analysis.R* as requested
* This README file
* A duplicate copy of the output file this script produces (for reference or whatever)
* The codebook requested in the checklist underneath the project as a file `codebook.txt`
* Archived copies of the data I used: "UCI\_HAR\_Dataset-small.zip" and "UCI\_HAR\_Dataset-small.tar.gz" (note I replaced the spaces with underscores, because that's just the way I am) you can use either of these depending on your system if needed.  You should have almost identical copies of this, except for a few minor differences in file structure (see information below on the differences between originally downloaded zip file and these provided files)
  * To replicate contents of above "-small" archives directly from the original zip file (*NOTE* this is not necessary, and is only being included to explain what I'm doing and why):
    1. Download project zip file
    2. Unzip project zip file into a directory such as `UCI HAR Dataset`
    3. Note the structure of the directory includes `UCI HAR Dataset/UCI HAR Dataset/<files>`
    4. Navigate down to the directory which includes the sudiretories `test` and `train` as well as several datasets.  See [David's Project FAQ](https://class.coursera.org/getdata-016/forum/thread?thread_id=50) for a brief explanation of the reasoning for the next two steps
      a. Inside the directory `test` delete the `Inertial Signals` directory as the datasets are not used in this project (see 
      b. Inside the directory `train` delete the `Inertial Signals` directory as the datasets are not used in this project
    5. Now archive all remaining information _inside_ the bottom-most `UCI HAR Dataset/UCI HAR Dataset` directory which should include all relevant data as shown below in the tree
      * `<top>`
        * `activity_labels.txt`
        * `features.txt`
        * `features_info.txt`
        * `README.txt`
        * `[test]`
          * `subject_test.txt`
          * `X_test.txt`
          * `Y_test.txt`
        * `[train]`
          * `subject_train.txt`
          * `X_train.txt`
          * `Y_train.txt`


========================
## II. Installation and running code

I assume that your RStudio is already set up appropriately and is pointing to whatever working directory you wish to use.  I will refer to this directory as the "_working directory_" for all instructions.

Required packages in R

* reshape2 (already written into script, there should not be any need to do anything to include this)

### Installation Steps
  _NOTE:_ The first set of instructions only apply if you do not already have the UCI HAR Dataset folder in your _working directory_.  My script assumes that the structure to the data looks like `<wd>/UCI HAR Dataset/UCI HAR Dataset/*`

1. To ensure nothing is contaminated or overwritten, please save any work you are doing and then clear the environment variables before proceeding.
2. *(OPTIONAL)* Download and extract the provided data files
  a. Download the archive file and save it to some location if the location is somewhere other than in your _working directory_ note the absolute path somewhere for use later
  b. extract the archive into a directory.  It can be named whatever you like, I suggest something like "temp".  It should create a subdirectory in the directory you are located in.  Note the name you used, as we will use this later.
  c. The final structure should be something like this:
    * [top directory set in 1]
      * ...
      * [temp directory set in 2]
        * `activity_labels.txt`
        * `features.txt`
        * `features_info.txt`
        * `README.txt`
        * `[test]`
          * `subject_test.txt`
          * `X_test.txt`
          * `Y_test.txt`
        * `[train]`
          * `subject_train.txt`
          * `X_train.txt`
          * `Y_train.txt`
3. Save `run_analysis.R` to your _working directory_
4. Accommodate the location of your data files depending on your setup
  * If you followed the optional step 1, use the following two steps before running the source statement
    1. _If_ you placed the archive file in a different directory than the _working directory_ as in step 1-a, store the absolute path reference to a variable named "topdir" as shown in the examples below
      - `> topdir <- "C:\\myDataArea\\UCI_HAR Dataset"`
      - `> topdir <- "/data/myCourseraData/UCI_HAR_Dataset"`
    2. _If_ you extracted the archive file into a temporary directory as in step 1-b, store the directory name to a variable named "tmpdir" as shown in the example below
      - `> tmpdir <- "temp"` 
  * If you are using your existing data extracted for this project
    1. If your data is stored directly in the _working directory_ as shown below, no further action is needed
      * [_working directory_]
        * `activity_labels.txt`
        * `features.txt`
        * `features_info.txt`
        * `README.txt`
        * `[test]`
          * `subject_test.txt`
          * `X_test.txt`
          * `Y_test.txt`
          * `...`
        * `[train]`
          * `subject_train.txt`
          * `X_train.txt`
          * `Y_train.txt`
          * `...`
    2. If your data is located in another directory (not under the _working directory_), store the absolute path reference to the directory referenced by [_working directory_] above as a variable "topdir" as shown in the examples below
      * `> topdir <- "C:\\myDataArea\\UCI HAR Dataset\\UCI HAR Dataset"`
      * `> topdir <- "/data/myCourseraData/UCI\ HAR\ Dataset/UCI\ HAR\ Dataset"`
    3. If your data is located in a subfolder of your _working directory_ store the name of the subdirectory which coincides with the [_working directory_] folder in the above illustration as a variable "tmpdir" as shown in the examples below
      * `> tmpdir <- "temp"`
      * `> tmpdir <- "projectData\\UCI HAR Dataset"`

### Running Code

The script (if installed as described above, and if the data is present where expected) can be run by simply executing the line:
  - `source('run_analysis.R')`
  
=====================
## III. Details of what to expect in output
  
The output will consist of a single file named "Project\_tidy\_data\_output.txt" which will be placed in your working directory.

Additionally, it will store two dataframes in memory.  The first dataframe is the result of step 1 (prior to tidying) called `rdf` for "reduced data frame".  The second is the result of melting and casting the dataset and should be identical to the file output, it is called `tidy_rdf_mean`.

To load the output table you can use any variable name you like: 
`testdf <- read.table("Project_tidy_data_output.txt",header=TRUE)`

The file is: 
  - When examined in Windows (right click and go to properties) `291,576 bytes` in size and `294,912 bytes` on disk
    - When shown in explorer windows it shows `284.7 KB` = `284.7 kibibytes (KiB)` = `291.5 kilobytes (KB)` (if you don't know the distinction, don't worry about it, most people choose to ignore this difference)
  - When examined in Linux it shows `291,576 bytes` as the filesize
  - When examined in R it should show to be a data frame of `180 obs. of 88 variables`
 
The data is structured as follows:

`subject` `activityName` `...` 

where `...` denotes the remaining 86 columns which included (not case sensitive) either the word "mean" or the word "std" in the description, again this is based on the discussion in [David's Project FAQ](https://class.coursera.org/getdata-016/forum/thread?thread_id=50) where he explains that this is what was intended by the direction to pull only these values out.  I have chosen to interpret this to mean all of the columns with means rather than only those which listed out something like "mean()" or "std()".

Subject numbers are as included in the files, activityName is as found in the `activity_labels.txt` file, and the remaining column headers are those found in the `features.txt` file (as appropriate).

The data frame is sorted by subject then activity, since I didn't see this specified.  Fortunately this is easy enough to change if needed.

===================
## IV. Explanations of methodology and output

Much of this information is also included in the script itself, but in case you're reading this first (good thinking!) I will include it here and then you can skip most of the comments in the script (if you're being that thorough).

I will omit sections of the code where I tried to arrange this so it could be imported and run in most environments, as they are superfluous to the project goal.

Initially after extracting the data, I tried to load each of the tables into memory and begin to sort through them. The only ones I had a lot of difficulty parsing and figuring out how they fit into the goals stated in the project page were those in the `Inertial Signals` directories.  After agonizing over this for a rather long time (trying to figure out how to connect these raw data files into something which could be mashed in with all the other tables) I ran across [David's Project FAQ](https://class.coursera.org/getdata-016/forum/thread?thread_id=50) and realized that apparently this extra material wasn't intended to be part of this project.  Since I'd already spent far more than the time I allotted for this class on minor details and troubleshooting configurations, I elected to omit these extra datasets as recommended in the FAQ.  

Once I did this, the rest was fairly straightforward.  

I tested the lines of code out and tweaked them as necessary until I had the stable script I have uploaded.

The following outline shows some pseudo-logic that was filled in to arrange the project code:

1. Create the merged dataset `rdf` which loads into memory
  1. First I loaded top level tables into memory
    - Change column labels (turned out to not be necessary except for the activity lables)
      - For the `activity_labels.txt` file, I renamed the columns to "activity" and "activityName" I did this after some experimentation so that the later call to merge worked easily and did exactly what I wanted, leaving me the single column "activityName" in the resulting data frame
      - The remaining labels from these two files were largely unnecessary
      - I also produced a logical vector which identified the "mean" and "std" columns using the feature labels as described above.
    - Copy the actual name information into some temporary variables for use later
  2. Next load all actual data files (those in the test and train directories) into their respective data frames
    - Rename the column labels for all tables to reflect the contents
      - For the `*_subject.txt` files I labelled the column name "subject"
      - For the `Y_*.txt` files I labelled the column name "activity" 
      - For the `X_*.txt` files I labelled the columns using the names extracted from the `features.txt` file
  3. Because the data frames for the test and train were different sizes, I produced two separate data frames for these two sets using `cbind()` and then pulled those two together using `rbind()`
  4. To add the labels for the activities I used `merge()` to bring the result of the `rbind()` together with the activity labels from step 1
  5. Finally, I removed the column with the activity number, since it was no longer necessary.  At this point I had the first dataset required for the project, which I labelled `rdf` for "reduced data frame"  This was not yet tidy.
2. Create the tidy data set `tidy_rdf_mean` which loads into memory (as well as saves into a file `Project_tidy_data_output.txt`)
  1. Prior to manipulating this large-ish dataset, I removed all temporary variables from memory.
  2. I then used the `reshape2` package and `melt()` to melt the dataset on ids "subject" and "activityName"
  3. Finally, I recast the data using "subject" and "activityName" against the remaining variable names using `mean` as directed.
  4. Before exiting I removed the intermediate "melted" dataset and output the final result to a file

======================
## V. A markdown copy of the `codebook.txt` file

|VarNo|Variables 	| Units 	| Explanations		|
|:--:|:--------- | ---------:|:----------------- |
| 1 | subject | integer	| numbers 1-30 |
| 2 | activityName | string | LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS |
| 3 |tBodyAcc.mean.X | std gravity units 'g' | measured acceleration in X direction |
| 4 |tBodyAcc.mean.Y | std gravity units 'g' | measured acceleration in Y direction |
| 5 |tBodyAcc.mean.Z | std gravity units 'g' | measured acceleration in Z direction |
| 6 |tBodyAcc.std.X  | std gravity units 'g' | measured acceleration in X direction |                  
| 7 |tBodyAcc.std.Y  | std gravity units 'g' | measured acceleration in Y direction |
| 8 |tBodyAcc.std.Z  | std gravity units 'g' | measured acceleration in Z direction |
| 9 |tGravityAcc.mean.X | std gravity units 'g' | measured acceleration in X direction |
| 10 |tGravityAcc.mean.Y | std gravity units 'g' | measured acceleration in Y direction |
| 11 |tGravityAcc.mean.Z | std gravity units 'g' | measured acceleration in Z direction |
| 12 |tGravityAcc.std.X | std gravity units 'g' | measured acceleration in X direction |
| 13 |tGravityAcc.std.Y | std gravity units 'g' | measured acceleration in Y direction |
| 14 |tGravityAcc.std.Z | std gravity units 'g' | measured acceleration in Z direction |
| 15 |tBodyAccJerk.mean.X | std gravity jerk units 'g/s' | measured jerk in X direction |              
| 16 |tBodyAccJerk.mean.Y | std gravity jerk units 'g/s' | measured jerk in Y direction |
| 17 |tBodyAccJerk.mean.Z | std gravity jerk units 'g/s' | measured jerk in Z direction |
| 18 |tBodyAccJerk.std.X  | std gravity jerk units 'g/s' | measured jerk in X direction |              
| 19 |tBodyAccJerk.std.Y | std gravity jerk units 'g/s' | measured jerk in Y direction |
| 20 |tBodyAccJerk.std.Z | std gravity jerk units 'g/s' | measured jerk in Z direction |
| 21 |tBodyGyro.mean.X     | radians/second | measured angular velocity in X direction |             
| 22 |tBodyGyro.mean.Y | radians/second | measured angular velocity in Y direction |
| 23 |tBodyGyro.mean.Z | radians/second | measured angular velocity in Z direction |
| 24 |tBodyGyro.std.X  | radians/second | measured angular velocity in X direction |
| 25 |tBodyGyro.std.Y | radians/second | measured angular velocity in Y direction |
| 26 |tBodyGyro.std.Z | radians/second | measured angular velocity in Z direction |
| 27 |tBodyGyroJerk.mean.X | radians/second^2 | measured angular jerk in X direction |
| 28 |tBodyGyroJerk.mean.Y | radians/second^2 | measured angular jerk in Y direction |
| 29 |tBodyGyroJerk.mean.Z | radians/second^2 | measured angular jerk in Z direction |
| 30 |tBodyGyroJerk.std.X  | radians/second^2 | measured angular jerk in X direction |             
| 31 |tBodyGyroJerk.std.Y | radians/second^2 | measured angular jerk in Y direction |
| 32 |tBodyGyroJerk.std.Z | radians/second^2 | measured angular jerk in Z direction |
| 33 |tBodyAccMag.mean | std gravity units 'g' | measured acceleration |                 
| 34 |tBodyAccMag.std | std gravity units 'g' | measured acceleration |
| 35 |tGravityAccMag.mean | std gravity units 'g' | measured acceleration |
| 36 |tGravityAccMag.std | std gravity units 'g' | measured acceleration |               
| 37 |tBodyAccJerkMag.mean | std gravity jerk units 'g/s' | measured jerk |
| 38 |tBodyAccJerkMag.std | std gravity jerk units 'g/s' | measured jerk |
| 39 |tBodyGyroMag.mean | radians/second | measured angular velocity |
| 40 |tBodyGyroMag.std | radians/second | measured angular velocity |
| 41 |tBodyGyroJerkMag.mean | radians/second^2 | measured angular jerk |
| 42 |tBodyGyroJerkMag.std | radians/second^2 | measured angular jerk |
| 43 |fBodyAcc.mean.X | std gravity units 'g' | measured acceleration in X direction |
| 44 |fBodyAcc.mean.Y | std gravity units 'g' | measured acceleration in Y direction |
| 45 |fBodyAcc.mean.Z | std gravity units 'g' | measured acceleration in Z direction |          
| 46 |fBodyAcc.std.X | std gravity units 'g' | measured acceleration in X direction |
| 47 |fBodyAcc.std.Y | std gravity units 'g' | measured acceleration in Y direction |
| 48 |fBodyAcc.std.Z | std gravity units 'g' | measured acceleration in Z direction | 
| 49 |fBodyAcc.meanFreq.X | Hz | measured avg of frequency components |
| 50 |fBodyAcc.meanFreq.Y | Hz | measured avg of frequency components |
| 51 |fBodyAcc.meanFreq.Z               | Hz | measured avg of frequency components |
| 52 |fBodyAccJerk.mean.X | std gravity jerk units 'g/s' | measured jerk in X direction |
| 53 |fBodyAccJerk.mean.Y | std gravity jerk units 'g/s' | measured jerk in Y direction |
| 54 |fBodyAccJerk.mean.Z         | std gravity jerk units 'g/s' | measured jerk in Z direction |      
| 55 |fBodyAccJerk.std.X | std gravity jerk units 'g/s' | measured jerk in X direction |
| 56 |fBodyAccJerk.std.Y | std gravity jerk units 'g/s' | measured jerk in Y direction |
| 57 |fBodyAccJerk.std.Z  | std gravity jerk units 'g/s' | measured jerk in Z direction |              
| 58 |fBodyAccJerk.meanFreq.X | Hz | measured avg of frequency components |
| 59 |fBodyAccJerk.meanFreq.Y | Hz | measured avg of frequency components |
| 60 |fBodyAccJerk.meanFreq.Z | Hz | measured avg of frequency components |
| 61 |fBodyGyro.mean.X | radians/second | measured angular velocity in X direction |
| 62 |fBodyGyro.mean.Y | radians/second | measured angular velocity in Y direction |
| 63 |fBodyGyro.mean.Z  | radians/second | measured angular velocity in Z direction |
| 64 |fBodyGyro.std.X | radians/second | measured angular velocity in X direction |
| 65 |fBodyGyro.std.Y | radians/second | measured angular velocity in Y direction |
| 66 |fBodyGyro.std.Z | radians/second | measured angular velocity in Z direction |
| 67 |fBodyGyro.meanFreq.X | Hz | measured avg of frequency components |
| 68 |fBodyGyro.meanFreq.Y | Hz | measured avg of frequency components |
| 69 |fBodyGyro.meanFreq.Z | Hz | measured avg of frequency components |
| 70 |fBodyAccMag.mean | std gravity units 'g' | measured acceleration |
| 71 |fBodyAccMag.std | std gravity units 'g' | measured acceleration |
| 72 |fBodyAccMag.meanFreq | Hz | measured avg of frequency components |
| 73 |fBodyBodyAccJerkMag.mean | std gravity jerk units 'g/s' | measured jerk |
| 74 |fBodyBodyAccJerkMag.std | std gravity jerk units 'g/s' | measured jerk |
| 75 |fBodyBodyAccJerkMag.meanFreq      | Hz | measured avg of frequency components |
| 76 |fBodyBodyGyroMag.mean  | radians/second | measured angular velocity |
| 77 |fBodyBodyGyroMag.std | radians/second | measured angular velocity |
| 78 |fBodyBodyGyroMag.meanFreq | Hz | measured avg of frequency components |
| 79 |fBodyBodyGyroJerkMag.mean | radians/second^2 | measured angular jerk |
| 80 |fBodyBodyGyroJerkMag.std | radians/second^2 | measured angular jerk |
| 81 |fBodyBodyGyroJerkMag.meanFreq | Hz | measured avg of frequency components |
| 82 |angle.tBodyAccMean.gravity | radians | angular component of vector for gravity |
| 83 |angle.tBodyAccJerkMean.gravityMean | radians | angular component of vector for gravity |
| 84 |angle.tBodyGyroMean.gravityMean | radians | angular component of vector for gravity |
| 85 |angle.tBodyGyroJerkMean.gravityMean | radians | angular component of vector for gravity |
| 86 |angle.X.gravityMean | radians | angular component of vector for gravity |
| 87 |angle.Y.gravityMean | radians | angular component of vector for gravity |
| 88 |angle.Z.gravityMean | radians | angular component of vector for gravity |


Thank you for reading, I hope that I have helped to make the grading process easier for you.


