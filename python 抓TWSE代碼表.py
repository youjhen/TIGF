import requests,csv,urllib,pycountry,pandas as pd
from bs4 import BeautifulSoup
#TWSE
category=['2上市','4上櫃','5興櫃','8創櫃板證券']
for k in category:
    url='http://isin.twse.com.tw/isin/C_public.jsp?strMode='+k[:1]
    with open('D:/'+k+'.csv','w',encoding='UTF-8_sig',newline='') as f:
        f_csv=csv.writer(f)          
        res = requests.get(url, verify = False)
        soup = BeautifulSoup(res.text, 'html.parser') 
        table = soup.find('table', {'class' : 'h4'})
        head = soup.find('tr').find_all('td')
    
        for row in table.find_all('tr'):
            data = []
            for col in row.find_all('td'):
                col.attrs = {}
                data.append(col.text.strip().replace('\u3000', ''))
            
            if len(data) == 1 :
               pass
            else:
               f_csv.writerow(data)         
#終止上市     
url='http://www.tse.com.tw/company/suspendListingCsvAndHtml?type=html&selectYear=&lang=zh'        
res = requests.get(url, verify = False)
soup = BeautifulSoup(res.text, 'html.parser')        
table = soup.find('tbody')
with open('D:/終止上市.csv','w',encoding='UTF-8',newline='') as f:
    f_csv=csv.writer(f)    
    for row in table.find_all('tr'):
        data = []
        for col in row.find_all('td'):
            col.attrs = {}
            data.append(col.text.strip().replace('\u3000', ''))
        f_csv.writerow(data)
#MIC
link_mic = 'https://www.iso20022.org/sites/default/files/ISO10383_MIC/ISO10383_MIC.xls'
mic = urllib.request.urlopen(link_mic)
xls_mic = pd.ExcelFile(mic) 
df_a = xls_mic.parse(xls_mic.sheet_names[0])
df_a.to_csv('D:/MICs List by Country.csv',encoding='UTF-8_sig',index=False)
df_d = xls_mic.parse(xls_mic.sheet_names[7])
df_d.to_csv('D:/MICs List Deactivated MICs.csv',encoding='UTF-8_sig',index=False)
#country
a=[]
b=[]
for x in pycountry.countries:
    a.append(x.alpha_2)
    if x.name == 'Taiwan, Province of China': b.append('Taiwan') 
    else: b.append(x.name)
df_c = pd.DataFrame({'CountryCode':a,'CountryNameE':b})
df_c.to_csv('D:/country.csv',encoding='UTF-8_sig',index=False)
c=[]
d=[]
e=[]
for y in pycountry.historic_countries:
    c.append(y.alpha_2)
    d.append(y.name)
    e.append(y.withdrawal_date)
df_h = pd.DataFrame({'CountryCode':c,'CountryNameE':d,'DelDate':e})
df_h.to_csv('D:/historic_country.csv',encoding='UTF-8_sig',index=False)
#currency 
link_cur = 'https://www.currency-iso.org/dam/downloads/lists/list_one.xls'
xls_cur = pd.read_excel(link_cur,sheetname='Active',skiprows=[0,1,2])
xls_cur.to_csv('D:/currency.csv',encoding='UTF-8_sig',index=False)
