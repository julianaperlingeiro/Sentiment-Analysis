#### Project: Sentiment Analysis 
#### Author: Juliana Perlingeiro
#### Date: 26/04/19

## RF_iphone

#### iphone matrix -----------------------------------------------------------

iphone
names(iphone)

#### Set seed -----------------------------------------------------------------------

set.seed(123)

#### Data partition ----------------------------------------------------------------

inTrain <- createDataPartition(y = iphone$iphonesentiment,
                               p=0.7,
                               list = FALSE)

#### Data into training and testing ---------------------------------

training <- iphone[inTrain,]

testing <- iphone[-inTrain,]

#### Cross validation parameters ---------------------------------------------------

crossvalidation <- trainControl(method = "repeatedcv",
                                number = 10,
                                repeats = 1)



#### Training RF model ------------------------------------------------------------

modelRF_iphonesentiment <- train(iphonesentiment~.,
                                 training,
                                 method = "rf",
                                 tuneLength = 1,
                                 trControl = crossvalidation)

#### Cheking the model by having the metrics --------------------------------------

modelRF_iphonesentiment

### see variable importance -------------------------------------------------------

varImp <- varImp(modelRF_iphonesentiment)
plot(varImp)

#### Predicting iphonesentiment from the training data ---------------------------

prediphonesetiment_RF <- predict(modelRF_iphonesentiment, newdata = testing)

#### Creating new column with predictions -----------------------------------------

testing$prediphonesetiment_RF <- prediphonesetiment_RF

#### Confusion Matrix ---------------------------------------------------------

confusionMatrix(testing$prediphonesetiment_RF, testing$iphonesentiment)
