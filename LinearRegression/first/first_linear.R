#set working directory
path <- "~/R-Projects/LinearRegression/first"
setwd(path)

#load data and check data
colnames <- c("Frequency","Angle of attack","Chord length","Free-stream velocity","Suction side displacement thickness","Scaled sound pressure level")
mydata <- read.table("airfoil_self_noise.csv",header = F,sep = ",", col.names = colnames,na.strings = c(" ?"),stringsAsFactors =F)
str(mydata)
mydata$Frequency <- as.numeric(mydata$Frequency)
#Replace first value because of parsing error
mydata[is.na(mydata)] = 800
#check missing values
colSums(is.na(mydata))
#Check Multicollinearity, before convert to numeric all columns
cor(mydata)


regmodel <- lm(formula= Scaled.sound.pressure.level ~., data = mydata)
summary(regmodel)

#set graphic output
par(mfrow=c(2,2))
#create residual plots
plot (regmodel)
#Another regression but with log(y)
regmodel <- update(regmodel, log(Scaled.sound.pressure.level)~.)
summary(regmodel)
#Improvement in terms of R^2 adjusted, from 0,5141 to 0,5219 not very significant...

#sample
set.seed(1)
d <- sample ( x = nrow(mydata), size = nrow(mydata)*0.7)
train <- mydata[d,] #1052 rows 
test <- mydata[-d,] #451 rows
#train model
regmodel <- lm (log(Scaled.sound.pressure.level)~.,data = train)
summary(regmodel)
#Test Model
regpred <- predict(regmodel, test)
#convert back to original value
regpred <- exp(regpred)
library(Metrics)
rmse(actual = test$Scaled.sound.pressure.level,predicted = regpred)
