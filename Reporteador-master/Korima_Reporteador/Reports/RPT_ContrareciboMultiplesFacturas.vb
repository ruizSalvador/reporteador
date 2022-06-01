Public Class RPT_ContrareciboMultiplesFacturas

    Private Sub XrLabel19_SummaryGetResult(sender As System.Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel19.SummaryGetResult
        'e.Result = Convert.ToDouble(XrLabel12.Summary.GetResult()) - Convert.ToDouble(XrLabel5.Summary.GetResult())
        'e.Handled = True
    End Sub

    Private Sub XrLabel19_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles XrLabel19.BeforePrint
        ' XrLabel19.Text = (Double.Parse(TotalFac.Text) - Double.Parse(XrLabel15.Text) - Double.Parse(XrLabel17.Text)).ToString()
    End Sub
End Class