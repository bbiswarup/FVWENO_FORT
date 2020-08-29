#!/bin/bash
# Developed by : Pritam Giri
# Date : 8.10.2016
# TIFR-CAM
# Note: Some modification has been done
i=0;
flag=1;
while [ "$flag" = "1" ];
do
	if ls $(printf "sol-%0.3d*" $i) >/dev/null 2>&1;
	then
		nx=0; ny=0;
		# gather all solutions at a specific time in inputfile
		# we will merge in output file
		inputfile=$(printf "sol-%0.3d*" $i)
		outputfile=$(printf "sol-%0.3d.plt" $i)
		for filename in $inputfile
		do
		# Get only numeric portion
			awk 'NR>=4' $filename >> patch
		# get the local nx, ny and sum for all rank
			nxloc=$(awk -F"[=,]" 'NR==3{print $6}' $filename)
			nyloc=$(awk -F"[=,]" 'NR==3{print $8}' $filename)
			nx=$((nx + nxloc));	ny=$((ny + nyloc))
		done
		# global nx and ny
		nx=$((nx/2)); ny=$((ny/2));
		# get the time from any one rank 
		soltime=$(awk -F"[=,]" 'NR==3{print $4}' $filename)
		# writing the output file
		awk 'NR<3' $filename > $outputfile
		echo "ZONE STRANDID=1, SOLUTIONTIME=$soltime, I=$nx, J=$ny, DATAPACKING=POINT" >> $outputfile
		# sorting is important for plotting in visit
		sort -g -k2 -k1 patch >> $outputfile
		# end writing
		rm $(printf "sol-%0.3d-*" $i) patch
		i=$((i + 1))
	else
		flag=0
	fi
done
