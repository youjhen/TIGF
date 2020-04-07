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
    
    
Sub 改顏色()

arr = Array(7, 8, 15, 20, 24, 28, 30, 31, 32, 33, 36, 37, 39, 40, 41, 44, 45)

For i = 0 To UBound(arr)

    Cells(arr(i), 27).Select
    ActiveCell.FormulaR1C1 = "空白"
    
    Range(Cells(arr(i), 3), Cells(arr(i), 26)).Select
    With Selection.Interior
        .PatternColorIndex = xlAutomatic
        .Color = 65535
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    
Next

For j = 5 To 26 Step 2
    
    Cells(46, j).Select
    ActiveCell.FormulaR1C1 = "內建公式"

    Range(Cells(6, j), Cells(45, j)).Select
    With Selection.Interior
        .Pattern = xlSolid
        .PatternColorIndex = xlAutomatic
        .Color = 65535
        .TintAndShade = 0
        .PatternTintAndShade = 0
    End With
    
Next

End Sub

End Sub
