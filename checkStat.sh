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
	# Print an 80-character long horizontal line
	local i=0
	while [ $i -lt 80 ]; do
		printf '='
		i=`expr $i '+' 1`
	done
	printf '\n'	
}

notInOrder()
{
	# Check if timestamps are not in correct order
	local line
	read line
	prev=$line
	while [ "x$line" != "x" ]; do
		# Use Perl for floating point comparison
		local cmp=`perl -e "if($line < $prev){\
					print 0;\
				}\
				else{\
					print 1;\
				}"`
		if [ $cmp -eq 0 ]; then
			return 0
		fi
		prev=$line
		read line
	done
	return 1
}

path=`echo "$0" | sed "s/checkStat\.sh//"`
if [ "x$path" == "x" ]; then
	# If checkStat.sh is on your path, then look for it
	path=`which 'checkStat.sh' | sed 's/checkStat\.sh//'`
fi

# Check if grader.py is in the same directory as checkStat.sh
if [ ! -e "$path/grader.py" ]; then
	echo "[ERROR] cannot find grader.py inside $path" 1>&2
	exit 2
fi

awk='awk'
if [ "x`uname -a | grep 'nunki'`" != "x" ]; then
	# Switch to nawk if on nunki
        awk='nawk'
fi

# Check if warmup2's executable is in current working directory
if [ ! -x './warmup2' ]; then
	echo "[ERROR] cannot find warmup2 executable file" 1>&2
	exit 2
fi

# Run warmup2 with n=5 r=2.5 and save trace output to ./temp
echo ">>> Running warmup2..."
./warmup2 -n 5 -r 2.5 > temp

# Remove empty lines from the trace output
$awk 'NF' temp > temp.compact
echo ">>> warmup2 has returned..."
echo ">>> Collecting data from the output..."

# Collect each packet's timestamp and check if the trace output is valid
shouldAbort=0
for i in 1 2 3 4 5 ; do
	printf ">>> Collecting data of packet p$i..."
	# Get the timestamps from each packet and remove leading 0s
	grep "[Pp]$i" temp | sed "s/ms.*//" | sed "s/^0*//" > "temp.p$i"
	line_cnt=`wc -l < "temp.p$i"`
	# Check if there're 7 lines of trace output in total
	if [ $line_cnt -ne 7 ]; then
		echo
		echo "[ERROR] there're $line_cnt lines of output for packet p$i" 1>&2
		shouldAbort=1
	fi
	# Check if timestamps are non-decreasing
	if notInOrder < "temp.p$i" ; then
		echo
		echo "[ERROR] timestamps not monotonically non-decreasing" 1>&2
		shouldAbort=1
	fi
	echo "done"
done

# Stop the script if the trace output is malformed
if [ $shouldAbort -eq 1 ]; then
	exit 1
fi

# Get emulation ending time and calculate expected stats using Python
if grep '[Ee]mulation.*[Ee]nd' temp | sed 's/ms.*//' > temp.end ; then
	echo ">>> Analyzing statistics..."
	printBoundary
	python "$path/grader.py"
	printBoundary
	$awk "$getStat" temp.compact
	printBoundary
	echo ">>> Please compare the expected results with student's output..."
else
	echo '[ERROR] cannot find emulation ending time' 1>&2
	exit 1
fi

# Cleanup
# rm -f temp.* temp

