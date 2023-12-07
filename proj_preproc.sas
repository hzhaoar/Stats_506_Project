%let in_path = ~/HW/final_project/raw_data;
%let out_path = ~/HW/final_project/output_data; 
libname in_lib "&in_path."; 
libname out_lib "&out_path.";

data out_lib.cbecs;
	set in_lib.cbecs2018_final_public_20221205;
	keep PBA 
	EGYUSED ELUSED NGUSED FKUSED PRUSED STUSED 
	HWUSED CWUSED WOUSED COUSED SOUSED OTUSED 
	SQFT BLDSHP NFLOOR FLCEILHT
	GLSSPC YRCONC
	FINALWT;
run; 


data out_lib.cbecs;
	set out_lib.cbecs;	
	/* Remove the observations with no energy used */
	where EGYUSED = 1; 
run;

data out_lib.cbecs;
	set out_lib.cbecs;	
	/* Remove the observations with other energy used */
	where OTUSED = 2; 
run;



data out_lib.cbecs;
    set out_lib.cbecs;
    /* Count occurrences of 2 across specific variables */
    num_source = countc(cats(of ELUSED NGUSED FKUSED PRUSED STUSED 
	HWUSED CWUSED WOUSED COUSED SOUSED),'1');
	drop EGYUSED ELUSED NGUSED FKUSED PRUSED STUSED 
	HWUSED CWUSED WOUSED COUSED SOUSED OTUSED;
run;

/* Export the dataset to a CSV file */
proc export data=out_lib.cbecs
  outfile="&out_path./cbecs_csv.csv"
  dbms=csv replace;
  delimiter = ",";
run;



