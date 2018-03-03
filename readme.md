# ~~Santa's~~ Grader's Little Helper

## Description:
This collection of scripts helps me with grading warmup#2 assignment. It freed  me of manually put student's output data into a spreadsheet calculator, and saved some time.

What it does is to run a special test case and compute expected statistics (except for drop probabilities). Then it will display the expected statistics alongside student's results. Finally, the results have to be compared manually.

If the student's trace output is malformed, these scripts will probably **not** work properly. In that case, unfortunately, you have to fall back to using that good ol' spreadsheet calculator.

### Currently there're 3 components:
1. `checkStat.sh`: The main bash script to start with. It will run `./warmup2 -n 5 -r 2.5` and grep timestamps from the trace output, and finally execute the other 2 scripts.
2. `grader.py`: Computes the expected statistics using timestamps from trace output.
3. `getStat.awk`: Extracts student's statistics from trace output. (Note: this awk script has been merged into `checkStat.sh` as a heredoc)

## Usage:
$`checkStat.sh`
then compare the results **manually**

## Compatibility:
Works well on macOS 10.13, Ubuntu 14.04 and Solaris
