Sub NotSpaceColumns()

Dim wb As Workbook
Dim w1, ws As Worksheet
Dim AC As Integer
Dim FindCell As Range
  
    For s = 2 To 3
    
        Set wb = ThisWorkbook
        Set w1 = wb.Worksheets(1)
        Set ws = wb.Worksheets(s)
        Set FindCell = ws.Range("A:A").Find(4010009, LookIn:=xlValues) '��綠�q�N��4010009
        
        If Not FindCell Is Nothing Then
        
            n = w1.Cells(ActiveSheet.Rows.Count, "E").End(xlUp).Row + 1 '���oE�̫�@�C
            i = 3
            AC = ws.Cells(FindCell.Row, ActiveSheet.Columns.Count).End(xlToLeft).Column '���o�U��̫�@��
            
            Do While i <= AC
            
                w1.Range("H" & n) = ws.Name
                w1.Range("I" & n) = Split(ws.Columns(i).Address(, 0), ":")
                w1.Range("J" & n) = FindCell.Row '���o�Ĥ@�C
                
            i = i + 1
            n = n + 1
            Loop
            
        End If
            
    Next

End Sub
