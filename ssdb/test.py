from ssdb import SSDB
import time

def test():
    client = SSDB()
    s = 'test_'
    e = 'test_~'
    r = []
    while True:
        _m = client.hlist(s, e, 4000)
        print _m
        print "m len %d " %len(set(_m))
        r += _m
        print "r len %d" %len(set(r))
        if len(_m) < 4000:
            print "len %d" %len(r)
            break
        s = _m[1000 - 1 ]
        print s
        time.sleep(1)

if __name__ == "__main__":
    test()
