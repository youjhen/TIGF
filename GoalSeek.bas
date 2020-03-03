Attribute VB_Name = "Module1"
Sub GoalSeek()
For i = 4 To 50
    If Range("I" & i) = 0 Then '無股票部位
       Range("J" & i) = 0
    Else
       Range("H" & i).GoalSeek Goal:=0.03, ChangingCell:=Range("J" & i)
       End If
    End If
Next i
End Sub

