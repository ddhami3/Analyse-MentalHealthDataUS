/* Lets try and predict the likelyhood of a person having more mental health issues.*/

data brfss_l(keep= _MENT14D _BMI5CAT SEX1 _PHYS14D _INCOMG MARITAL _EDUCAG _AGE_G);
set data.brfss_a;
RUN;
/*****************Possible factors************/
/*BMI, SEX, PhysicalHealth, Income, MaritalStatus, Education, Age*/
proc contents data=brfss_l;
run;



DATA brfss_l;
set brfss_l;
if _MENT14D = 1 then
	Mental_Health = "No stressful days";
	
else 
	Mental_Health= "Have stressful days";

run;

%macro freq(var,table);
proc freq data=&table;
tables &var;
run;
%mend freq;


%freq(Mental_Health,brfss_l)

/* Remove missing values*/

data brfss_l1;
set brfss_l;
if _incomg = 9 then delete;
else output brfss_l1;
run; 

%freq(_incomg,brfss_l1)

data brfss_l2;
set brfss_l1;
if _Ment14d = 9 then delete;
else  output brfss_l2;
run;

%freq(_Ment14d,brfss_l2)

data brfss_l3;
set brfss_l2;
if _phys14d = 9 then delete;
else  output brfss_l3;
run;
%freq(_phys14d,brfss_l3)


data brfss_l4;
set brfss_l3;
if marital = 9 or marital= . then delete;
else  output brfss_l4;
run;
%freq(marital,brfss_l4)

data brfss_l5;
set brfss_l4;
if sex1 = 9 or sex1 =7 then delete;
else  output brfss_l5;
run;

%freq(sex1,brfss_l5)

data brfss_l6;
set brfss_l5;
if _educag = 9 then delete;
else  output brfss_l6;
run;
%freq(_educag,brfss_l6)

data brfss_l7;
set brfss_l6;
if _BMI5CAT = . then delete;
else  output brfss_l7;
run;
%freq(_BMI5CAT,brfss_l7)

/*Correlation*/
title "Correlation Matrix";
proc corr data=brfss_l7;
run;
title;
/* None of the variables are highly correlated hence we can proceed with Logistic Regression*/

/****************Logistic Regression***************/

ods graphics on;
proc logistic data=brfss_l7 plots=all;
model Mental_health(event='No stressful days') = _BMI5CAT SEX1 _PHYS14D _INCOMG MARITAL _EDUCAG _AGE_G / selection=stepwise;
run;
ods graphics off;

/*All 7 variables are statistically significant.*/
/*ROC is 0.7255 which has improved significantly from Logit model1 which was 0.56.
/*Since the slection criterion was stepwise, we get the best model at the last.
Equation: y(Mental_Health=1.4919-0.0412BMI-0.5158SEX-0.8191PhysicalHealth+0.0997Income
				-0.0540Marital-0.0968EDUCATION+0.3319AGE))
/*Since this logit model is for No stressful days, logit model of stressful days will be completely opposite.*/
