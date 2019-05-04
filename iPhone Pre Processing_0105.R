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

iphone <- read.csv(file = "iphone_smallmatrix_labeled_8d.csv")

str(iphone)
head(iphone)
summary(iphone)
ls(iphone)
names(iphone)
dim(iphone)
glimpse(iphone)

#### Plotting the distribuition of dependent variable - iPhone --------------------------------------------

plot_ly(iphone, x= ~iphone$iphonesentiment, type ='histogram')

#### Checking the missed data ----------------------------------------------------------------

iphone[!complete.cases(iphone),] 

#### Checking correlation matrix iPhone --------------------------------------------------------

corriphone <-cor(iphone)

corriphone

corrplot(corriphone, type="upper", order="hclust",
         col=brewer.pal(n=8, name="RdYlBu"))


#### Feature selection --------------------------------------------------------------

iphone = iphone %>% select(iphonesentiment,
                           iphone,
                           iphonecampos,
                           iphonecamneg,
                           iphonedispos,
                           iphonedisneg,
                           iphoneperpos,
                           iphoneperneg)
                      


iphone <- iphone[!(iphone$iphone > "0" &
                                     iphone$iphonecampos == "0" & iphone$iphonecamneg == "0" & 
                                     iphone$iphonedispos == "0" & 
                                     iphone$iphonedisneg == "0" & 
                                     iphone$iphoneperpos == "0" & iphone$iphoneperneg == "0"),]
summary(iphone)

#### Cheking "iphone" mentioned at least once in the website

iphone <- iphone %>% filter(iphone > 0)

#### Modifing iphonesentiment from 6 to 2 levels

iphone$iphonesentiment <- recode(iphone$iphonesentiment, 
                                 '0' = 1, '1' = 1, '2' = 1,
                                 '3' = 5, '4' = 5, '5' = 5)

#### Balacing iphone dataset


iphone <- ovun.sample(iphonesentiment~., data=iphone,
                      N=nrow(iphone), p=0.5, 
                      seed=1, method="both")$data


plot_ly(iphone, x= ~iphone$iphonesentiment, type ='histogram')

#### iphonesentiment as a FACTOR

iphone$iphonesentiment <- as.factor(iphone$iphonesentiment)

