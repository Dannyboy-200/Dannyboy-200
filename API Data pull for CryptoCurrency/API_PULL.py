from requests import Request, Session
from requests.exceptions import ConnectionError, Timeout, TooManyRedirects
import json

url = 'https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
parameters = {
  'start':'1',
  'limit':'15',
  'convert':'USD'
}
headers = {
  'Accepts': 'application/json',
  'X-CMC_PRO_API_KEY': 'f9213aa5-3116-4f06-82eb-83753d21ef20',
}

session = Session()
session.headers.update(headers)

try:
  response = session.get(url, params=parameters)
  data = json.loads(response.text)
  print(data)
except (ConnectionError, Timeout, TooManyRedirects) as e:
  print(e)

import pandas as pd
pd.set_option('display.max_columns', None)
pd.set_option('display.max_rows', None)
df = pd.json_normalize(data['data'])
df['timestamp'] = pd.to_datetime('now')
df



def api_runner():
    global df

    url = 'https://sandbox-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
    parameters = {
        'start':'1',
        'limit':'15',
        'convert':'USD'
    }
    headers = {
        'Accepts': 'application/json',
        'X-CMC_PRO_API_KEY': 'f9213aa5-3116-4f06-82eb-83753d21ef20',
    }

    session = Session()
    session.headers.update(headers)

    try:
        response = session.get(url, params=parameters)
        data = json.loads(response.text)
        print(data)
    except (ConnectionError, Timeout, TooManyRedirects) as e:
        print(e)
    
    df2 = pd.json_normalize(data['data'])
    df2['timestamp'] = pd.to_datetime('now')
    df = df._append(df2)

    if not os.path.isfile(r'/Users/mac/Documents/Python Project/API.csv'):
       df.to_csv(r'/Users/mac/Documents/Python Project/API.csv', header = 'column_names')
    else:
       df.to_csv(r'/Users/mac/Documents/Python Project/API.csv', mode= 'a', header = False)


import os
import sys
from time import time
from time import sleep

for i in range(333):
   api_runner()
   print('API Runner Complete Successfully')
   sleep(60)
   break


pd.set_option('display.float_format', lambda x: '%.5f' % x)
df

df3= df.groupby('name', sort = False)[['quote.USD.percent_change_1h','quote.USD.percent_change_24h','quote.USD.percent_change_7d']].mean()
df3


df4 = df3.stack()
df4

type(df4)

df5 = df4.to_frame(name='values')
df5


index = pd.Index(range(90))

df6 = df5.set_index(index)
df6

df7 = df6.rename(columns={'level_1': 'percent_change'})
df7


df7['percent_change'] = df7['percent_change'].replace(['quote.USD.percent_change_24h','quote.USD.percent_change_7d','quote.USD.percent_change_30d','quote.USD.percent_change_60d','quote.USD.percent_change_90d'],['24h','7d','30d','60d','90d'])
df7


import seaborn as sns
import matplotlib.pyplot as plt


# Unfortunatly the API change the names of crypto currency, it will be difficult to pin point the actual crypto for case study
