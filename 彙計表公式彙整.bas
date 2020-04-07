Sub NotSpaceColumns()

Dim wb As Workbook
Dim w1, ws As Worksheet
Dim AC As Integer
Dim FindCell As Range
  
    For s = 2 To Worksheets.Count
    
        Set wb = ThisWorkbook
        Set w1 = wb.Worksheets(1)
        Set ws = wb.Worksheets(s)
        Set FindCell = ws.Range("A:A").Find(4010009, LookIn:=xlValues) '比對公司代號4010009
        
        If Not FindCell Is Nothing Then
        
            n = w1.Cells(ActiveSheet.Rows.Count, "A").End(xlUp).Row + 1 '取得A最後一列
            i = 3
            AC = ws.Cells(FindCell.Row, ActiveSheet.Columns.Count).End(xlToLeft).Column '取得各表最後一欄
            
            Do While i <= AC
            
                w1.Range("A" & n) = ws.Name
                w1.Range("B" & n) = Split(ws.Columns(i).Address(, 0), ":")
                w1.Range("C" & n) = FindCell.Row '取得第一列
                w1.Range("D" & n).Select
                   ActiveCell.FormulaR1C1 = "=INDIRECT(""'""&RC[-3]&""'!""&RC[-2]&RC[-1]-1)"
                w1.Range("E" & n).Select
                   ActiveCell.FormulaR1C1 = "=INDIRECT(""'""&RC[-4]&""'!""&RC[-3]&RC[-2])"
                   
            i = i + 1
            n = n + 1
            Loop
            
        End If
            
    Next

End Sub
