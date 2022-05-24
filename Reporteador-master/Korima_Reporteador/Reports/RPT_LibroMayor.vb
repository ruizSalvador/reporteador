Public Class RPT_LibroMayor
    Public a As Double
    Public b As Double
    Public TOTALA As Double
    Public TOTALB As Double

    Private Sub label18_SummaryGetResult(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles label18.SummaryGetResult
        'e.Result = Convert.ToDouble(label15.Summary.GetResult()) - Convert.ToDouble(label14.Summary.GetResult())
        e.Result = b - a
        e.Handled = True
        label18.Summary.FormatString = "{0:n2}"
        'TipoB
    End Sub
    Private Sub XrLabel3_SummaryGetResult(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel3.SummaryGetResult
        'e.Result = Convert.ToDouble(label15.Summary.GetResult()) - Convert.ToDouble(label14.Summary.GetResult())
        e.Result = a - b
        e.Handled = True
        XrLabel3.Summary.FormatString = "{0:n2}"
        'TipoA
    End Sub

    Private Sub XrLabel5_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel5.SummaryCalculated
        a = Convert.ToDouble(XrLabel5.Summary.GetResult())
    End Sub

    Private Sub XrLabel4_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel4.SummaryCalculated
        b = Convert.ToDouble(XrLabel4.Summary.GetResult())
    End Sub

    Private Sub label18_SummaryCalculated(sender As System.Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label18.SummaryCalculated
        TOTALB += Convert.ToDouble(label18.Summary.GetResult())
    End Sub

    Private Sub XrLabel3_SummaryCalculated(sender As System.Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel3.SummaryCalculated
        TOTALA += Convert.ToDouble(XrLabel3.Summary.GetResult())
    End Sub

    Private Sub XrLabel6_SummaryGetResult(sender As System.Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel6.SummaryGetResult
        e.Result = TOTALA + TOTALB
        e.Handled = True
        XrLabel6.Summary.FormatString = "{0:n2}"
    End Sub
End Class