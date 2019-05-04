

#### Making prediction with this model on test data---------------------------------------------

predSentimentgalaxy <- predict(modelRF_galaxysentiment, galaxylargematrix)


#### creating a new column with predicted data -------------------------------------------------

galaxylargematrix$predSentimentgalaxy <- predSentimentgalaxy

#### Checking the results ---------------------------------------------------------------------------

summary(galaxylargematrix$predSentimentgalaxy)
