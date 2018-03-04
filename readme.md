# ~~Santa's~~ Grader's Little Helper

## Description
This collection of scripts helps me with grading warmup#2 assignment. It freed me from manually putting student's output data into a spreadsheet calculator, and saved me some time.

What it does is to run a special test case and compute expected statistics (except for drop probabilities). Then it will display the expected statistics alongside student's results. Finally, the results have to be compared manually.

If the student's trace output is malformed, these scripts will probably **not** work properly. In that case, unfortunately, you have to fall back to using that good ol' spreadsheet calculator.

### Currently there're 3 components:
1. `checkStat.sh`: The main bash script to start with. It will run `./warmup2 -n 5 -r 2.5` and grep timestamps from the trace output, and finally execute the other 2 scripts.
2. `grader.py`: Computes the expected statistics using timestamps from trace output.
3. `getStat.awk`: Extracts student's statistics from trace output. (Note: this awk script has been merged into `checkStat.sh` as a heredoc)

## Usage
$`checkStat.sh`,
then compare the results **manually**

### Sample Output
```
$ cd Documents/CS402/Warmup2
$ ~/Documents/gradersLittleHelper/checkStat.sh
>>>Running warmup2...
>>>warmup2 has returned...
>>>Collecting data from the output...
>>>Collecting data of packet p1...done
>>>Collecting data of packet p2...done
>>>Collecting data of packet p3...done
>>>Collecting data of packet p4...done
>>>Collecting data of packet p5...done
>>>Analyzing statistics...
================================================================================
Expected Statistics:
    average packet inter-arrival time = 1.00077
    average packet service time = 2.86123
    average number of packets in Q1 = 0.32805
    average number of packets in Q2 = 0.17687
    average number of packets in S1+S2 = 1.46003
    average time a packet spent in system = 3.85080
    standard deviation for time spent in system = 0.61649
================================================================================
Statistics:
    average packet inter-arrival time = 1.00077s
    average packet service time = 2.86123s
    average number of packets in Q1 = 0.328069
    average number of packets in Q2 = 0.176867
    average number of packets in S1 = 0.875878
    average number of packets in S2 = 0.584148
    average time a packet spent in system = 3.8508s
    standard deviation for time spent in system = 0.616493s
    token drop probability = 0
    packet drop probability = 0
================================================================================
>>>Please compare the expected results with student's output...
```

## Compatibility
Works well on macOS 10.13, Ubuntu 14.04 and Solaris
