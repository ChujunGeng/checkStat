Description:

This collection of scripts helps me with grading warmup#2 assignment. It freed  
me of manually put student's output data into a spreadsheet calculator, and 
saved some time.

What it does is to run a special test case and compute expected statistics,
except for drop probabilities. Then it will display the expected statistics 
alongside student's computation. Finally, the results have to be compared 
manually.

Currently there're 3 components
	1.checkStat.sh: The main bash script to start with. It runs 
student's program and greps data from their trace output, and then executes the 
other 2 scripts.
	2.grader.py: Computes the expected statistics using student's output.
	3.getStat.awk: Get the student-computed statistics from the output.(Note
: this awk script has been merged into the bash script as a heredoc)


Usage: $checkStat.sh
	then compare the results manually


Compatibility:

Works well on macOS 10.13, Ubuntu 14.04 and Solaris

