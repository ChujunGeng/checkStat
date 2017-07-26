#!/usr/bin/env bash

###########################
#	AWK Script	  #
###########################
read -d '' getStat << 'EOF'
/Statistics/,0{
	print $0;
	}
EOF
###########################
#	End of AWK Script #
###########################

print_boundary()
{
	local i=0
	while [ $i -lt 80 ] ; do
		printf '>'
		i=`expr $i '+' 1`
	done
	printf '\n'	
}

notInOrder()
{
	#check if timestamps are in descending order
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

if [ ! -x './warmup2' ]; then
	echo "Grading Helper:[ERROR]no executable named warmup2 found" 1>&2
	exit 2
fi

echo "Running warmup2..."
./warmup2 -n 5 -r 2.5 > temp

awk 'NF' temp > temp.compact
echo "warmup2 has returned..."
echo "Collecting data from the output..."

for i in 1 2 3 4 5 ; do
	printf "Collecting data of packet p$i..."
	#get the time data for each packet
	grep "[Pp]$i" temp | sed "s/ms.*//" | sed "s/^0*//" > "temp.p$i"
	line_cnt=`wc -l < "temp.p$i"`
	#check if there're 7 lines in total
	if [ $line_cnt -ne 7 ] ; then
		echo
		echo "Grading Helper:[ERROR]there're $line_cnt lines of output for packet p$i" 1>&2
		echo "Grading Helper: Problem detected. Manual inspection is suggested"
		exit 1
	fi
	#check if time data is in ascending order
	if notInOrder < "temp.p$i" ; then
		echo
		echo "Grading Helper:[ERROR]output not in correct order" 1>&2
		echo "Grading Helper: Problem detected. Manual inspection is suggested"
		exit 1
	fi
	echo "done"
done

#get emulation end time and compare with expected results
if cat temp | grep 'ms.*[Ee]mulation.*[Ee]nd' > temp.end ; then
	etime=`cat temp.end | sed 's/ms.*//' | sed 's/^0*//'`
	echo "Analyzing statistics..."
	print_boundary
	python "$path/grader.py" $etime
	print_boundary
	awk "$getStat" temp.compact
	print_boundary
	echo "Please compare the above results with student's output..."
else
	echo 'Grading Helper: [ERROR] cannot find emulation ending time' 1>&2
	echo 'Grading Helper: Problem detected. Manual inspection is suggested'
	exit 1
fi

#cleanup
rm -f temp.* temp

