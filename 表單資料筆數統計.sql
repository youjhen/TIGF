USE BI
GO

declare @table table([Name] varchar(100))
declare @query VARCHAR(max)
declare @strQuery varchar(max) = '';--³Ì¤j­È (8000)
set @query='SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES';
insert into @table exec (@query)
--select * from @table (You will get all your table names)

declare @tablename varchar(100)
declare @i int=0

DECLARE curFetchData CURSOR FOR SELECT [Name] from @table WHERE [Name] NOT LIKE 'ew_00_C%' AND [Name] NOT LIKE 'ew_insure_company'
OPEN curFetchData          
    FETCH NEXT FROM curFetchData INTO @tablename
    WHILE @@Fetch_status = 0          
    BEGIN   
        IF(@i>0)        
		SET @strQuery = @strQuery + (' UNION ALL ') 
        SET @strQuery = @strQuery + ('SELECT ''' + @tableName + '''AS T,YYYY,MM,Cno,COUNT(*) AS N FROM '
		           + @tableName +' GROUP BY YYYY,MM,Cno')
        SET @i=@i+1;
    FETCH NEXT FROM curFetchData INTO @tablename
    END 
CLOSE curFetchData
DEALLOCATE curFetchData
PRINT (@strQuery)
EXEC (@strQuery)
--https://stackoverflow.com/questions/60445638/fetch-data-without-using-union-all-every-month
