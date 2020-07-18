import os
import socket
import errno
import sys
import time

SERVER_ADDRESS = '/tmp/socket'

FIFO = 'mypipe'

try:
    os.unlink(SERVER_ADDRESS)
except OSError:
    if os.path.exists(SERVER_ADDRESS):
        raise

try:
    os.mkfifo(FIFO)
except OSError as oe:
    if oe.errno != errno.EEXIST:
        raise

sock = socket.socket(socket.AF_UNIX, socket.SOCK_STREAM)

print('starting up on %s' % SERVER_ADDRESS)
sock.bind(SERVER_ADDRESS)

sock.listen(1)

while True:
    # Wait for a connection
    print('waiting for a connection')
    connection, client_address = sock.accept()
    try:
        print('connection from', client_address)

        # Receive the data in small chunks and retransmit it
        while True:
            data = connection.recv(1024)
            # data = ""
            print('received "%s"' % data)
            if data:
                print('sending data back to the client')
                connection.sendall(b"HELLO WORLD")
                print('Data sent to client')
                connection.close()
                break
            else:
                print('no more data from', client_address)
                break

    finally:
        # Clean up the connection
        connection.close()


# while True:
#     print("Opening FIFO...")
#     v = os.open(FIFO, os.O_WRONLY)
#     v.write("hello world")
#     v.flush()
#     v.close()
#     # v = open(FIFO, "w")
#     # v.write("hello world")
#     # v.flush()
#     # v.close()
#     with open(FIFO) as fifo:
#         print("FIFO opened")
#         while True:
#             data = fifo.read()
#             if len(data) == 0:
#                 print("Writer closed")
#                 break
#             print('Read: "{0}"', data)

# v = open(FIFO, "w")
# v.write("hello world")
