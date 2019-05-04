#### Project: Sentiment Analysis 
#### Author: Juliana Perlingeiro
#### Date: 26/04/19

## RF_galaxy

#### galaxy matrix -----------------------------------------------------------

galaxy
names(galaxy)

#### Set seed -----------------------------------------------------------------------

set.seed(123)

#### Data partition ----------------------------------------------------------------

inTrain <- createDataPartition(y = galaxy$galaxysentiment,
                               p=0.7,
                               list = FALSE)

#### Separating the data into training and testing ---------------------------------

training <- galaxy[inTrain,]

testing <- galaxy[-inTrain,]

#### Cross validation parameters ---------------------------------------------------

crossvalidation <- trainControl(method = "repeatedcv",
                                number = 10,
                                repeats = 1)
                               


#### Training RF model ------------------------------------------------------------

modelRF_galaxysentiment <- train(galaxysentiment~.,
                                 training,
                                 method = "rf",
                                 tuneLength = 1,
                                 trControl = crossvalidation)

#### Cheking the model by having the metrics --------------------------------------

modelRF_galaxysentiment

#### Predicting iphonesentiment from the training data ---------------------------

predgalaxysetiment_RF <- predict(modelRF_galaxysentiment, newdata = testing)

#### Creating new column with predictions -----------------------------------------

testing$predgalaxysetiment_RF <- predgalaxysetiment_RF

#### Confusion Matrix ---------------------------------------------------------

confusionMatrix(testing$predgalaxysetiment_RF, testing$galaxysentiment)


