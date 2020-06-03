/* Examine physical health in relation with mental health*/
data brfss_b2(keep= _BMI5CAT  _MENT14D _PHYS14D SEX1 );;
set brfss_b;
run;

/*Removing missing values:Physical health*/
data brfss_c2;
set brfss_b2;
if _PHYS14D = 9 then delete;
else output brfss_c2;
run;

data brfss_c2;
set brfss_c2;
if _PHYS14D = 1 then _PHYS14D2= "Phy Healthy";
else if  _PHYS14D = 2 then _PHYS14D2= "Phy Moderately Healthy";
else _PHYS14D2= "Phy Not Healthy";
run;
proc freq data=brfss_c2;
tables _PHYS14D;
run;
/*Removing missing values for : Mental health*/
data brfss_d2;
set brfss_c2;
if _ment14D = 9 then delete;
else output brfss_d2;
run;

data brfss_d2;
set brfss_d2;
if _ment14D = 1 then _ment14D2= "Mentally Healthy";
else if  _ment14D = 2 then _ment14D2= "Mentally Moderately Healthy";
else _ment14D2 = "Mentally Not Healthy";
run;

proc freq data=brfss_d2;
tables _ment14d;
run;

/*Check for relationship between Mental and Physical health*/
ods graphics on;
proc freq data=brfss_d2;
tables _ment14d2*_PHYS14D2 / chisq plots=all;
run;
ods graphics off;

/* Chisquare suggestes that there physical health is statistically significant since p-value <0.001.*/

/*People who had no physical health issues and had no mental health issues comprised of 77.09% of all physically healthy respondatns
followed by 17.08% who had moderate mental issues .i.e. <14 days. and just %5.83% had mental health issues for more than 14days.
Moderatelt physically healthy respondants had a distributon of 52.90%, 34.16% and 12.94% mental health.
Physically not healthy repondants had the worst mental health with 34.85% and 19.93% mentally moderately healthy.*/

 
 
