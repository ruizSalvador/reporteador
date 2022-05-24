Public Class RPT_Balanza_Comprobacion_Anexos

    Private Sub Detail_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles Detail.BeforePrint
        'Dim uno As String = ""
        Dim dos As String = ""


        Try
            dos = GetNextColumnValue("Negritas").ToString
        Catch ex As Exception

        Finally
            If dos Is Nothing Then dos = ""
        End Try

        If dos = "1" Then
            Me.Detail.HeightF = 37.9464455!
        Else
            Me.Detail.HeightF = 18.15478!
        End If
    End Sub
End Class