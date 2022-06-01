Imports Microsoft.VisualBasic
Imports System
Imports System.Windows.Forms
Imports DevExpress.XtraReports.UI

Public Class RPT_Calendario_ING_EGR
    Public totalCol As Decimal
    Public totIng As Double
    Public totEgr As Double
    Public tot0 As Double
    Public tot1 As Double
    Public tot2 As Double
    Public tot3 As Double
    Public tot4 As Double
    Public tot5 As Double
    Public tot6 As Double
    Public tot7 As Double
    Public tot8 As Double
    Public tot9 As Double
    Public tot10 As Double
    Public tot11 As Double
    Public tot12 As Double
    Public tot0_Ing As Double
    Public tot1_Ing As Double
    Public tot2_Ing As Double
    Public tot3_Ing As Double
    Public tot4_Ing As Double
    Public tot5_Ing As Double
    Public tot6_Ing As Double
    Public tot7_Ing As Double
    Public tot8_Ing As Double
    Public tot9_Ing As Double
    Public tot10_Ing As Double
    Public tot11_Ing As Double
    Public tot12_Ing As Double

    Private Sub lblRptTituloTipo_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles lblRptTituloTipo.BeforePrint
        Dim dos As String


        Try
            dos = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If dos Is Nothing Then dos = ""
        End Try

        If dos = "ING" Then
            lblRptTituloTipo.Text = "FUENTE DE FINANCIAMIENTO INGRESO"
        Else
            lblRptTituloTipo.Text = "FUENTE DE FINANCIAMIENTO EGRESO"
        End If

    End Sub

    Private Sub XrLabel25_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel25.SummaryCalculated

        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "ING" Then
            totIng = Convert.ToDouble(e.Value)
        Else
            totEgr = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel24_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel24.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot11 = Convert.ToDouble(e.Value)
        Else
            tot11_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub lblDiferencia_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDiferencia.PrintOnPage
        totalCol = totIng - totEgr
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub XrLabel25_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles XrLabel25.PrintOnPage

    End Sub

    Private Sub lblAprobado_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles lblAprobado.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot0 = Convert.ToDouble(e.Value)
        Else
            tot0_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel10_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel10.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot1 = Convert.ToDouble(e.Value)
        Else
            tot1_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel9_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel9.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot2 = Convert.ToDouble(e.Value)
        Else
            tot2_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel11_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel11.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot3 = Convert.ToDouble(e.Value)
        Else
            tot3_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel14_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel14.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot4 = Convert.ToDouble(e.Value)
        Else
            tot4_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel15_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel15.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot5 = Convert.ToDouble(e.Value)
        Else
            tot5_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel18_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel18.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot6 = Convert.ToDouble(e.Value)
        Else
            tot6_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel20_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel20.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot7 = Convert.ToDouble(e.Value)
        Else
            tot7_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel21_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel21.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot8 = Convert.ToDouble(e.Value)
        Else
            tot8_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel22_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel22.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot9 = Convert.ToDouble(e.Value)
        Else
            tot9_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel23_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel23.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot10 = Convert.ToDouble(e.Value)
        Else
            tot10_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub lblDif0_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif0.PrintOnPage
        totalCol = tot0_Ing - tot0
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif1_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif1.PrintOnPage
        totalCol = tot1_Ing - tot1
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif2_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif2.PrintOnPage
        totalCol = tot2_Ing - tot2
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif3_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif3.PrintOnPage
        totalCol = tot3_Ing - tot3
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif4_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif4.PrintOnPage
        totalCol = tot4_Ing - tot4
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif5_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif5.PrintOnPage
        totalCol = tot5_Ing - tot5
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif6_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif6.PrintOnPage
        totalCol = tot6_Ing - tot6
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif7_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif7.PrintOnPage
        totalCol = tot7_Ing - tot7
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif8_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif8.PrintOnPage
        totalCol = tot8_Ing - tot8
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif9_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif9.PrintOnPage
        totalCol = tot9_Ing - tot9
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif10_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif10.PrintOnPage
        totalCol = tot10_Ing - tot10
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif11_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif11.PrintOnPage
        totalCol = tot11_Ing - tot11
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif12_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles lblDif12.PrintOnPage
        totalCol = tot12_Ing - tot12
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub lblDif12_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles lblDif12.SummaryCalculated
        
    End Sub

    Private Sub XrLabel4_SummaryCalculated(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.TextFormatEventArgs) Handles XrLabel4.SummaryCalculated
        Dim current As String = ""

        Try
            current = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If current Is Nothing Then current = ""
        End Try

        If current = "EGR" Then
            tot12 = Convert.ToDouble(e.Value)
        Else
            tot12_Ing = Convert.ToDouble(e.Value)
        End If
    End Sub

    Private Sub XrLabel31_PrintOnPage(ByVal sender As System.Object, ByVal e As DevExpress.XtraReports.UI.PrintOnPageEventArgs) Handles XrLabel31.PrintOnPage
        totalCol = totIng - totEgr
        CType(sender, XRLabel).Text = totalCol.ToString("n2")
    End Sub

    Private Sub label2_BeforePrint(ByVal sender As System.Object, ByVal e As System.Drawing.Printing.PrintEventArgs) Handles label2.BeforePrint
        Dim dos As String


        Try
            dos = GetCurrentColumnValue("Unidad").ToString
        Catch ex As Exception
        Finally
            If dos Is Nothing Then dos = ""
        End Try

        If dos = "ING" Then
            label2.Text = "Presupuesto de Ingresos Asignación Modificada"
        Else
            label2.Text = "Presupuesto de Egresos Asignación Modificada"
        End If
    End Sub
End Class