import os
import errno

FIFO = 'mypipe'

try:
    os.mkfifo(FIFO)
except OSError as oe:
    if oe.errno != errno.EEXIST:
        raise

while True:
    print("Opening FIFO...")
    with open(FIFO) as fifo:
        print("FIFO opened")
        while True:
            data = fifo.read()
            if len(data) == 0:
                print("Writer closed")
                v = open(FIFO,"w")
                v.write("hello world")
                v.flush()
                break
            print('Read: "{0}"',data)

# v = open(FIFO, "w")
# v.write("hello world")
