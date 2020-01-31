/****** SSMS 中 SelectTopNRows 命令的指令碼  ******/
 SELECT * FROM
 (
 SELECT [IdKey]
      ,[IsMaster]
      ,[AdjustBatch]
      ,[DataDate]
      ,[GotDate]
      ,[CorpCode]
      ,[PILI]
      ,[ItemA]
      ,[ItemB]
      ,[ItemC]
	  ,[Remaining]
  FROM [J1452].[dbo].[MT_Rpt10] AS A
  WHERE ItemC in ('45','46','47') 
  UNION　All
  SELECT  [IdKey]
      ,[IsMaster]
      ,[AdjustBatch]
      ,[DataDate]
      ,[GotDate]
      ,[CorpCode]
      ,[PILI]
      ,[ItemA]
      ,[ItemB]
      ,[ItemC]
	  ,[Remaining] 
  FROM [J1452].[dbo].[MT_Rpt10_1] AS A
  WHERE ItemC in ('32','33','34')
 ) a
INNER JOIN
	(select 
	  Corpcode
	 ,DataDate
	 ,max([GotDate]) as creat--申報日期設定
	 ,max(AdjustBatch) as creat1--版次設定
	 FROM [J1452].[dbo].[MT_Rpt10]
	 where [DataDate] =10711 -- 資料區間設定
	 group by [DataDate],Corpcode) b
on a.CorpCode = b.CorpCode and a.DataDate= b.DataDate and a.GotDate = b.creat


 SELECT A.[IsMaster]
      ,A.[AdjustBatch]
      ,A.[DataDate]
      ,A.[GotDate]
      ,A.[CorpCode]
      ,A.[PILI]
      ,[TotalCaptial]*10000 AS 資本總額
      ,[RealCaptial]*10000 AS 實收資本額
      ,[NumOfGS] AS 普通股股數
      ,[NumOfSS] AS 特別股股數
	  ,[31100] AS 普通股股本
	  ,[31200] AS 特別股股本
	  ,[31000] AS 股本
	  ,[33000] AS 保留盈餘
  FROM [J1452].[dbo].[MT_CorpDynaData] AS A ---公司動態基本資料
　LEFT JOIN 
 (
	SELECT 
       [DataDate]
      ,[GotDate]
      ,[CorpCode]
      ,[AccountsCode]
      ,[Remaining]
	FROM [J1452].[dbo].[MT_Rpt01]
) t 
PIVOT (
	-- 設定彙總欄位及方式
	MAX(Remaining) 
	-- 設定轉置欄位，並指定轉置欄位中需彙總的條件值作為新欄位
	FOR AccountsCode IN ([31100], [31200],[31000],[33000])
) B---表01
  ON A.DataDate=B.DataDate AND A.[GotDate]=B.[GotDate] AND A.[CorpCode]=B.[CorpCode]

SELECT 
 LEFT(DataDate,3)+1911 AS 年度
,RIGHT(DataDate,2) AS 月份
,PILI AS 業別
,ComName AS 公司名稱
,[資本適足比率]
,[自有資本總額]
,[風險資本總額（註）]
,[31000] AS 股本 
,[32000] AS 資本公積
,[33000] AS 保留盈餘 
,[1137] AS 資產
,[3131] AS 負債
,[3146] AS 業主權益
,CASE WHEN PILI='L' THEN [1192] ELSE [1213] END AS 本期稅後損益 FROM (
	  SELECT
      PILI 
	 ,Corpcode 
	 ,DataDate 
	 ,AccountsCode
	 ,MAX(GotDate) AS 申報日期
	 ,MAX(AdjustBatch) AS 版次
	 ,MAX(Remaining) AS 數值
	  FROM [J1452].[dbo].[MT_Rpt01]--月表01月計表
	  WHERE AccountsCode IN ('31000','32000','33000') AND substring(CorpCode,4,1)<>'U'
	  GROUP BY PILI,DataDate,Corpcode,AccountsCode
UNION ALL
	  SELECT
      PILI 
	 ,Corpcode 
	 ,DataDate 
	 ,AccountsCode
	 ,MAX(GotDate)
	 ,MAX(AdjustBatch)
	 ,MAX(Remaining)
	  FROM [J1452].[dbo].[MT_Rpt02]--月表02(負債業主權益)
	  WHERE AccountsCode IN ('1137','3131','3146') AND substring(CorpCode,4,1)<>'U'
	  	  GROUP BY PILI,DataDate,Corpcode,AccountsCode
UNION ALL
	  SELECT
      PILI 
	 ,Corpcode 
	 ,DataDate 
	 ,AccountsCode
	 ,MAX(GotDate)
	 ,MAX(AdjustBatch)
	 ,MAX(Remaining)
	  FROM [J1452].[dbo].[MT_Rpt03]--月表03綜合損益表
	  WHERE AccountsCode IN ('1192','1213') AND substring(CorpCode,4,1)<>'U'--1192為本期稅後損益(壽),1213為本期損益(產)
	  GROUP BY PILI,DataDate,Corpcode,AccountsCode
UNION ALL
	  SELECT 
	   CASE WHEN gPILI='1' THEN 'P' ELSE 'L' END AS PILI
	  ,CorpID
	  ,CAST(gYYYY-1911 AS char(3))+CAST(gMM AS char(2)) AS DataDate 
	  ,RiskItem AS AccountsCode
	  ,'' AS 申報日期
	  ,gVersion AS 版次
	  ,RisCap
	  FROM [NewEwsDb].[dbo].[R_RBCRatio] R
	  LEFT JOIN [NewEwsDb].[dbo].[C_CorpCode] C
	  ON R.gCorpcode =C.Corpcode 
	  WHERE RiskItem IN ('資本適足比率','自有資本總額','風險資本總額（註）')AND gCorpCodeSub='') T1
PIVOT
     (MAX(數值)
      FOR AccountsCode IN ([資本適足比率],[自有資本總額],[風險資本總額（註）],[31000],[32000],[33000],[1137],[3131],[3146],[1192],[1213])) T2
LEFT JOIN [NewEwsDb].[dbo].[C_CorpCode] C
ON T2.Corpcode=C.CorpID

---測試---
SELECT  CAST(LEFT(DataDate,3)+1911 AS char(4))+'/'+CAST(RIGHT(DataDate,2) AS char(2))+'/20' AS 日期
,GotDate
,'壽險' AS 業別
,R.CorpCode 
,ComName AS 公司名稱
,CASE AccountsCode 
 WHEN '3147' THEN '負債及業主權益總計'
 WHEN '3106' THEN '應付保險賠款與給付'
 WHEN '3168' THEN '保險負債'
 WHEN '3159' THEN '具金融商品性質之保險契約準備'
 WHEN '3166' THEN '外匯價格變動準備'
 WHEN '3125' THEN '存入再保責任準備金'
 WHEN '3131' THEN '負債'
 WHEN '3132' THEN '股本'
 WHEN '3136' THEN '資本公積'
 WHEN '3137' THEN '法定盈餘公積'
 WHEN '3138' THEN '特別盈餘公積'
 WHEN '3139' THEN '累積盈(虧)'
 WHEN '3140' THEN '追溯適用及追溯重編之影響數'
 WHEN '3141' THEN '本期損益'
 WHEN '3146' THEN '業主權益'
 ELSE AccountsCode
 END AS 會科名稱
,Remaining  FROM
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY L.Corpcode,DataDate,AccountsCode ORDER BY AdjustBatch DESC ) SN
FROM [J1452].[dbo].[MT_Rpt02] L--月表02(負債業主權益)
WHERE L.Corpcode NOT LIKE '%U%' AND PILI='L' AND AccountsCode IN ('3147','3106','3168','3159','3166','3125','3131','3132','3136','3137','3138','3139','3140','3141','3146')
) R
LEFT JOIN [NewEwsDb].[dbo].[C_CorpCode] C
ON R.CorpCode=C.CorpID
WHERE R.SN=1


UNION ALL

SELECT  CAST(LEFT(DataDate,3)+1911 AS char(4))+'/'+CAST(RIGHT(DataDate,2) AS char(2))+'/20' AS 日期
,GotDate
,'產險' AS 業別
,R.CorpCode 
,ComName AS 公司名稱
,CASE AccountsCode 
 WHEN '3149' THEN '負債及業主權益總計'
 WHEN '3103' THEN '應付保險賠款與給付'
 WHEN '3187' THEN '保險負債'
 WHEN '3159' THEN '具金融商品性質之保險契約準備'
 WHEN '3127' THEN '存入再保責任準備金'
 WHEN '3133' THEN '負債'
 WHEN '3134' THEN '股本'
 WHEN '3138' THEN '資本公積'
 WHEN '3139' THEN '法定盈餘公積'
 WHEN '3140' THEN '特別盈餘公積'
 WHEN '3141' THEN '累積盈(虧)'
 WHEN '3142' THEN '追溯適用及追溯重編之影響數'
 WHEN '3143' THEN '本期損益'
 WHEN '3148' THEN '業主權益'
 ELSE AccountsCode
 END AS 會科名稱
,Remaining  FROM
(
SELECT *, ROW_NUMBER() OVER (PARTITION BY L.Corpcode,DataDate,AccountsCode ORDER BY AdjustBatch DESC ) SN
FROM [J1452].[dbo].[MT_Rpt02] L--月表02(負債業主權益)
WHERE L.Corpcode NOT LIKE '%U%' AND PILI='P' AND AccountsCode IN ('3149','3103','3187','3159','3127','3133','3134','3138','3139','3140','3141','3142','3143','3148')
) R
LEFT JOIN [NewEwsDb].[dbo].[C_CorpCode] C
ON R.CorpCode=C.CorpID
WHERE R.SN=1

SELECT [DataDate]
      ,[CorpCode]
      ,[PILI]
	  ,''
	 ,MAX(GotDate) AS 申報日期
	 ,MAX(AdjustBatch) AS 版次
	 ,SUM(Remaining) AS 數值
  FROM [J1452].[dbo].[MT_Rpt10]
  WHERE ItemA='01' and ItemB <>'03' and PILI='L' and [DataDate]='10712'
  GROUP BY [DataDate],[CorpCode],[PILI],AdjustBatch
  UNION ALL
  SELECT [DataDate]
      ,[CorpCode]
      ,[PILI]
	  ,ItemB
	 ,MAX(GotDate) AS 申報日期
	 ,MAX(AdjustBatch) AS 版次
	 ,MAX(Remaining) AS 數值
  FROM [J1452].[dbo].[MT_Rpt10]
  WHERE ItemA='01' and ItemB ='03' and ItemC='33' and PILI='L' and [DataDate]='10712'
  GROUP BY [DataDate],[CorpCode],[PILI],ItemB

  SELECT  [DataDate],[CorpCode],[PILI]
      ,[AccountsCode]
	 ,MAX(GotDate) AS 申報日期
	 ,MAX(AdjustBatch) AS 版次
	 ,MAX(Remaining) AS 數值
  FROM [J1452].[dbo].[MT_Rpt03]
  WHERE (AccountsCode='1179' OR AccountsCode='1171') AND PILI='L' AND [DataDate]='10712'
  GROUP BY [DataDate],[CorpCode],[PILI],[AccountsCode]
  UNION ALL
SELECT  [DataDate],[CorpCode],[PILI]
     ,'外匯衍生性金融商品損益_含處分及評價'
     ,MAX(GotDate) AS 申報日期
	 ,MAX(AdjustBatch) AS 版次
	 ,MAX([profit]) AS 數值
  FROM [J1452].[dbo].[MT_Rpt10_3]
  WHERE PILI='L' AND [DataDate]='10712'
  GROUP BY [DataDate],[CorpCode],[PILI]

SELECT CAST(LEFT(DataDate,3)+1911 AS char(4))+'/'+CAST(RIGHT(DataDate,2) AS char(2))+'/20' AS 日期
,[GotDate]
,CASE PILI
WHEN 'P' THEN '產險' 
WHEN 'L' THEN '壽險'
END AS 業別
,R.CorpCode 
,ComName AS 公司名稱
,AC
,Remaining
FROM 
(
SELECT [DataDate],[GotDate],[CorpCode],[PILI],'兌換(損)益' AS AC,Remaining, ROW_NUMBER() OVER (PARTITION BY Corpcode,DataDate ORDER BY AdjustBatch DESC ) SN
FROM [J1452].[dbo].[MT_Rpt03]--月表03：綜合損益表
WHERE AccountsCode ='1179'
UNION ALL
SELECT [DataDate],[GotDate],[CorpCode],[PILI],'外匯價格變動準備金淨變動',Remaining, ROW_NUMBER() OVER (PARTITION BY Corpcode,DataDate ORDER BY AdjustBatch DESC ) SN
FROM [J1452].[dbo].[MT_Rpt03]--月表03：綜合損益表
WHERE AccountsCode ='1171'
UNION ALL
SELECT [DataDate],[GotDate],[CorpCode],[PILI],'外匯衍生性金融商品損益_含處分及評價',profit , ROW_NUMBER() OVER (PARTITION BY Corpcode,DataDate ORDER BY AdjustBatch DESC ) SN
FROM [J1452].[dbo].[MT_Rpt10_3]--月表10-3: 國外投資匯率避險情形表
) R
LEFT JOIN [NewEwsDb].[dbo].[C_CorpCode] C
ON R.CorpCode=C.CorpID
WHERE SN=1 AND R.Corpcode NOT LIKE '%U%' 

  SELECT [CorpCode]
      ,[PILI]
      ,[AccountsCode]
	 ,MAX(GotDate) AS 申報日期
	 ,MAX(AdjustBatch) AS 版次
	 ,MAX(Remaining) AS 數值
  FROM [J1452].[dbo].[MT_Rpt02]
  where [AccountsCode] in ('1137','1150') and PILI='L' and [DataDate]='10712'
    GROUP BY [CorpCode]
      ,[PILI]
      ,[AccountsCode]


	  SELECT [CorpCode]
      ,[PILI]
      ,[AccountsCode]
	 ,MAX(GotDate) AS 申報日期
	 ,MAX(AdjustBatch) AS 版次
	 ,MAX(Remaining) AS 數值
  FROM [J1452].[dbo].[MT_Rpt02]
  where [AccountsCode] in ('3146') and PILI='L' and [DataDate]='10712'
    GROUP BY [CorpCode]
      ,[PILI]
      ,[AccountsCode]