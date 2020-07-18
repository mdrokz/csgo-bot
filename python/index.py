import errno
import socket               # Import socket module
from selenium import webdriver
# from selenium.webdriver.chrome.options import Options
from selenium.webdriver.firefox.options import Options
from selenium.webdriver.common.keys import Keys
import os
# import sys


options = Options()
options.headless = True
# options._binary_location = './chromedriver_win32/chrome.exe'

# driver = webdriver.Chrome(
#     options=options, executable_path='./chromedriver_win32/chromedriver.exe')
driver = webdriver.Firefox(options=options)


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

def getPrices():
    priceData = []
    priceDataTable = None
    p = ""
    try:
        priceDataTable = driver.find_element_by_xpath(
            "/html/body/div[2]/div[3]/div/div").text
    except Exception as e:
        print(e)
        return

    pricesTableRows = priceDataTable.splitlines()

    for i in range(len(pricesTableRows)):
        if(i == 0):
            continue
        currentRow = pricesTableRows[i]
        currentRowData = currentRow.split(" ")
        if(i < 3):
            skin = currentRowData[0]+" "+currentRowData[1]+currentRowData[2]
            steamPrice = currentRowData[3]
            priceData.append(skin+":"+steamPrice+"\n")
            # f.write(skin+":"+steamPrice+"\n")
        elif(i < 8):
            skin = currentRowData[0]+" "+currentRowData[1]
            steamPrice = currentRowData[2]
            priceData.append(skin+":"+steamPrice+"\n")
            # f.write(skin+":"+steamPrice+"\n")
        else:
            skin = currentRowData[0]
            steamPrice = currentRowData[1]
            priceData.append(skin+":"+steamPrice+"\n")

            # f.write(skin+":"+steamPrice+"\n")
    for price in priceData:
        p = p + price

    return p


def startScraping(url):
    print(url)
    driver.get(url)
    p = getPrices()
    p = getListing(p)
    return p


def getListing(p):
    try:
        steamListing = driver.find_element_by_xpath(
            '//*[@id="prices"]/div[1]/a').get_attribute("href")
        # minWearPriceUrl = driver.find_element_by_xpath(
        #     '//*[@id="DataTables_Table_0"]/tbody/tr[7]/td[2]/a').get_attribute("href")

        # driver.get(minWearPriceUrl)

        # Canvaselem = driver.find_element_by_xpath('//*[@id="pricehistory"]')
        # Canvaselem.screenshot('./element.png')
        p = p + steamListing + "\n"
        return p
    except Exception as e:
        print(e)
        return
    # f.close()


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
            if data and data.strip():
                print('sending data back to the client')
                p = startScraping(data.decode('utf-8'))
                print(p)
                if p:
                    connection.sendall(bytes(p.encode('utf-8')))
                    print('Data sent to client')
                connection.close()
                break
            else:
                print('no more data from', client_address)
                break

    finally:
        # Clean up the connection
        connection.close()

# data = ""
# while True:
#     print("Opening FIFO...")
#     with open(FIFO) as fifo:
#         print("FIFO opened")
#         while True:
#             if data and data.strip():
#                 data = ""

#             data = fifo.readline()

#             if len(data) == 0:
#                 print("Writer closed")
#                 break
#             if data and data.strip():
#                 startScraping(data)
