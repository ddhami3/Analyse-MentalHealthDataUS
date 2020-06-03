/*Inorder to perform logistics regresion, we need binary outcome, 
hence combining stress as one option.*/
data brfss_d1;
set brfss_d;
if _MENT14D = 1 then _MENT14D2 = "No stressful days";
else _MENT14D2= "Have stressful days";
run;

proc freq data=brfss_d1;
tables _MENT14D2;
run;

/*Remove missing/unknown gender*/
data brfss_e1;
set brfss_d1;
if SEX1 = 7 or SEX1= 9 then delete;
else output brfss_e1;
run;

proc freq data=brfss_e1;
tables sex1;
run;

/*Bivariate analysis*/
proc freq data=brfss_e1 ;
tables  _MENT14D2 * _BMI5CAT2 ;
run;

proc freq data=brfss_e1 ;
tables  _MENT14D2 * sex1 ;
run;
/*Same analysis as first one:key1:*/

/*Logistic Regression*/
ods graphics on;
proc logistic data=brfss_e1 plots=all;
model _MENT14D2 =  _BMI5CAT sex1;
run;
ods graphics off;
/*y(_MENT14D2)=-1.6039+0.0639_BMI5CAT+0.4610SEX1

Odds Ratio: With 1 unit increase in BMI the odds of having mental health issues increases by 1.066.
With 1 unit increase in BMI the mental health issues increases by 0.0639.

AUC is 0.56 which means that it not a good classifier.*/

