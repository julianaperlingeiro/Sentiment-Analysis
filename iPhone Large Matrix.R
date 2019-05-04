
#### Making prediction with this model on test data---------------------------------------------

predSentimentIphone <- predict(modelRF_iphonesentiment, iphonelargematrix)


#### creating a new column with predicted data -------------------------------------------------

iphonelargematrix$predSentimentgalaxy <- predSentimentgalaxy

#### Checking the results ---------------------------------------------------------------------------

summary(iphonelargematrix$predSentimentiphone)