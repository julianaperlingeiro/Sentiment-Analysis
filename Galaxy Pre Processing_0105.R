#### Project: Sentiment Analysis 
#### Author: Juliana Perlingeiro
#### Date: 23/04/19

#### Setting up Paralell Package ---------------------------------------------------

## install.packages("doParallel")

## install.packages("foreach")

## install.packages("iterators")

## install.packages("kknn")

## install.packages("ROSE")


#### Library -----------------------------------------------------------------------

library(doParallel)
library(foreach)
library(iterators)
library(readr)
library(caret)
library(lattice)
library(ggplot2)
library(dplyr)
library(plotly)
library(corrplot)
library(RColorBrewer)
library(e1071)
library(kknn)
library(ROSE)

#### Finding how many cores are on in the CPU -----------------------------------------

detectCores(all.tests = FALSE, logical = TRUE)

#### Create Cluster with desired number of cores --------------------------------------

cl1 <- makeCluster(1)

#### Register Cluster ------------------------------------------------------------------

registerDoParallel(cl1)

#### Confirm how many cores are now "assigned" to R and RStudio ------------------------

getDoParWorkers()

#### Stop Cluster. After performing your tasks, stop your cluster ----------------------

stopCluster(cl1)

#### The file -------------------------------------------------------------------------

galaxy <- read.csv( file = "galaxy_smallmatrix_labeled_9d.csv")

str(galaxy)
head(galaxy)
summary(galaxy)
ls(galaxy)
names(galaxy)
dim(galaxy)
glimpse(galaxy)

#### Plotting the distribuition of dependent variable - Galaxy --------------------------------------------- 

plot_ly(galaxy, x= ~galaxy$galaxysentiment, type='histogram')

#### Checking the missed data ----------------------------------------------------------------

galaxy[!complete.cases(galaxy)]

#### Checking correlation matrix ---------------------------------------------------------

corrgalaxy <-cor(galaxy)

corrgalaxy

corrplot(corrgalaxy, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))

#### Feature selection --------------------------------------------------------------

galaxy = galaxy %>% select(galaxysentiment,
                           samsunggalaxy,
                           samsungcampos,
                           samsungcamneg,
                           samsungdispos,
                           samsungdisneg,
                           samsungperpos,
                           samsungperneg)


galaxy <- galaxy[!(galaxy$samsunggalaxy > "0" &
                     galaxy$samsungcampos == "0" & galaxy$samsungcamneg == "0" & 
                     galaxy$samsungdispos == "0" & 
                     galaxy$samsungdisneg == "0" & 
                     galaxy$samsungperpos == "0" & galaxy$samsungperneg == "0"),]

                        
summary(galaxy)


#### Cheking "samsunggalaxy" mentioned at least once in the website ----------------------------------

galaxy <- galaxy %>% filter(samsunggalaxy > 0) 

#### Modifing galaxysentiment from 6 to 2 levels -------------------------------------------------

galaxy$galaxysentiment <- recode(galaxy$galaxysentiment, 
                                 '0' = 1, '1' = 1, '2' = 1,
                                 '3' = 5, '4' = 5, '5' = 5)

### Balancing galaxy dataset ----------------------------------------------------------------

galaxy <- ovun.sample(galaxysentiment~., data=galaxy,
                      N=nrow(galaxy), p=0.5, 
                      seed=1, method="both")$data

plot_ly(galaxy, x= ~galaxy$galaxysentiment, type='histogram')

#### galaxysentiment as a FACTOR -------------------------------------------------------------

galaxy$galaxysentiment <- as.factor(galaxy$galaxysentiment)

