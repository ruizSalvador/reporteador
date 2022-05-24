Public Class RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado2
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


    Private Sub XrLabel13_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel13.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel13_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel13.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrLabel33_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel33.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel33_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel33.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrLabel14_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel14.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel14_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel14.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrLabel15_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel15.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel15_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel15.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrLabel16_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel16.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel16_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel16.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub

    Private Sub XrLabel19_PreviewClick(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel19.PreviewClick
        If isOpenNotes Then
            Exit Sub
        End If

        MdluserCtrl.BarButtonItem4_ItemClick(MdluserCtrl, Nothing)
    End Sub

    Private Sub XrLabel19_PreviewMouseMove(sender As System.Object, e As DevExpress.XtraReports.UI.PreviewMouseEventArgs) Handles XrLabel19.PreviewMouseMove
        MdluserCtrl.Cursor = Cursors.Hand
    End Sub
End Class