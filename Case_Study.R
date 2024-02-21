############################
## Introduction and background ##
############################

# expanded on this starter script for the project

###########################
## Upload your CSV files to R ##
###########################

# Remember to upload your CSV files to your project from the relevant data source:
# https://www.kaggle.com/arashnic/fitbit

################################################
## Installing and loading common packages and libraries ##
################################################

#Install and load the tidyverse
install.packages('tidyverse')
library(tidyverse)

#Install and load here for referencing files
install.packages('here')
library(here)

#install and load skimr for summarizing data
install.packages('skimr')
library(skimr)

#install and load janitor for cleaning data
install.packages('janitor')
library(janitor)

#install and load dpylr
install.packages('dyplr')
library(dplyr)

#####################
## Load your CSV files ##
#####################

# Create a dataframe named 'daily_activity' and read in one 
# of the CSV files from the dataset. Remember, you can name your dataframe 
# something different, and you can also save your CSV file under a different name as well.

daily_activity <- read.csv("./Documents/fitbit_data/dailyActivity_merged.csv")

# Create another dataframe for the sleep data. 
sleep_day <- read.csv("./Documents/fitbit_data/sleepDay_merged.csv")

# dataframe for heartrate
heartrate <- read.csv("./Documents/fitbit_data/heartrate_seconds_merged.csv")

# dataframe for weight
weight_info <- read.csv("./Documents/fitbit_data/weightLoginfo_merged.csv")

#########################
## Explore a few key tables ##
#########################

# Take a look at the daily_activity data.
head(daily_activity)

# Identify all the columns in the daily_activity data.
colnames(daily_activity)

# Summary of daily_activity
str(daily_activity)
glimpse(daily_activity)
skim_without_charts(daily_activity)

# Take a look at the sleep_day data.
head(sleep_day)
skim_without_charts(sleep_day)

# Identify all the columns in the sleep_day data.
colnames(sleep_day)

# Take a look at the heartrate data.
head(heartrate)

# Identify all the columns in the heartrate data.
colnames(heartrate)

# Take a look at the weight data.
head(weight_info)


# Identify all the columns in the weight data.
colnames(weight_info)


# Note that both datasets have the 'Id' field - 
# this can be used to merge the datasets.

#####################################
## Understanding some summary statistics ##
#####################################

# How many unique participants are there in each dataframe? 

n_distinct(daily_activity$Id) # 33
n_distinct(sleep_day$Id) # 24
n_distinct(heartrate$Id) # 14 
n_distinct(weight_info$Id) # 8


# This number contradicts the 30 mentioned in the summary.
# Original number is not correct and participants didn't complete the study.

# How many observations are there in each dataframe?

nrow(daily_activity) # 940
nrow(sleep_day) # 413
nrow(heartrate) # 2483658
nrow(weight_info) # 67


# What are some quick summary statistics we'd want to know about each data frame?

# For the daily activity dataframe:
daily_activity %>%  
  select(TotalSteps,
         TotalDistance,
         SedentaryMinutes) %>%
  summary()
# TotalDistance doesn't provide units


# For the sleep dataframe:

sleep_day %>%  
  select(TotalSleepRecords,
         TotalMinutesAsleep,
         TotalTimeInBed) %>%
  summary()



# For the heartrate dataframe:
heartrate %>%
  select(Value) %>%
  summary()

# For the weight dataframe:
weight_info %>%
  drop_na %>%
  select(WeightKg, Fat, BMI) %>%
  summary()

# What does this tell us about how this sample of people's activities? 

##########################
## Plotting a few explorations ##
##########################

# What's the relationship between steps taken in a day and sedentary minutes? 
# How could this help inform the customer segments that we can market to? 
# E.g. position this more as a way to get started in walking more? 
# Or to measure steps that you're already taking?

ggplot(data=daily_activity, aes(x=TotalSteps, y=SedentaryMinutes)) + 
  geom_point() + geom_smooth()


# What's the relationship between minutes asleep and time in bed? 
# You might expect it to be almost completely linear - are there any unexpected trends?


ggplot(data=sleep_day, aes(x=TotalMinutesAsleep, y=TotalTimeInBed)) + 
  geom_point() + geom_smooth()

# filter out steps
daily_activity_steps <- daily_activity %>% 
  select(Id, ActivityDate, TotalSteps)

glimpse(daily_activity_steps)

# relationship between calories and steps

calories <- daily_activity %>%
  select(Id, ActivityDate, Calories)

glimpse(calories)

combined_calories_steps <- calories %>% inner_join(daily_activity_steps, by = c("Id", "ActivityDate"))
glimpse(combined_calories_steps)

ggplot(data=combined_calories_steps, aes(x=TotalSteps, y=Calories)) + 
  geom_point() + geom_smooth()
                                 
# What could these trends tell you about how to help market this product? Or areas where you might want to explore further?

##################################
## Merging these two datasets together ##
##################################

# sleep_day_simple <- separate(sleep_day, SleepDay, into = c("ActivityDate", "Time"), sep=" ")
# glimpse(sleep_day_simple)
# combined_sleep_steps <- merge(sleep_day_simple, daily_activity_steps, by="Id")

# ggplot(data=combined_sleep_steps, aes(x=TotalSteps, y=TotalMinutesAsleep)) + 
#   geom_point() + geom_smooth()


# Now you can explore some different relationships between activity and sleep as well. 
# For example, do you think participants who sleep more also take more steps or fewer 
# steps per day? Is there a relationship at all? How could these answers help inform 
# the marketing strategy of how you position this new product?

