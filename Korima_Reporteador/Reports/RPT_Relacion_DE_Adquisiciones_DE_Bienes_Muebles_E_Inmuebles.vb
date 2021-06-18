Public Class RPT__Relacion_DE_Adquisiciones_DE_Bienes_Muebles_E_Inmuebles
    'Dim Estimado As Double
    'Dim Modificado As Double
    'Dim Devengado As Double
    'Dim Recaudado As Double

    ''28 porc modificado
    'Private Sub XrLabel28_SummaryGetResult(sender As Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel28.SummaryGetResult
    '    If Modificado <> 0 Then
    '        e.Result = (Modificado / Estimado)
    '        'XrLabel28.Text = (Modificado / Estimado).ToString
    '        e.Handled = True
    '        XrLabel28.Summary.FormatString = "{0:0.00%}"
    '    Else
    '        e.Result = 0
    '        e.Handled = True
    '        XrLabel28.Summary.FormatString = "{0:0.00%}"
    '    End If
    'End Sub

    ''29 porc devengado
    'Private Sub XrLabel29_SummaryGetResult(sender As Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel29.SummaryGetResult
    '    If Devengado <> 0 Then
    '        e.Result = (Devengado / Estimado)
    '        e.Handled = True
    '        XrLabel29.Summary.FormatString = "{0:0.00%}"
    '    Else
    '        e.Result = 0
    '        e.Handled = True
    '        XrLabel29.Summary.FormatString = "{0:0.00%}"
    '    End If
    'End Sub

    ''30 porc recaudado
    'Private Sub XrLabel30_SummaryGetResult(sender As Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel30.SummaryGetResult
    '    If Recaudado <> 0 Then
    '        e.Result = (Recaudado / Estimado)
    '        e.Handled = True
    '        XrLabel30.Summary.FormatString = "{0:0.00%}"
    '    Else
    '        e.Result = 0
    '        e.Handled = True
    '        XrLabel30.Summary.FormatString = "{0:0.00%}"
    '    End If
    'End Sub

    ''22 estimado
    'Private Sub XrLabel22_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel22.SummaryCalculated
    '    Estimado = Convert.ToDouble(XrLabel22.Summary.GetResult())
    'End Sub

    ''23 modificado
    'Private Sub XrLabel23_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel23.SummaryCalculated
    '    Modificado = Convert.ToDouble(XrLabel23.Summary.GetResult())
    'End Sub

    ''24 Devengado
    'Private Sub XrLabel24_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel24.SummaryCalculated
    '    Devengado = Convert.ToDouble(XrLabel24.Summary.GetResult())
    'End Sub

    ''25 Recaudado
    'Private Sub XrLabel25_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel25.SummaryCalculated
    '    Recaudado = Convert.ToDouble(XrLabel25.Summary.GetResult())
    'End Sub




End Class