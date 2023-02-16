/* Generated Code (IMPORT) */
/* Source File: segmentation data.csv */
/* Source Path: /home/u62791191 */
/* Code generated on: 14/02/2023 14:04 */

%web_drop_table(WORK.Segment);


FILENAME REFFILE '/home/u62791191/segmentation data.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=WORK.Segment;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=WORK.Segment; RUN;


%web_open_table(WORK.Segment);


/*Standalize dataset*/
proc standard data=WORK.SEGMENT out=std_mydata mean=0 std=1;
run;
proc print data=std_mydata;
run;
ods noproctitle;
/* perform pca*/
proc princomp data=std_mydata out=pc_scores plots=all ;
var _numeric_;
run;

PROC PRINT DATA=pc_scores;
RUN;
/* K_Means Clustering*/
data pc_scores;
  set pc_scores;
run;
%let num_clusters = 4;
proc fastclus data=pc_scores out=clusters maxclusters=&num_clusters maxiter=50;
  var Prin1	Prin2;
run;

/* Plot the first two principal components */
title 'VIZUALISATION OF CLUSTERS'
ds graphics on;
proc sgplot data=clusters;
  scatter x=Prin1 y=Prin2 / colorresponse=cluster;
run;
ods graphics off;










