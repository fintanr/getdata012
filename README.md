# Coursera Getting Data Course Project

## Introduction

This repository contains the `run_analysis.R` script required for the Coursera Getting Data
Course Project    

## Execution

`run_analysis.R` executes the following steps

* Check to see if the required data is in place
* Load in the data files we use to create our dataset and combine these into a single data frame
* Add descriptive activity names to our dataframe, we take these names from the file `activity_labels.txt` contained with our original dataset
* Clean up the names of our existing columns for readability
* Create our tidy dataset by melting and recasting our combined dataframe
* Output out tidy-data to the file tidy-data.txt

