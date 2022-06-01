Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraPrinting
Imports DevExpress.XtraPrinting.Native

Public Class RPT_AuxiliarMayorMovimientos
    Dim a As Double
    Dim b As Double
    Dim TotalGeneralA As Double
    Dim TotalGeneralB As Double
    Dim i As Integer

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

    Private Sub XrLabel8_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel8.SummaryCalculated
        a = Convert.ToDouble(XrLabel8.Summary.GetResult())
    End Sub

    Private Sub XrLabel7_SummaryCalculated(sender As Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel7.SummaryCalculated
        b = Convert.ToDouble(XrLabel7.Summary.GetResult())
    End Sub

    Private Sub XrLabel9_SummaryCalculated(sender As System.Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel9.SummaryCalculated
        TotalGeneralA += Convert.ToDouble(XrLabel9.Summary.GetResult())
    End Sub
    Private Sub label18_SummaryCalculated(sender As System.Object, e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles label18.SummaryCalculated
        TotalGeneralB += Convert.ToDouble(label18.Summary.GetResult())
    End Sub
    Private Sub XrLabel11_SummaryGetResult(sender As System.Object, e As DevExpress.XtraReports.UI.SummaryGetResultEventArgs) Handles XrLabel11.SummaryGetResult
        e.Result = TotalGeneralA + TotalGeneralB
        e.Handled = True
        XrLabel11.Summary.FormatString = "{0:n2}"
    End Sub

    Private Sub RPT_AuxiliarMayor_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles MyBase.BeforePrint

    End Sub

    Private Sub GroupHeader1_BeforePrint(sender As System.Object, e As System.Drawing.Printing.PrintEventArgs) Handles GroupHeader1.BeforePrint
        Dim uno As String
        Dim dos As String
        Dim reporte As New RPT_AuxiliarMayor
        Try
            uno = GetPreviousColumnValue("NumeroCuentaContable").ToString
            dos = GetCurrentColumnValue("NumeroCuentaContable").ToString
        Catch ex As Exception
            uno = ""
            dos = ""
        End Try

        If String.Compare(uno, dos) = False Then
            XrLabel15.Visible = False
        Else
            XrLabel15.Visible = True
        End If

        i += 1
        If i = 1 Then
            XrLabel15.Visible = True
        End If
    End Sub

    Private Sub RPT_AuxiliarMayor_AfterPrint(sender As System.Object, e As System.EventArgs) Handles MyBase.AfterPrint
        'Dim curSumValue As String = String.Empty

        'For Each page As Page In DirectCast(sender, XtraReport).Pages
        '    Dim topBrick As VisualBrick = Nothing, bottomBrick As VisualBrick = Nothing

        '    Dim iterator As New NestedBrickIterator(page.InnerBricks)

        '    While iterator.MoveNext()
        '        If TypeOf iterator.CurrentBrick Is VisualBrick Then
        '            Dim vb As VisualBrick = TryCast(iterator.CurrentBrick, VisualBrick)
        '            If vb.BrickOwner Is label13 Then
        '                topBrick = vb
        '            ElseIf vb.BrickOwner Is label13 Then
        '                bottomBrick = vb
        '            End If
        '        End If
        '    End While

        'Dim txt As String
        'label24.Text = topBrick.Text
        'If topBrick IsNot Nothing Then
        '    topBrick.Text = curSumValue
        'End If
        'If bottomBrick IsNot Nothing Then
        '    curSumValue = bottomBrick.Text
        'End If

        'If Page.Index = DirectCast(sender, XtraReport).Pages.Count - 1 Then
        '    label24.Text = topBrick.Text
        'End If
        'Next

    End Sub

    Private Sub label24_PrintOnPage(sender As System.Object, e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles label24.PrintOnPage
        'If e.PageCount > 0 Then
        '    If e.PageIndex > 0 Then
        '        Dim uno As String
        '        Dim dos As String
        '        uno = GetPreviousColumnValue("NombreCuentaContable").ToString
        '        dos = GetCurrentColumnValue("NombreCuentaContable").ToString
        '        If String.Compare(uno, dos) = False Then
        '            label24.Visible = False
        '        Else
        '            label24.Visible = True
        '        End If
        '        label24.Text = Me.label13.Text
        '    End If
        'End If
    End Sub
End Class