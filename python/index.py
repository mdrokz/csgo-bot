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

f = open("./url.txt", "r")
url = f.read()
f.close()


# driver = webdriver.Chrome(
#     options=options, executable_path='./chromedriver_win32/chromedriver.exe')
driver = webdriver.Firefox(options=options)
driver.get(url)
os.remove('./url.txt')

# get Price Table
priceDataTable = driver.find_element_by_class_name("price-details-table").text
pricesTableRows = priceDataTable.splitlines()

f = open("./scrapedData.txt", "a", encoding='utf-8', errors='ignore')


for i in range(len(pricesTableRows)):
    if(i == 0):
        continue
    currentRow = pricesTableRows[i]
    currentRowData = currentRow.split(" ")
    if(i < 3):
        skin = currentRowData[0]+" "+currentRowData[1]+currentRowData[2]
        steamPrice = currentRowData[3]
        f.write(skin+":"+steamPrice+"\n")
    elif(i < 8):
        skin = currentRowData[0]+" "+currentRowData[1]
        steamPrice = currentRowData[2]
        f.write(skin+":"+steamPrice+"\n")

    else:
        skin = currentRowData[0]
        steamPrice = currentRowData[1]
        f.write(skin+":"+steamPrice+"\n")

    # print(currentRowData)

# Get steam listings
steamListing = driver.find_element_by_xpath(
    '//*[@id="prices"]/div[1]/a').get_attribute("href")
f.write(steamListing + "\n")
# print(steamListing)

f.close()


# print(prices)

driver.close()
