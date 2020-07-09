import socket               # Import socket module
from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.keys import Keys
import sys 
import codecs
if sys.stdout.encoding != 'cp850':
  sys.stdout = codecs.getwriter('cp850')(sys.stdout.buffer, 'strict')
if sys.stderr.encoding != 'cp850':
  sys.stderr = codecs.getwriter('cp850')(sys.stderr.buffer, 'strict')

options = Options()
options.headless = True
options._binary_location = './chromedriver_win32/chrome.exe'


driver = webdriver.Chrome(
    options=options, executable_path='./chromedriver_win32/chromedriver.exe')
driver.get("https://csgostash.com/skin/1266/M4A1-S-Player-Two")

# get Price Table
priceDataTable = driver.find_element_by_class_name("price-details-table").text
pricesTableRows = priceDataTable.splitlines()

f = open("scrapedData.txt", "a")

for i in range(len(pricesTableRows)):
    if(i == 0):
        continue
    currentRow = pricesTableRows[i]
    currentRowData = currentRow.split(" ")
    if(i < 3):
        skin = currentRowData[0]+" "+currentRowData[1]+currentRowData[2]
        steamPrice = currentRowData[3]
        f.write(skin+":"+steamPrice)

    elif(i < 8):
        skin = currentRowData[0]+" "+currentRowData[1]
        steamPrice = currentRowData[2]
        f.write(skin+":"+steamPrice)

    else:
        skin = currentRowData[0]
        steamPrice = currentRowData[1]
        f.write(skin+":"+steamPrice)

    # print(currentRowData)

# Get steam listings
steamListing = driver.find_element_by_xpath(
    '//*[@id="prices"]/div[1]/a').get_attribute("href")
f.write(steamListing)
f.close()

# print(prices)

driver.close()
