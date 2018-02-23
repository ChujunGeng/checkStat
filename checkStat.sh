#!/usr/bin/env bash

###########################
#	AWK Script	  #
###########################
read -d '' getStat << 'EOF'
/[Ss][Tt][Aa][Tt][Ii][Ss][Tt][Ii][Cc][Ss]/,0{
	print $0;
}
EOF
###########################
#    End of AWK Script    #
###########################

printBoundary()
{
	local i=0
	while [ $i -lt 80 ] ; do
		printf '='
		i=`expr $i '+' 1`
	done
	printf '\n'	
}

notInOrder()
{
	#check if timestamps are not in correct order
	local line
	read line
	prev=$line
	while [ "x$line" != "x" ] ; do
		local cmp=`perl -e "if($line < $prev){\
					print 0;\
				}\
				else{\
					print 1;\
				}"`
		if [ $cmp -eq 0 ] ; then
			return 0
		fi
		prev=$line
		read line
	done
	return 1
}

path=`echo "$0" | sed "s/checkStat\.sh//"`
if [ "x$path" == "x" ]; then
	path=`pwd`
fi

#check if warmup2's executable is in current working directory
if [ ! -x './warmup2' ]; then
	echo "[ERROR] cannot find warmup2 executable file" 1>&2
	exit 2
fi

#run warmup2 with certain configs and save trace output to ./temp
echo ">>>Running warmup2..."
./warmup2 -n 5 -r 2.5 > temp

#remove empty lines in the ./temp file
awk 'NF' temp > temp.compact
echo ">>>warmup2 has returned..."
echo ">>>Collecting data from the output..."

#collect each packet's timestamp and check if the trace output is valid
shouldAbort=0
for i in 1 2 3 4 5 ; do
	printf ">>>Collecting data of packet p$i..."
	#get the timestamps from each packet and remove leading 0s
	grep "[Pp]$i" temp | sed "s/ms.*//" | sed "s/^0*//" > "temp.p$i"
	line_cnt=`wc -l < "temp.p$i"`
	#check if there're 7 lines in total
	if [ $line_cnt -ne 7 ] ; then
		echo
		echo "[ERROR] there're $line_cnt lines of output for packet p$i" 1>&2
		shouldAbort=1
	fi
	#check if timestamps are in ascending order
	if notInOrder < "temp.p$i" ; then
		echo
		echo "[ERROR] timestamps not monotonically non-decreasing" 1>&2
		shouldAbort=1
	fi
	echo "done"
done

#Stop the script if the trace output is malformed
if [ $shouldAbort -eq 1 ] ; then
	exit 1
fi

#get emulation ending time and calculate expected results using Python
if grep '[Ee]mulation.*[Ee]nd' temp | sed 's/ms.*//' > temp.end ; then
	echo ">>>Analyzing statistics..."
	printBoundary
	python "$path/grader.py"
	printBoundary
	awk "$getStat" temp.compact
	printBoundary
	echo ">>>Please compare the expected results with student's output..."
else
	echo '[ERROR] cannot find emulation ending time' 1>&2
	exit 1
fi

#cleanup
#rm -f temp.* temp

