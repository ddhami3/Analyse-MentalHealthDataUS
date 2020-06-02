/*Lets consider Income as factor for determining Mental Health*/

data brfss_b3(keep= _BMI5CAT  _MENT14D _PHYS14D SEX1 _INCOMG);
set brfss_b;
run;

proc freq data=brfss_b3;
tables _INCOMG;
run;

/*Instead of removing, imputing would be an ideal method because there are 76118, missing values. */

data brfss_b4;
set brfss_b3;
if _INCOMG ne 9 then output brfss_b4;
else delete;
run;

proc freq data=brfss_b4;
tables _INCOMG;
run;

/*Renaming*/
data brfss_b4;
set brfss_b4;
if _INCOMG = 1 then IncomeRange = "< $15000";
else if _INCOMG = 2 then IncomeRange = "$15000- $25000";
else if _INCOMG = 3 then IncomeRange = "$25000- $35000";
else if _INCOMG = 4 then IncomeRange = "$35000- $50000";
else IncomeRange = "> $50000";
if _ment14d =1 then MentalHealth = "0 days with mental health issues";
else if _ment14d =2 then MentalHealth= "<14 days with mental health issues";
else MentalHealth= ">14 days with mental health issues";
run;

/*Removing null values for mental health*/
data brfss_b5;
set brfss_b4;
if _ment14d = 9 then delete;
else output brfss_b5;
run;

proc sort data=brfss_b5 out=brfss_b6;
by descending _INCOMG;
run;

/*Relationship between Mental health and Income Range*/
ods graphics on;
proc freq data=brfss_b6;
tables MentalHealth * IncomeRange / chisq plots=all;
run;
ods graphics off;

/*It is very clear from the graph that respondants with lesser salary have higher mental issues on average.
Though Average mental health problems with less than 14days is between 21%-23% for all income ranges.
Respondants with mental health issues >14 days, have a gradual drop as income increases.
i.e.  Income	Mental health issues >14 days
	< $15000 					25.82%
	$15000-$25000   			17.74%
	$25000-$35000				13.05%
	$35000-$50000				10.68%
	> $50000					 6.90%


	
