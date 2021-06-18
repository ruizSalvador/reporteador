Public Class RPT_InformProgramEdoEjercicioPresupuestal4Colum3NivelesProy

    Private Sub label125_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label125.BeforePrint
        If label125.Text <> "" Then
            If Convert.ToDouble(label125.Text.Substring(0, Len(label125.Text) - 1)) = 0.0 Then
                label125.Text = "N/A"
            End If
        End If
    End Sub

    Private Sub label122_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label122.BeforePrint
        If label122.Text <> "" Then
            label122.Text = Format(Math.Abs(Convert.ToDouble(label122.Text)), "##,##0.00")
        End If
    End Sub

    Private Sub label123_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label123.BeforePrint
        If label123.Text <> "" Then
            label123.Text = Format(Math.Abs(Convert.ToDouble(label123.Text)), "##,##0.00")
        End If
    End Sub

    Private Sub label129_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label129.BeforePrint
        If label129.Text <> "" Then
            If Convert.ToDouble(label129.Text.Substring(0, Len(label129.Text) - 1)) = 0.0 Then
                label129.Text = "N/A"
            End If
        End If
    End Sub

    Private Sub label126_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label126.BeforePrint
        If label126.Text <> "" Then
            label126.Text = Format(Math.Abs(Convert.ToDouble(label126.Text)), "##,##0.00")
        End If
    End Sub

    Private Sub label127_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label127.BeforePrint
        If label127.Text <> "" Then
            label127.Text = Format(Math.Abs(Convert.ToDouble(label127.Text)), "##,##0.00")
        End If
    End Sub

    Private Sub label131_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label131.SummaryCalculated
        If e.Text <> "" Then
            e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
        End If
    End Sub

    Private Sub label130_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label130.SummaryCalculated
        If e.Text <> "" Then
            e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
        End If
    End Sub

    Private Sub label141_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label141.SummaryCalculated
        If e.Text <> "" Then
            e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
        End If
    End Sub

    Private Sub label140_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label140.SummaryCalculated
        If e.Text <> "" Then
            e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
        End If
    End Sub
End Class