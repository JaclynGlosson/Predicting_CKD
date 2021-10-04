#------------------------------------------
library(MASS)

data =read.csv("imputeddata.csv", na.strings = " ")
#------------------------------------------

# Create samples with and without CKD variable
out_sample=which(is.na(data$CKD))
summary(out_sample)
data_out=data[out_sample,]   ## the ones without a disease status
summary(data_out)
data_in=data[-out_sample,]   ## the ones with a disease status
summary(data_in)

#Check for missing data and examine
any(is.na(data_in))
summary(data)
summary(data_in)
summary(data)

#cross validation is used to ensure we are not overfitting the model
#Split the data without CKD variable 75 to 25
data_split<-floor(0.75*nrow(data_in))
set.seed(1958)
train_data<-sample(seq_len(nrow(data_in)),size=data_split)
train<-data_in[train_data, ]
test<-data_in[-train_data, ]

#run our logistic regression, same variables, using our train data
model=glm(CKD~Age + Female + Racegrp  + BMI + Waist + 
            HDL + PVD + Activity + Hypertension + Fam.Hypertension + 
            Diabetes + CVD + Fam.CVD + CHF + Anemia,family="binomial",data=train)
model

## Step 6 - Predict probabilities and Odds Ratios of New Data
## predictions of new data
phatnew=predict(model, testthis = test, type = "response")
phatnew

#bind these predictions to our testing data
Testing_CKD= cbind(test,phatnew)
Testing_CKD
write.table(Testing_CKD,file="testingCKD3.csv", sep=",")

#Running backwards stepAIC
empty<-glm(CKD~1,train,family=binomial(link = "logit"))
model=glm(CKD~.,family="binomial",data=train)
summary(model)
mod3 <- stepAIC(model,direction='backward',scope=list(lower=empty,upper=model)) #AIC=1661.37
summary(mod3)

#predict CKD using the backwards stepAIC model
phat3=predict(mod3, crossval = test, type = "response")
phat3=predict(mod3,type="response")  # predicts for all in sample data
summary(phat3) 
# probabilities of CKD range from .00001% to 85.7
# the median is .015, so half the patients have less than a 1.5%
# chance of getting CKD

#Classification
# We set our threshold to the mean of the probabilities (.077) and find that this
# gives the greatest profit.If someone has a 7.7% or above predicted chance of CKD,
# we test them.
summary(phat3)
classify=ifelse(phat3>.077,1,0) 
summary(classify)  

# to run this, first run the bottom function created by Dr.Matthew J. Schneider
cc=c_accuracy(train$CKD,classify)
round(cc,5)

#Predict the amount of money the test will generate. 
# A true positive earns $1,300 and a false positive costs $100
money=cc[7]*1300-cc[9]*(100)
money





#Test to see how well all variables predict
#model2=glm(CKD~.,family="binomial",data=train)
#model2
## predictions of new data
#phatnew2=predict(model2, testthis = test, type = "response")

#Predicted CKD values
phat3
#bind these predictions to our testing data
Testing_CKDall= cbind(test,phat3)
Testing_CKDall
write.table(Testing_CKDall,file="testingCKDall_NEW.csv", sep=",")

#------------------------------------------
## Function Below, RUN THIS FIRST
## make sure actuals and classifications are 0 (no) or 1 (yes) only 
##  Built by Matthew J. Schneider

c_accuracy=function(actuals,classifications){
  df=data.frame(actuals,classifications);
  
  tp=nrow(df[df$classifications==1 & df$actuals==1,]);        
  fp=nrow(df[df$classifications==1 & df$actuals==0,]);
  fn=nrow(df[df$classifications==0 & df$actuals==1,]);
  tn=nrow(df[df$classifications==0 & df$actuals==0,]); 
  
  recall=tp/(tp+fn)
  precision=tp/(tp+fp)
  accuracy=(tp+tn)/(tp+fn+fp+tn)
  tpr=recall
  fpr=fp/(fp+tn)
  fmeasure=2*precision*recall/(precision+recall)
  scores=c(recall,precision,accuracy,tpr,fpr,fmeasure,tp,tn,fp,fn)
  names(scores)=c("recall","precision","accuracy","tpr","fpr","fmeasure","tp","tn","fp","fn")
  
  #print(scores)
  return(scores);
}
#------------------------------------------
############# Screening Tool##############
# To simplify our screening tool, we will 
# create a regression using the variables
#identified by the logistic regression model.
#------------------------------------------

#Run linear regression with our variables
linearMod <- lm(CKD ~ Age+Female+Racegrp+PVD+Activity+Hypertension+
                  Fam.Hypertension +Diabetes+CVD+CHF+Anemia+BMI, data=data_in) 
summary(linearMod)
cor(data_in$CKD, data_in$Diabetes)
plot(data_in$CKD, data_in$Age)

cor(data_in$CVD, data_in$CHF)
summary(data_in)

# For the assignment requirements, output a CSV file with only those
# predicted to have CKD.
onlyCKD<-subset(data_in,data_in$CKD==1)
onlyCKD
write.table(onlyCKD,file="onlyckd2.csv", sep=",")
