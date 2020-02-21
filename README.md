--資料庫裏的所有欄位
SELECT * FROM Information_Schema.COLUMNS

--目前資料庫中的索引鍵。
SELECT * FROM Information_Schema.KEY_COLUMN_USAGE

--目前使用者在目前資料庫中可以存取的資料表
SELECT * FROM Information_Schema.TABLES

--目前資料庫中的資料表條件約束(UNIQUE、CHECK：X >= Y1 AND X <= Y2)
SELECT * FROM Information_Schema.TABLE_CONSTRAINTS

--目前資料庫中的外部條件約束
SELECT * FROM Information_Schema.REFERENTIAL_CONSTRAINTS

--修改約束條件
ALTER TABLE 資料表名稱 [WITH CHECK｜WITH NOCHECK]
ADD CONSTRAINT CHECK(X >= Y1)
DROP CONSTRAINT 約束條件
