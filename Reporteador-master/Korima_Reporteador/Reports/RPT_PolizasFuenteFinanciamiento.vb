Public Class RPT_PolizasFuenteFinanciamiento
    Dim i As Integer
    'Dim index As Integer
    Private Sub RPT_PolizasFuenteFinanciamiento_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles MyBase.BeforePrint
       
    End Sub

    Private Sub label36_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles label36.BeforePrint
        Dim anterior As String
        Dim actual As String
        Dim noEvento As String
        'Dim reporte As New RPT_AuxiliarMayor
        Try
            anterior = GetPreviousColumnValue("NoPoliza").ToString
            actual = GetCurrentColumnValue("NoPoliza").ToString
        Catch ex As Exception
            anterior = ""
            actual = ""
        End Try

        i += 1
        If i = 1 Then
            label36.Text = 1
        End If
        If String.Compare(anterior, actual) = False Then
            label36.Text = label36.Text
        Else
            noEvento = label36.Text
            Dim nuevo As Int32 = Convert.ToInt32(noEvento) + 1
            label36.Text = nuevo.ToString()
        End If

        'i += 1
        'If i = 1 Then
        '    label36.Text = 1
        'End If
    End Sub
End Class