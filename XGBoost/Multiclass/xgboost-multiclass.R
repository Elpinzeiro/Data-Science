path <- "~/R-Project/XGBoost/Multiclass/"
setwd(path)
train <- read.table("train.csv", header = T, sep = ",", na.strings = c(" ?"), stringsAsFactors = F)
test <- read.table("test.csv", header = T, sep = ",", na.strings = c(" ?"), stringsAsFactors = F)
library(mlr)
library(data.table)
str(train)
str(test)

#check missing values
sapply(train, function(x) sum(is.na(x))/length(x))*100
sapply(test, function(x) sum(is.na(x))/length(x))*100

#impute them with median
sum(is.na(train$condition))
imp1 <- impute(as.data.frame(train),classes = list  (numeric=imputeMedian()))
train <- imp1$data
imp2 <- impute(as.data.frame(test),classes = list  (numeric=imputeMedian()))
test <- imp2$data
#Change value in order to have same levels in train and test
train$color_type[train$color_type == "Brown Tiger"] <- "Brown"
train$color_type[train$color_type == "Black Tiger"] <- "Black"
setDT(train)
setDT(test)
#Remove unrelevant categories
train$pet_id <- NULL
train$issue_date <- NULL
train$listing_date <- NULL
test$issue_date <- NULL
test$listing_date <- NULL


breed_labels <- factor(test$breed_category)
pet_category <- factor(test$pet_category)


new_tr <- model.matrix(~.+0, data = train[,-c("breed_category","pet_category"),with=F]) 
pet_ids <- test$pet_id
test$pet_id <- NULL
new_ts <- model.matrix(~.+0, data = test) 

#Create train matrices
dtrain1 <- xgb.DMatrix(data = new_tr,label = train$breed_category)
dtrain2 <- xgb.DMatrix(data = new_tr,label = train$pet_category)
params <- list(booster = "gbtree", objective = "multi:softmax", eta=0.3, gamma=0, max_depth=6, min_child_weight=1, subsample=1, colsample_bytree=1) 

#train model and make first prediction
xgbcv <- xgb.cv(params = params, data = dtrain1, nrounds = 100, nfold = 5, showsd = T, stratified = T, print_every_n = 10, early_stopping_round = 20,num_class = 3, maximize = F)
dtest_breed_3 <- xgb.DMatrix(data = new_ts)
xgb1 <- xgb.train (params = params, data = dtrain1, nrounds = 35, watchlist = list(train=dtrain1), print_every_n = 10,num_class =4, early_stopping_round = 10, maximize = F )
xgbpred_breed_category <- predict (xgb1,dtest_breed_3)

#train model and make second prediction
xgbcv <- xgb.cv(params = params, data = dtrain2, nrounds = 100, nfold = 5, showsd = T, stratified = T, print_every_n = 10, early_stopping_round = 20,num_class = 5, maximize = F)
dtest_pet_category <- xgb.DMatrix(data = new_ts)
xgb1 <- xgb.train (params = params, data = dtrain2, nrounds = 79, watchlist = list(train=dtrain2), print_every_n = 10,num_class =5, early_stopping_round = 10, maximize = F )
xgbpred_pet_category <- predict (xgb1,dtest_pet_category)

result <- data.frame(pet_ids,xgbpred_breed_category,xgbpred_pet_category)
#Print my result in result.csv file with format pet_id,breed_category,pet_category
write.table(result,file="result.csv",sep = ",",col.names= c("pet_id","breed_category","pet_category") ,row.names = F)

