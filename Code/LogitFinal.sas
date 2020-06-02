/* Lets try and predict the likelyhood of a person having more mental health issues.*/


/*Possible factors**********Naive Bayes**/
/*BMI, SEX1, PhysicalHealth, Income, MaritalStatus, Education, Age*/
proc contents data=brfss_l;
run;

data brfss_l(keep= _MENT14D _BMI5CAT SEX1 _PHYS14D _INCOMG MARITAL _EDUCAG _AGE_G);
set data.brfss_a;
RUN;

DATA brfss_l;
set brfss_l;
if _MENT14D = 1 then
	Mental_Health = "No stressful days";
	
else 
	Mental_Health= "Have stressful days";

run;

proc freq data=brfss_l;
tables Mental_Health;
run;

/* Remove missing values*/

data brfss_l1;
set brfss_l;
if _incomg = 9 then delete;
else output brfss_l1;
run; 


data brfss_l2;
set brfss_l1;
if _Ment14d = 9 then delete;
else  output brfss_l2;
run;

data brfss_l3;
set brfss_l2;
if _phys14d = 9 then delete;
else  output brfss_l3;
run;

data brfss_l4;
set brfss_l3;
if marital = 9 or marital= . then delete;
else  output brfss_l4;
run;

data brfss_l5;
set brfss_l4;
if sex1 = 9 or sex1 =7 then delete;
else  output brfss_l5;
run;

data brfss_l6;
set brfss_l5;
if _educag = 9 then delete;
else  output brfss_l6;
run;

data brfss_l7;
set brfss_l6;
if _BMI5CAT = . then delete;
else  output brfss_l7;
run;

proc freq data=brfss_l7;
run;
/*Correlation*/

proc corr data=brfss_l7;
run;
/* None of the variables are highly correlated hence we can proceed with Logistic Regression*/

/****************Logistic Regression***************/

ods graphics on;
proc logistic data=brfss_l7 plots=all;
model Mental_health(event='No stressful days') = _BMI5CAT SEX1 _PHYS14D _INCOMG MARITAL _EDUCAG _AGE_G / selection=stepwise;
run;
ods graphics off;

data data.brfss_l8;
set brfss_l7;
run;
/*All 7 variables are statistically significant.*/

%let interval=_BMI5CAT SEX1 _PHYS14D _INCOMG MARITAL _EDUCAG _AGE_G;



proc partition data=brfss_l7 partition samppct=70;
  by Mental_health;
  output out=data2 copyvars=(_ALL_);
run;


/* Create a CAS engine libref to save the output data sets */
%let caslibname = mycas;     
libname &caslibname cas caslib=casuser;


proc partition data=&casdata partition samppct=70;
  by &target;
  output out=&partitioned_data copyvars=(_ALL_);
run;
/************************************************************************/
/* NEURAL NETWORK predictive model                                      */
/************************************************************************/
proc nnet data=&partitioned_data;
  target &target / level=nom;
  input &interval_inputs. / level=int;
  input &class_inputs. / level=nom;
  hidden 2;
  train outmodel=mycaslib.nnet_model;
  partition rolevar=_partind_(train='1' validate='0');
  ods exclude OptIterHistory;
run;

proc options option=rlang;

run;
