data brfss_b(keep= _BMI5CAT  _MENT14D _PHYS14D SEX1);
set data.brfss_a;
run;
/*Univariate analysis of BMI*/
proc freq data=brfss_b ;
tables _BMI5CAT;
run;

/*Removed Unknown BMI*/
data brfss_c;
set brfss_b;
if _BMI5CAT eq . then delete;
else  output  brfss_c;
run;

data brfss_c;
set brfss_c;
if _BMI5CAT = 1 then _BMI5CAT2= "Underweight";
else if  _BMI5CAT = 2 then _BMI5CAT2= "Normal";
else if _BMI5CAT=3 then _BMI5CAT2= "Overweight";
else _BMI5CAT2= "Obese";
run;

proc freq data=brfss_c ;
tables _BMI5CAT2 ;
run;


/*Univariate analysis of Mental Health*/
proc freq data=brfss_c;
tables _MENT14D;
run;

data brfss_d;
set brfss_c;
if _MENT14D = 9 then 
	delete;
else 
	output brfss_d;
run;

data brfss_d;
set brfss_d;
if _MENT14D = 1 then _MENT14D2 = "Above Average: 0 days";
else if  _MENT14D = 2 then _MENT14D2= "Average:<14days";
else _MENT14D2= "Below Average:>14days";
run;

proc freq data=brfss_d;
tables _MENT14D2;
run;

/*Remove missing/unknown gender*/
data brfss_e;
set brfss_d;
if SEX1 = 7 or SEX1= 9 then delete;
else output brfss_e;
run;

proc freq data=brfss_e;
tables sex1;
run;

/*Bivariate Analysis */
proc freq data=brfss_e ;
tables  _MENT14D2 * _BMI5CAT2 ;
run;

/*Graphical Representation*/
ods graphics on;
proc freq data=brfss_e ;
tables _MENT14D2 *_BMI5CAT2  / chisq plots=all;
run;
ods graphics off;

/* Underweight respondants are more likely to stay mentally unhealthy for more than 14 a month.
followed by obese respondants. Overweight and people with normal BMI are less likely to have mental issues.

Chi-sq test suggests that there is a BMI is statistically significant indeterming mental health of a person*/

/*Across Gender*/
proc sort data=brfss_e out=brfss_f;
by sex1;
run;

ods graphics on;
proc freq data=brfss_f ;
by sex1;
tables _MENT14D2 *_BMI5CAT2 / chisq plots=all;
run;
ods graphics off;

/*On average Women who are obese and overweight have more days with mental health issues when compared to men.
Mental health (>14days)-Women:obese(17.55%) overweight(11.43%) vs Men:obese(11.26%) overweight(8.00%)
Mental health (<14days)-Women:obese(25.54%) overweight(23.60%) vs Men:obese(17.91%) overweight(16.89%)
Women(24.66%) have more Average(<14days) stressful days than men(20.64%).*/


