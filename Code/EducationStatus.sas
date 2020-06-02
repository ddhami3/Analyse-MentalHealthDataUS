/*Lets condsider Education as factor for Mental Health status*/

data brfss_b5(keep= _BMI5CAT  _MENT14D _PHYS14D SEX1 _INCOMG MARITAL _EDUCAG);
set data.brfss_a;
run;

proc freq data=brfss_b5;
tables _EDUCAG;
run;

/*Remove missing values*/
data brfss_c5;
set brfss_b5;
if _EDUCAG = 9 then delete;
else output brfss_c5;
run;

data brfss_d5;
set brfss_c5;
if _MENT14D = 9 then delete;
else output brfss_d5;
run;

/*Renaming*/
data brfss_e5;
set brfss_d5;
length Education $ 30. MentalHealthIssues $ 8.;
if _EDUCAG =1 then Education = "Did not graduate High School";
else if _EDUCAG =2 then Education = "Graduated High School";
else if _EDUCAG =3 then Education = "Attended College or Technical School";
else  Education = "Graduated from College or Technical School";
if _ment14d =1 then MentalHealthIssues = "0 days";
else if _ment14d =2 then MentalHealthIssues= "<14 days";
else MentalHealthIssues= ">14 days";
run;

/*Relationship between Marital Status and Mental Health Issues*/
ods graphics on;
proc freq data=brfss_e5;
tables MentalHealthIssues*Education / chisq plots=all;
run;
ods graphics off;

/*Repsondants who attended College and the once you did not graduate high school have a bit higher proportion of
more days with mental health issues which is around 35%.
Compared to the ones who have Graduated High School and who Graduated from College or Technical School have sighlty lesser
days with mental health issues which is around 32%.*/

/*Hence there is no conclusion evidence*/
