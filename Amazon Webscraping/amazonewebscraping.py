from bs4 import BeautifulSoup
import pandas
import requests
import time
import datetime
import smtplib

url = 'https://www.amazon.com/Funny-Data-Systems-Business-Analyst/dp/B07FNW9FGJ/ref=sr_1_3?dchild=1&keywords=data%2Banalyst%2Btshirt&qid=1626655184&sr=8-3&customId=B0752XJYNL&th=1%27%5Cn'
headers = {"User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/78.0.3904.108 Safari/537.36", "Accept-Encoding":"gzip, deflate", "Accept":"text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "DNT":"1","Connection":"close", "Upgrade-Insecure-Requests":"1"}

page = requests.get(url, headers=headers)

soup1 = BeautifulSoup(page.content, 'html.parser')

soup2 = BeautifulSoup(soup1.prettify(), 'html.parser')

title = soup2.find(id = 'productTitle').get_text()

price = soup2.find('span', {'class':  'a-price-whole'}, ).get_text()

title = title.strip('\n ')
price = price.strip('\n .')


print(title)
print(price)

import csv
header = ['Title', 'Price']
data = [title, price]

with open('/Users/mac/Documents/Python Project/AmazonWebScraperDataset.csv', 'w', newline='', encoding= 'UTF8') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerow(data)