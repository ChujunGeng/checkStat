import sys
import math

def getVariance(_list):
    list_sq = []
    for i in _list:
        list_sq.append(i*i)
    avg = getAverage(_list)
    avg_sq = avg*avg
    return getAverage(list_sq) - avg_sq

def getStd(_list):
    return math.sqrt(getVariance(_list))

def getAverage(_list):
    return sum(_list)/float(len(_list))


class Grader:
    '''
    an automated grader for CS402's warmup#2 assignment at USC
    '''
    def __init__(self):
        self.endTime = 0
        self.packet = {}

    def _collectData(self):
        '''
        read time data and place them to following places:
        packet[i][0] --- arrival time
        packet[i][1] --- time entering Q1
        packet[i][2] --- time leaving Q1
        packet[i][3] --- time entering Q2
        packet[i][4] --- time leaving Q2
        packet[i][5] --- time beginning service
        packet[i][6] --- time finishing service
        '''
        for i in range(1, 6):
            if i not in self.packet:
                self.packet[i] = []
            filename = "temp.p" + str(i)
            f = open(filename, 'r')
            for line in f:
                try:
                    self.packet[i].append(float(line))
                except ValueError:
                    sys.stderr.write('Grading Helper: [ERROR]Invalid data\n')
                    print 'Grading Helper: Problem detected. Manual inspection is suggested'
                    quit()


    def analyzeStat(self, end_time):
        '''
        Calculate the statistics from student's output
        '''
        inter_arrival_time = []
        time_in_q1 = []
        time_in_q2 = []
        time_in_server = []
        time_in_sys = []

        self._collectData()
        self.endTime = end_time/1000

        #compute inter-arrival time and time in each facility
        prev_arrival = 0
        for p in self.packet:
            inter_arrival_time.append((self.packet[p][0] - prev_arrival)/1000)
            time_in_q1.append((self.packet[p][2] - self.packet[p][1])/1000)
            time_in_q2.append((self.packet[p][4] - self.packet[p][3])/1000)
            time_in_server.append((self.packet[p][6] - self.packet[p][5])/1000)
            time_in_sys.append((self.packet[p][6] - self.packet[p][0])/1000)
            prev_arrival = self.packet[p][0]
            
        #compute expected stats
        avg_inter_arrival = getAverage(inter_arrival_time)
        avg_service_time = getAverage(time_in_server)
        avg_pkt_in_q1 = sum(time_in_q1)/self.endTime
        avg_pkt_in_q2 = sum(time_in_q2)/self.endTime
        avg_pkt_in_server = sum(time_in_server)/self.endTime
        avg_time_in_sys = getAverage(time_in_sys)
        std_time_in_sys = getStd(time_in_sys)

        print 'Expected Statistics:'
        print '    average packet inter-arrival time =', avg_inter_arrival
        print '    average packet service time =', avg_service_time
        print '    average number of packets in Q1 =', avg_pkt_in_q1
        print '    average number of packets in Q2 =', avg_pkt_in_q2
        print '    average number of packets in S1+S2 =', avg_pkt_in_server
        print '    average time a packet spent in system =', avg_time_in_sys
        print '    standard deviation for time spent in system =', std_time_in_sys

if __name__ == '__main__':
    try:
        endTime = float(sys.argv[1])
    except ValueError:
        sys.stderr.write('Grading Helper: [ERROR]Invalid ending time\n')
        print 'Grading Helper: Problem detected. Manual inspection is suggested'
        quit()
    grader = Grader()
    grader.analyzeStat(endTime)

