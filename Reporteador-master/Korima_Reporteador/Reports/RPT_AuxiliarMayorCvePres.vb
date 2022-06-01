Public Class RPT_AuxiliarMayorCvePres
    Dim a As Double
    Dim b As Double
    Dim acumulado As Double
    Dim resultado As Double

    Private Sub label18_SummaryGetResult(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles label18.SummaryGetResult
        'e.Result = Convert.ToDouble(label15.Summary.GetResult()) - Convert.ToDouble(label14.Summary.GetResult())
        e.Result = b - a
        e.Handled = True
        label18.Summary.FormatString = "{0:n2}"
    End Sub
    Private Sub XrLabel9_SummaryGetResult(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel9.SummaryGetResult
        'e.Result = Convert.ToDouble(label15.Summary.GetResult()) - Convert.ToDouble(label14.Summary.GetResult())
        e.Result = a - b
        e.Handled = True
        XrLabel9.Summary.FormatString = "{0:n2}"
    End Sub

    Private Sub XrLabel8_SummaryCalculated(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel8.SummaryCalculated
        a = Convert.ToDouble(XrLabel8.Summary.GetResult())
    End Sub

    Private Sub XrLabel7_SummaryCalculated(ByVal sender As Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel7.SummaryCalculated
        b = Convert.ToDouble(XrLabel7.Summary.GetResult())
    End Sub
End Class