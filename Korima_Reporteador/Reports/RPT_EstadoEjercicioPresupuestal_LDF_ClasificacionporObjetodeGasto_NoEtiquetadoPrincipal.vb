Public Class RPT_EstadoEjercicioPresupuestal2Niveles_EtiquetadoPrincipal

    Private Sub label38_SummaryGetResult(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs)
        'e.Result = val1 + val2
        'e.Handled = True
    End Sub
    Dim val1 As Double = 0
    Dim val2 As Double = 0
    Private Sub label38_SummaryRowChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
        'val1 += Convert.ToDouble(Me.GetCurrentColumnValue("Autorizado"))
        'val2 += Convert.ToDouble(Me.GetCurrentColumnValue("Amp_Red"))
    End Sub
End Class