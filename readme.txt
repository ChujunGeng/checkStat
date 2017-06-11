Description:

This collection of scripts helps me with grading warmup#2 assignment. It freed  
me of manually put student's output data into a spreadsheet calculator, and 
hopefully will save me lots of time.

What it does is to run a special test case and compute expected statistics,
except for drop probabilities (which is under development). Then it will display
the expected statistics along with student's computation. Finally, the results
have to be compared manually.

Currently there're 3 components
	1.checkStat.sh: The main Bourne-Shell script to start with. It runs 
student's program and subtracts data from the output, then invokes the other 2 
scripts. The shebang has been changed to using a bash interpreter because of 
an execution permission issue with /bin/sh on Solaris.
	2.grader.py: Computes the expected statistics using student's output.
	3.getStat.awk: Get the student-computed statistics from the output.(Note
: this awk script has been merged into the sh script as a heredoc)


Usage: $<path-to-checkStat.sh>/checkStat.sh
	then compare the results manually


Compatibility:

Works well on macOS 10.12.5 and Ubuntu 14.04
As for Solaris, changing 'awk' to 'nawk' in checkStat.sh(line: 57 and 90) will
possibly solve the compatibility issue.


