/*Lets consider marital status as a factor for higher mental illness*/

data brfss_b4(keep= _BMI5CAT  _MENT14D _PHYS14D SEX1 _INCOMG MARITAL _EDUCAG);
set data.brfss_a;
run;

proc freq data=brfss_b4;
tables MARITAL;
run;

/*Removing missing/refused Marital status*/
data brfss_c4;
set brfss_b4;
if MARITAL = . or MARITAL = 9 then delete;
else output brfss_c4;
run; 

data brfss_d4;
set brfss_c4;
if _MENT14D= 9 then delete;
else output brfss_d4;
run; 


data brfss_e4;
set brfss_d4;
length MaritalStatus $ 29. MentalHealthIssues $ 8.;
if MARITAL =1 then MaritalStatus = "Married";
else if MARITAL =2 then MaritalStatus = "Divorced";
else if MARITAL =3 then MaritalStatus = "Widowed";
else if MARITAL =4 then MaritalStatus = "Separated";
else if MARITAL =5 then MaritalStatus = "Never Married";
else MaritalStatus = "Member of an unmarried couple";
if _ment14d =1 then MentalHealthIssues = "0 days";
else if _ment14d =2 then MentalHealthIssues= "<14 days";
else MentalHealthIssues= ">14 days";
run;

proc freq data=brfss_e4;
tables MaritalStatus;
run;


proc sort data=brfss_e4 out=brfss_f4;
by descending MaritalStatus;
run;

/*Mental health issues vs Marital status*/
ods graphics on; 
proc freq data=brfss_f4;
tables MentalHealthIssues * MaritalStatus / chisq plots=all;

run;
ods graphics off;

/* Married and Widowed respondants have maximum % without any mental health issues 72.49% and 73.31% respectively.
Separated respondants have the maximum days with mental health issues 23.37% and 24.42% i.e. 47.80% followed by
Member of an unmarried couple(29.45%+16.26%) 45.71%, Never married with (28.79%+16.24%)45.03% and Divorced with
(21.39%+16.47%) 37.89%.
Least for Widowed(26.68%)and Married respondants(27.51%).

Therefore we can say that married have less mental health issues as they have some sort of stablibity.*/



