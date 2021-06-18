Public Class RPT_InfProgramComparativosEdoEjercicioPresupuestal6Colum5NivelesProy

    Private Sub label175_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label175.BeforePrint
        If Convert.ToDouble(label175.Text.Substring(0, Len(label175.Text) - 1)) = 0.0 Then
            label175.Text = "N/A"
        End If
    End Sub

    Private Sub label179_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label179.BeforePrint
        If Convert.ToDouble(label179.Text.Substring(0, Len(label179.Text) - 1)) = 0.0 Then
            label179.Text = "N/A"
        End If
    End Sub

    Private Sub label172_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label172.BeforePrint
        label172.Text = Format(Math.Abs(Convert.ToDouble(label172.Text)), "##,##0.00")
    End Sub

    Private Sub label173_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label173.BeforePrint
        label173.Text = Format(Math.Abs(Convert.ToDouble(label173.Text)), "##,##0.00")
    End Sub

    Private Sub label176_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label176.BeforePrint
        label176.Text = Format(Math.Abs(Convert.ToDouble(label176.Text)), "##,##0.00")
    End Sub

    Private Sub label177_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label177.BeforePrint
        label177.Text = Format(Math.Abs(Convert.ToDouble(label177.Text)), "##,##0.00")
    End Sub

    Private Sub label183_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label183.SummaryCalculated
        e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,##0.00")
    End Sub

    Private Sub label182_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label182.SummaryCalculated
        e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,##0.00")
    End Sub

    Private Sub label186_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label186.SummaryCalculated
        e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,##0.00")
    End Sub

    Private Sub label187_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label187.SummaryCalculated
        e.Text = Format(Math.Abs(Convert.ToDouble(e.Text)), "##,##0.00")
    End Sub
End Class