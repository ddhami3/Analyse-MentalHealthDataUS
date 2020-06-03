libname data "D:\Summer Semester\HealthCare\Data";

libname XPTfile xport "D:\Summer Semester\HealthCare\Data\LLCP2018.XPT_";

/*A data set named BRFSS_a is created */
data data.BRFSS_a;
	set XPTfile.LLCP2018;
run;

proc contents data=data.BRFSS_a;
run;

/*Observations: 437436
Variables:275*/

 
proc export data=data.BRFSS_a
outfile='D:/Summer Semester/HealthCare/Data/BRFSS_a.csv' /*Use the same path as above, adding a forward slash and the name of
your file.csv ( /ExampleCSV.csv )*/
dbms=csv
replace;
run;
