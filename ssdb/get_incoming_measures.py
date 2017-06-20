from ssdb import SSDB
from argparse import ArgumentParser
import time



def parse_args():
    parser = ArgumentParser()
    parser.add_argument('-m', '--metric')
    return parser.parse_args()

def get_incoming_measures(metricid):
     db = SSDB()
     
     print db.hgetall(metricid).keys()[-1:]
     start = ""
     end = "~"
     measures = []
     num_measures = db.hsize(metricid)
     print len(db.hgetall(metricid))
     print num_measures
     while True:
         _next = db.hkeys(metricid, start, end, 1000)
         measures += _next
         if len(measures) ==  num_measures:
             break
         start = _next[-1:]
         print start
         print len(measures)
         print len(set(measures))
         time.sleep(1)

     print len(measures)
     print len(set(measures))

if __name__ == "__main__":
    
  kwargs = parse_args() 
  get_incoming_measures(getattr(kwargs, 'metric'))
