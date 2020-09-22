import pyodbc
import pandas as pd
# Some other example server values are
# server = 'localhost\sqlexpress' # for a named instance
# server = 'myserver,port' # to specify an alternate port
server = '111.111.111.111' 
database = 'II' 
username = '000' 
password = '000'
date='YYYYMM'
cnxn = pyodbc.connect('DRIVER={SQL Server};SERVER='+server+';DATABASE='+database+';UID='+username+';PWD='+ password)
cursor = cnxn.cursor()
cursor.execute("SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME NOT LIKE 'ew_00_%'AND TABLE_NAME<>'ew_insure_company'")
tablename = cursor.fetchall()

#產出excel檔      
with pd.ExcelWriter('output.xlsx') as writer:
    Result_PATH = 'D:\\'+date+'.xlsx'
    writer = pd.ExcelWriter(Result_PATH , engine='xlsxwriter')
    i=0   
    for i in range(len(tablename)):
        tbs=sorted(tablename)
        for tb in tbs[i]:
            query = "SELECT * FROM "+tb+" WHERE YYYY+MM=" +date
            df = pd.read_sql(query,cnxn)
            if df.empty == True:
               print(tb+' is empty')
            else:
               df.to_excel(writer,sheet_name=tb[6:10],index = False)
               print(tb+'成功產出')
writer.save()
writer.close()
#InvalidWorksheetName: Excel worksheet name 'ew_01_AR03_NonRatingREATFASCapital' must be <= 31 chars.