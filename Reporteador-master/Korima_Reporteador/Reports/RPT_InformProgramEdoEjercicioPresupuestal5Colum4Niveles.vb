Public Class RPT_InformProgramEdoEjercicioPresupuestal5Colum4Niveles

    Private Sub label185_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label185.BeforePrint
        If label185.Text <> "" Then
            If Convert.ToDouble(label185.Text.Substring(0, Len(label185.Text) - 1)) = 0.0 Then
                label185.Text = "N/A"
            End If
        End If
    End Sub

    Private Sub label183_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label183.BeforePrint
        If label183.Text <> "" Then
            label183.Text = Format(Math.Abs(Convert.ToDouble(label183.Text)), "##,##0.00")
        End If
    End Sub

    Private Sub label184_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label184.BeforePrint
        If label184.Text <> "" Then
            label184.Text = Format(Math.Abs(Convert.ToDouble(label184.Text)), "##,##0.00")
        End If
    End Sub

    Private Sub label189_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label189.BeforePrint
        If label189.Text <> "" Then
            If Convert.ToDouble(label189.Text.Substring(0, Len(label189.Text) - 1)) = 0.0 Then
                label189.Text = "N/A"
            End If
        End If
    End Sub

    Private Sub label186_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label186.BeforePrint
        If label186.Text <> "" Then
            label186.Text = Format(Math.Abs(Convert.ToDouble(label186.Text)), "##,##0.00")
        End If
    End Sub

    Private Sub label187_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label187.BeforePrint
        If label187.Text <> "" Then
            label187.Text = Format(Math.Abs(Convert.ToDouble(label187.Text)), "##,##0.00")
        End If
    End Sub

    Private Sub label190_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label190.SummaryCalculated
        If e.Text <> "" Then
            e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
        End If
    End Sub

    Private Sub label193_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label193.SummaryCalculated
        If e.Text <> "" Then
            e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
        End If
    End Sub

    Private Sub label197_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label197.SummaryCalculated
        If e.Text <> "" Then
            e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
        End If
    End Sub

    Private Sub label196_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label196.SummaryCalculated
        If e.Text <> "" Then
            e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
        End If
    End Sub
End Class