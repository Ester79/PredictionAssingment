
# Libraries necessaries

library(caret)
library(ggplot2)
library(reshape2)
library(gridExtra)
library(dplyr)
library(corrplot)
library(rpart)
library(rpart.plot)
library(rattle)
library(randomForest)


# Load and read the data

trainset <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-training.csv"
testset <- "https://d396qusza40orc.cloudfront.net/predmachlearn/pml-testing.csv"
training <- read.csv(trainset, header = T, na.strings = c("", "NA"))
testing <- read.csv(testset, header = T, na.strings = c("", "NA"))


# Create data partition considering the dataset training
inTrain  <- createDataPartition(training$classe, p=0.7, list=FALSE)
set_train <- training[inTrain, ]
set_test <- training[-inTrain, ]
dim(set_train)
dim(set_test)

# Clean the dataset
# Remove the variables near to 0 variance and the variables with high quantity of NA
near0 <- nearZeroVar(set_train) # apply the function to remove the values near to 0 variance
set_train <- set_train[, -near0]
set_test <- set_test[, -near0]
dim(set_train)
dim(set_test)
# Remove the variables with almost 95% of NA values
navalues <- sapply(set_train, function(x) mean(is.na(x))) > 0.95
set_train <- set_train[ , navalues == FALSE]
set_test <- set_test[ , navalues == FALSE]
dim(set_train)
dim(set_test)

# Is not needed the first 5 identification variables, we can remove them
set_train <- set_train[ , -(1:5)]
set_test <- set_test[ , -(1:5)]
dim(set_train)
dim(set_test)

# Graphic correlation
graphcor <- cor(set_train[, -54])
corrplot(graphcor, order = "FPC", method = "color", type = "upper", tl.cex = 0.8, tl.col = rgb(0, 0, 0))



# Develop the models and methods

# Tree decision
set.seed(1234)
modtree <- train(classe ~ ., method = "rpart", data = set_train)
fancyRpartPlot(modtree$finalModel)
# prediction Tree decision
predtree <- predict(modtree, set_test)
confusionMatrix(predtree, set_test$classe)


# Random forest
set.seed(1234)
modrf <- randomForest(classe ~ ., data = set_train)
# prediction Random forest
predrf <- predict(modrf, set_test)
confusionMatrix(predrf, set_test$classe)


# GBM model (Generalized boosted model)
set.seed(1234)
gbmcontr <- trainControl(method = "repeatedcv", number = 5, repeats = 1)
modgbm <- train(classe ~., data = set_train, method = "gbm", trControl = gbmcontr, verbose = FALSE)
# prediction gbm model
predgbm <- predict(modgbm, set_test)
confusionMatrix(predgbm, set_test$classe)


