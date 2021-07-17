#!/usr/bin/env python
# coding: utf-8

# In[1]:


import requests
from lxml import etree
from io import BytesIO

r = requests.get('https://law.fsc.gov.tw/opendata/保險局.xml', verify=False)
xml_bytes = r.content
f = BytesIO(xml_bytes)
tree = etree.parse(f)
tree.findall('Law')


# In[2]:


objects = []
for obj in tree.findall('Law'):
    obj_struct = {}
    obj_struct['法規類別'] = obj.find('法規類別').text
    obj_struct['法規體系'] = obj.find('法規體系').text
    obj_struct['公發布日'] = obj.find('公發布日').text
    obj_struct['修正日期'] = obj.find('修正日期').text
    obj_struct['發文字號'] = obj.find('發文字號').text
    obj_struct['異動性質'] = obj.find('異動性質').text
    obj_struct['生效狀態'] = obj.find('生效狀態').text
    obj_struct['生效日期'] = obj.find('生效日期').text
    obj_struct['法規名稱'] = obj.find('法規名稱').text
    obj_struct['主旨'] = obj.find('主旨').text
    obj_struct['法規沿革'] = obj.find('法規沿革').text
    obj_struct['法規內容'] = obj.find('法規內容').text
    objects.append(obj_struct)
objects


# In[3]:


import pandas as pd
df = pd.DataFrame(objects)
df.to_excel("LAWS.xlsx",encoding='utf_8_sig')

