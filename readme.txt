Description:

This collection of scripts helps me with grading warmup#2 assignment. It freed  
me of manually put student's output data into a spreadsheet calculator, and 
saved me lots of time.

What it does is to run a special test case and compute expected statistics,
except for drop probabilities (which is under development). Then it will display
the expected statistics along with student's computation. Finally, the results
have to be compared manually. Actually this comparing process can be automated 
too. Maybe I'll just let the script determine how many points to give and run 
it on all the submissions.

Currently there're 3 components
	1.checkStat.sh: The main bash script to start with. It runs 
student's program and greps data from their trace output, and then invokes the 
other 2 scripts.
	2.grader.py: Computes the expected statistics using student's output.
	3.getStat.awk: Get the student-computed statistics from the output.(Note
: this awk script has been merged into the bash script as a heredoc)


Usage: $checkStat.sh
	then compare the results manually


Compatibility:

Works well on Ubuntu 14.04
For Solaris 10, make sure to change 'awk' to 'nawk' at line 57 and line 90 of
checkStat.sh


Issues:

As of Summer 2017, the script works fine on most students' submissions, with 
exception for those contains typos such as: 'statstics', 'emlation', etc.
Perhaps I have to modify the regular expressions to work around this.

