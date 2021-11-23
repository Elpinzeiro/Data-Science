path <- "~/R-Projects/XGBoost/Binary/"
setwd(path)

library(data.table)
library(mlr)

#set variable names
setcol <- c("age","workclass","fnlwgt","education","education-num","marital-status","occupation","relationship","race","sex","capital-gain","capital-loss","hours-per-week","native-country","target")

#load data
train <- read.table("adult.data", header = F, sep = ",", col.names = setcol, na.strings = c(" ?"), stringsAsFactors = F)
test <- read.table("adult.test",header = F,sep = ",",col.names = setcol,skip = 1, na.strings = c(" ?"),stringsAsFactors = F)

#convert data frame to data table
setDT(train) 
setDT(test)

#check missing values 
table(is.na(train))
sapply(train, function(x) sum(is.na(x))/length(x))*100

table(is.na(test))
sapply(test, function(x) sum(is.na(x))/length(x))*100

#quick data cleaning
#remove extra character from target variable
library(stringr)
test [,target := substr(target,start = 1,stop = nchar(target)-1)]

#remove leading whitespaces in train and test
char_col <- colnames(train)[ sapply (test,is.character)]
for(i in char_col) set(train,j=i,value = str_trim(train[[i]],side = "left"))
for(i in char_col) set(test,j=i,value = str_trim(test[[i]],side = "left"))

#set all missing value as "Missing" 
train[is.na(train)] <- "Missing" 
test[is.na(test)] <- "Missing"

train$native.country[train$native.country == "Holand-Netherlands"] <- "United-States"

labels <- factor(train$target)
ts_label <- factor(test$target)

new_tr <- model.matrix(~.+0,data = train[,-c("target"),with=F]) 
new_ts <- model.matrix(~.+0,data = test[,-c("target"),with=F])



labels <- as.numeric(labels)-1
ts_label <- as.numeric(ts_label)-1
library(xgboost)

dtrain <- xgb.DMatrix(data = new_tr,label = labels)
dtest <- xgb.DMatrix(data = new_ts,label=ts_label)
params <- list(booster = "gbtree", objective = "binary:logistic", eta=0.3, gamma=0, max_depth=6, min_child_weight=1, subsample=1, colsample_bytree=1) 
xgbcv <- xgb.cv(params = params, data = dtrain, nrounds = 100, nfold = 5, showsd = T, stratified = T, print_every_n = 10, early_stopping_round = 20, maximize = F)

xgb1 <- xgb.train (params = params, data = dtrain, nrounds = 66, watchlist = list(val=dtest,train=dtrain), print_every_n = 10, early_stopping_round = 10, maximize = F , eval_metric = "error")

xgbpred <- predict (xgb1,dtest)
xgbpred <- ifelse (xgbpred > 0.5,1,0)

library(caret)
confusionMatrix (factor(xgbpred), factor(ts_label))

mat <- xgb.importance (feature_names = colnames(new_tr),model = xgb1)
xgb.plot.importance (importance_matrix = mat[1:20])
library(mlr)
fact_col <- colnames(train)[sapply(train,is.character)]

for(i in fact_col) set(train,j=i,value = factor(train[[i]]))
for (i in fact_col) set(test,j=i,value = factor(test[[i]]))

traintask <- makeClassifTask (data = as.data.frame(train),target = "target")
testtask <- makeClassifTask (data = as.data.frame(test),target = "target")

traintask <- createDummyFeatures (obj = traintask)
testtask <- createDummyFeatures (obj = testtask)

lrn <- makeLearner("classif.xgboost",predict.type = "response")
lrn$par.vals <- list( objective="binary:logistic", eval_metric="error", nrounds=100L, eta=0.1)

params <- makeParamSet( makeDiscreteParam("booster",values = c("gbtree","gblinear")), makeIntegerParam("max_depth",lower = 3L,upper = 10L), makeNumericParam("min_child_weight",lower = 1L,upper = 10L), makeNumericParam("subsample",lower = 0.5,upper = 1), makeNumericParam("colsample_bytree",lower = 0.5,upper = 1))
rdesc <- makeResampleDesc("CV",stratify = T,iters=5L)
ctrl <- makeTuneControlRandom(maxit = 10L)
library(parallel)
library(parallelMap) 
parallelStartSocket(cpus = detectCores())
mytune <- tuneParams(learner = lrn, task = traintask, resampling = rdesc, measures = acc, par.set = params, control = ctrl, show.info = T)

#set hyperparameters
lrn_tune <- setHyperPars(lrn,par.vals = mytune$x)
library(mlr)

#train model
xgmodel <- mlr::train(learner = lrn_tune,task = traintask)

#predict model
xgpred <- predict(xgmodel,testtask)

#Show Results
confusionMatrix(xgpred$data$response,xgpred$data$truth)
