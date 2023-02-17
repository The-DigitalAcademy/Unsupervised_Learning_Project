%web_drop_table(WORK.SEGM);

FILENAME REFFILE '/home/u62791186/Unsupervised Learning/segmentation_data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.SEGM;
	GETNAMES=YES;
	DATAROW=2;
RUN;

proc means data=work.SEGM nmiss n;
run;

proc means data=work.segm;
run;

DATA WORK.SEGM;
 ATTRIB age_range LENGTH=$5;
 SET WORK.SEGM;
 SELECT;
 WHEN (age >= 18 and age <= 35)  age_range = 'youth';
 WHEN (age >= 36 and  age <= 55) age_range = 'adult';
 OTHERWISE age_range = 'elderly';
 END;
RUN;

DATA work.SEGM; 
 ATTRIB gender LENGTH=$10;
 SET work.SEGM; 
 SELECT;
 WHEN (Sex = 0) gender = 'Male';
 WHEN (Sex = 1) gender = 'Female'; 
END;
run;

DATA work.SEGM; 
 ATTRIB marital_stat LENGTH=$10;
 SET work.SEGM; 
 SELECT;
 WHEN ('Marital status'n = 0) marital_stat  = 'single';
  WHEN ('Marital status'n = 1) marital_stat = 'non_single'; 
END;
run;

DATA work.SEGM; 
 ATTRIB occupation_ LENGTH=$20;
 SET work.SEGM; 
 SELECT;
 WHEN (Occupation = 0) occupation_  = 'unemployed';
 WHEN (Occupation = 1) occupation_ = 'skilled_employee';
 OTHERWISE occupation_ = 'professionals'; 
END;
run;

DATA work.SEGM; 
 ATTRIB city_size LENGTH=$20;
 SET work.SEGM; 
 SELECT;
 WHEN ('settlement size'n = 0) city_size  = 'small city';
 WHEN ('settlement size'n = 1) city_size = 'mid_sized city';
 OTHERWISE city_size = 'big_sized'; 
END;
run;

DATA work.SEGM; 
 ATTRIB qualification LENGTH=$20;
 SET work.SEGM; 
 SELECT;
 WHEN (education = 0) qualification  = 'other';
 WHEN (education = 1) qualification = 'high school';
 WHEN (education = 2) qualification = 'university';
 OTHERWISE qualification = 'school graduate'; 
END;
run;

data work.segm;
set work.segm;
drop occupation sex 'marital status'n 'settlement size'n age education;
run;

title'Counting number of customers by gender';
proc sgplot data=WORK.SEGM;
	vbar gender / datalabel;
	yaxis grid;
run;

title'Ditributing average income by age group';
proc sgplot data=WORK.SEGM;
format income dollar12.2;
	vbar age_range / response=Income stat=mean datalabel;
	yaxis grid;
run; 

title'Ditributing average income by settlement size';
proc sgplot data=WORK.SEGM;
format income dollar12.2;
	vbar city_size / response=Income stat=mean datalabel;
	yaxis grid;
run;

title'Ditributing average income by occupation';
proc sgplot data=WORK.SEGM;
format income dollar12.2;
	vbar occupation_ / response=Income stat=mean datalabel;
	yaxis grid;
run;

title'Distribution of gender by settlement size';
proc sgplot data=WORK.SEGM;
	vbar gender / group=city_size groupdisplay=cluster datalabel;
	yaxis grid;
run;

title'Distribution of gender by marital status';
proc sgplot data=WORK.SEGM;
	vbar gender / group=marital_stat groupdisplay=cluster datalabel;
	yaxis grid;
run;

title'Distribution of occupation by settlement size';
proc sgplot data=WORK.SEGM;
	vbar occupation_ / group=city_size groupdisplay=cluster datalabel;
	yaxis grid;
run;

proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		layout region;
		piechart category=qualification / stat=pct;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

title'Distribution of qualification';
proc sgrender template=SASStudio.Pie data=WORK.SEGM;
run;

title'Distributing the number of qualification by age group';
proc sgplot data=WORK.SEGM;
	vbar age_range / group=qualification groupdisplay=cluster datalabel;
	yaxis grid;
run;

title'Distribution of qaulification by city size';
proc sgplot data=WORK.SEGM;
	vbar qualification / group=city_size groupdisplay=cluster datalabel;
	yaxis grid;
run;

title'Distribution of age group by city size';
proc sgplot data=WORK.SEGM;
	vbar age_range / group=city_size groupdisplay=cluster datalabel;
	yaxis grid;
run;

title'Distribution of marital status by occupation';
proc sgplot data=WORK.SEGM;
	vbar marital_stat / group=occupation_ groupdisplay=cluster;
	yaxis grid;
run;





