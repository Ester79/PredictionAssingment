
# Code 
getwd()

# Libraries necessaries
library(caret)
library(rpart)
library(rpart.plot)
library(RColorBrewer)
library(rattle)
library(randomForest)
library(corrplot)
library(gbm)
library(readxl)

# Load the data
fileTrain <- read_xlsx("pmltraining.xlsx") # load the training data set
dim(fileTrain)
sum(is.na(fileTrain)) # Verify how many NA there are in the data set
fileTest <- read_xlsx("pmltesting.xlsx") # load the testing data set
dim(fileTest)
sum(is.na(fileTest)) # Verify how many NA there are in the data set


# Create the partition considering the dataset 'training'
inTrain <- createDataPartition(fileTrain$classe, p = 0.7, list = FALSE)
training <- fileTrain[inTrain, ]
testing <- fileTrain[-inTrain, ]
dim(training)
dim(testing)
sum(is.na(training))
sum(is.na(testing))




