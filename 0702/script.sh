#!/bin/bash

clear

# Coverts .pdf to .txt
pdftotext -layout result_s1.pdf result_s1.txt

# Separates out results of CS students
grep --no-group-separator -A3 "CHN18CS" result_s1.txt > result_cs1.txt

# Cleans up and arranges the data in organised manner
tr  '\n' ' ' < result_cs1.txt > result_s1.txt
sed 's/\t//g' result_s1.txt > result_cs1.txt
awk '{$1=$1;print}' result_cs1.txt > result_s1.txt
sed 's/CHN/\nCHN/g' result_s1.txt > result_cs1.txt
tr  ',' ' ' < result_cs1.txt > result_s1.txt

# Convert Grades to Grade Points 
sed -i 's/(O)/ 10/g' result_s1.txt
sed -i 's/(A+)/ 9/g' result_s1.txt
sed -i 's/(A)/ 8.5/g' result_s1.txt
sed -i 's/(B+)/ 8/g' result_s1.txt
sed -i 's/(B)/ 7/g' result_s1.txt
sed -i 's/(C)/ 6/g' result_s1.txt
sed -i 's/(P)/ 5/g' result_s1.txt
sed -i 's/(F)/ 0/g' result_s1.txt
sed -i 's/(FE)/ 0/g' result_s1.txt
sed -i 's/(I)/ 0/g' result_s1.txt
sed -i 's/(Absent)/ 0/g' result_s1.txt


# Seperates gradepoints and store to another file
awk  '{  
	print $1,$3,$5,$7,$9,$11,$13,$15,$17,$19
 }' result_s1.txt > gp_s1.txt 



# Computes SGPA and counts subjects failed in
awk '{
	sum = 0
	flag = 0
	fails = 0
	for(var =2; var<=NF; var++)
	{	
		if($var == 0) 
		{
			flag = 1
			fails = fails + 1
		}
		sum += $var
	}
	cgpa = sum/9
	if (flag == 0) {	
 	printf("%s %0.2f\n",$1,cgpa)
	}
	if (flag == 1) {
		printf("%s %d\n",$1,-1*fails)
	}
}' gp_s1.txt > cgpa_raw1.txt


pdftotext -layout result_s2.pdf result_s2.txt

grep --no-group-separator -A3 "CHN18CS" result_s2.txt > result_cs2.txt

# Cleans up and arranges the data in organised manner
tr  '\n' ' ' < result_cs2.txt > result_s2.txt
sed 's/\t//g' result_s2.txt > result_cs2.txt
awk '{$1=$1;print}' result_cs2.txt > result_s2.txt
sed 's/CHN/\nCHN/g' result_s2.txt > result_cs2.txt
tr  ',' ' ' < result_cs2.txt > result_s2.txt

# Convert Grades to Grade Points 
sed -i 's/(O)/ 10/g' result_s2.txt
sed -i 's/(A+)/ 9/g' result_s2.txt
sed -i 's/(A)/ 8.5/g' result_s2.txt
sed -i 's/(B+)/ 8/g' result_s2.txt
sed -i 's/(B)/ 7/g' result_s2.txt
sed -i 's/(C)/ 6/g' result_s2.txt
sed -i 's/(P)/ 5/g' result_s2.txt
sed -i 's/(F)/ 0/g' result_s2.txt
sed -i 's/(FE)/ 0/g' result_s2.txt
sed -i 's/(I)/ 0/g' result_s2.txt
sed -i 's/(Absent)/ 0/g' result_s2.txt


# Seperates gradepoints and store to another file
awk  '{  
	print $1,$3,$5,$7,$9,$11,$13,$15,$17,$19
 }' result_s2.txt > gp_s2.txt 



# Computes SGPA and counts subjects failed in
awk '{
	sum = 0
	flag = 0
	fails = 0
	for(var =2; var<=NF; var++)
	{	
		if($var == 0) 
		{
			flag = 1
			fails = fails + 1
		}
		sum += $var
	}
	cgpa = sum/9
	if (flag == 0) {	
 	printf("%s %0.2f\n",$1,cgpa)
	}
	if (flag == 1) {
		printf("%s %d\n",$1,-1*fails)
	}
}' gp_s2.txt > cgpa_raw2.txt
#gedit cgpa_raw2.txt

join --nocheck-order cgpa_raw1.txt cgpa_raw2.txt >sgpa.txt
awk '{
	cgpa=0
	if($2>0 && $3>0)

	{
		cgpa=$2+$3
		printf("%s %0.2f %0.2f %0.2f\n",$1,$2,$3,cgpa)
	}
	else
		printf("%s %0.2f %0.2f\n",$1,$2,$3)

      }' sgpa.txt > cgpa_raw.txt
#add the student name
join --nocheck-order students.txt  cgpa_raw.txt > cgpa.txt

# Removes temperory files used to process
rm result_cs1.txt
rm result_cs2.txt
rm gp_s1.txt
rm gp_s2.txt
rm sgpa.txt
rm cgpa_raw2.txt
rm cgpa_raw1.txt
rm cgpa_raw.txt

#prints the cgpa file
gedit cgpa.txt
