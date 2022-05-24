Public Class RPT_InfProgramComparativosEdoEjercicioPresupuestal4Colum3Niveles

    Private Sub label133_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label133.BeforePrint
        If Convert.ToDouble(label133.Text.Substring(0, Len(label133.Text) - 1)) = 0.0 Then
            label133.Text = "N/A"
        End If
    End Sub

    Private Sub label134_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label134.BeforePrint
        If label134.Text <> "" Then label134.Text = Format(Math.Abs(Convert.ToDouble(label134.Text)), "##,##0.00")
    End Sub

    Private Sub label135_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label135.BeforePrint
        label135.Text = Format(Math.Abs(Convert.ToDouble(label135.Text)), "##,##0.00")
    End Sub

    Private Sub label137_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label137.BeforePrint
        If Convert.ToDouble(label137.Text.Substring(0, Len(label137.Text) - 1)) = 0.0 Then
            label137.Text = "N/A"
        End If
    End Sub

    Private Sub label138_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label138.BeforePrint
        If label138.Text <> "" Then label138.Text = Format(Math.Abs(Convert.ToDouble(label138.Text)), "##,##0.00")
    End Sub

    Private Sub label139_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label139.BeforePrint
        If label139.Text <> "" Then label139.Text = Format(Math.Abs(Convert.ToDouble(label139.Text)), "##,##0.00")
    End Sub

    Private Sub label100_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label100.SummaryCalculated
        e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
    End Sub

    Private Sub label101_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label101.SummaryCalculated
        e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
    End Sub

    Private Sub label102_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label102.SummaryCalculated
        e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
    End Sub

    Private Sub label103_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label103.SummaryCalculated
        e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,#0.00")
    End Sub
End Class