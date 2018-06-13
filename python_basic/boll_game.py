import threading
import random
import time
import Queue

class ring():

    _lock = threading.Lock()
    count = 0
    queue = Queue.Queue(maxsize=1)

    def sender(self):
        """ Send boll"""
        rand = random.Random()
        rand.seed(time.time())
        boll = rand.randint(0,2)
        while boll != -1:
            with self._lock:
                    try:
                        self.queue.put_nowait(boll)
                        boll = -1
                    except Queue.Full:
                        pass
            time.sleep(0.1)

    def door(self):
        rand = random.Random()
        rand.seed(time.time())
        accept = rand.randint(0,2)
        while accept != -1 :
            with self._lock:
                try:
                    boll = self.queue.get_nowait()
                    if accept == boll:
                        print "Y"
                        self.inc()
                    else:
                        print "N"
                    accept = -1
                except Queue.Empty:
                    pass
            time.sleep(0.1)

    def inc(self):
        self.count += 1

    def start(self):
        threads = []
        for x in xrange(0, 1000):
            threads.append(threading.Thread(target=self.sender))
            threads.append(threading.Thread(target=self.door))
        for t in threads:
            t.start()
        for t in threads:
            t.join()
        print "Game over. Accept:%d", self.count

if __name__ == "__main__":
    game = ring()
    game.start()
