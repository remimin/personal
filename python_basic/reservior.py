import random
import time

def sample(k):
    rand = random.Random().seed(time.time())
    rand.randint(0, k)
    return rand

def reservoirsample(file_path, k):
    lines = []
    with open(file_path, "r") as fp:
        lines = fp.readlines(k)
        num = k
        new_line = fp.readline()
        while new_line != '':
            idx = sample(num)
            if idx < k:
                lines[idx] = new_line
            num += 1


