# Predicting_CKD
The main objective of this case study was to create a screening tool which allows identification of those individuals who are at a higher risk of suffering from CKD. The data used in this analysis was gathered by the National Center for Health Statistics of the Centers for Disease Control and Prevention. The data contains information on 33 different variables from 8,819 adults and was collected between 1999 and 2002. 

The dataset contained 1,864 rows of missing data that was imputed using Multivariate Imputation by Chained Equation, or MICE, in R studio.

Variables were chosen for the dataset based on (a) prior medical research, (b) stepAIC, and (c) cross validation.

The predictive model had a median is .015, meaning half the patients have less than a 1.5% chance of getting CKD. The expected profit for our model is $292,200. 

A screening tool was created using linear regression and the variables identified from the logistic regression model. This screening tool identified who should be recommended to be screened for CKD. The screening tool consisted of 8 questions and approximated 95% of the accuracy of the logistic regression model, while maintaining interpretability and ease of use for patients. 

*Please note that this was a group project with another individual, however we developed this project in parallel and all code below was written by myself (with the exception of a *function created by the professor). Please note that apart from two graphs, the executive report was written entirely by me.
