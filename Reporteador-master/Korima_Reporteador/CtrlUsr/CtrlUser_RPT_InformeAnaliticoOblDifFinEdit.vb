﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_InformeAnaliticoOblDifFinEdit
    Dim TipoReporte
    Public notas1 As New Dictionary(Of String, String)
    Public notas2 As New Dictionary(Of String, String)
    Public notas3 As New Dictionary(Of String, String)

    Public reporte As RPT_InformeAnaliticoOblDifFinEdit
    Private Function MesLetra(ByVal Mes As Integer) As String
        Select Case Mes
            Case 1
                Return "Enero"
            Case 2
                Return "Febrero"
            Case 3
                Return "Marzo"
            Case 4
                Return "Abril"
            Case 5
                Return "Mayo"
            Case 6
                Return "Junio"
            Case 7
                Return "Julio"
            Case 8
                Return "Agosto"
            Case 9
                Return "Septiembre"
            Case 10
                Return "Octubre"
            Case 11
                Return "Noviembre"
            Case 12
                Return "Diciembre"
            Case Else
                Return ""
        End Select
    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New RPT_InformeAnaliticoOblDifFinEdit()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection As New SqlConnection(cnnString)
        Dim prmPeriodo As New SqlParameter("Mes1", Month(filterPeriodoDe.EditValue))
        Dim prmPeriodo2 As New SqlParameter("Mes2", Month(filterPeriodoDe2.EditValue))
        Dim prmEjercicio As New SqlParameter("Ejercicio", Year(filterPeriodoAl.EditValue))
        Dim command As New SqlCommand("SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos", conection)
        command.CommandType = CommandType.StoredProcedure
        command.Parameters.Add(prmEjercicio)
        command.Parameters.Add(prmPeriodo)
        command.Parameters.Add(prmPeriodo2)
        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos")
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_InformeAnaliticoObligacionesDifFinanciamientos"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = '" & "LDF Informe Analitico de Obligaciones Diferentes de Financiamientos" & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne

        Dim primero As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe.Time.Month, 1)
        Dim ultimo As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoDe2.Time.Month, 1)
        primero = primero.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Informe Analítico de Obligaciones Diferentes de Financiamientos"
            .lblRptDescripcionFiltrado.Text = "Del 1 de " + MesLetra(primero.Month) + " al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .XrLabel16.Text = "Monto pagado de la inversión al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString + "(k)"
            .XrLabel17.Text = "Monto pagado de la inversión actualizado al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString + "(l)"
            .XrLabel18.Text = "Saldo pendiente por pagar de la inversión al " + ultimo.Day.ToString + " de " + MesLetra(ultimo.Month) + " de " + ultimo.Year.ToString + "  (m = g-l)"
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            If chkMiles.Checked = True Then
                .XrLabel1.Text = "(En miles de pesos)"
            Else
                .XrLabel1.Text = ""
            End If
            .lblTitulo.Text = ""
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='LDF Informe Analitico de Obligaciones Diferentes de Financiamientos' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        Mdlrpt = reporte
        MdluserCtrl = Me
        'Dim ctrl As XRLabel
        'For Each prm As Parameter In reporte.Parameters
        '    ctrl = reporte.FindControl("lbl_" & prm.Name, False)
        '    AddHandler ctrl.PreviewClick, AddressOf CapturaNota
        '    AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        '    ctrl.Tag = prm
        'Next
        'ctrl = reporte.FindControl("lbl_prmTipo", False)
        'AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        'ctrl = reporte.FindControl("lbl_prmNaturaleza", False)
        'AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        'ctrl = reporte.FindControl("lbl_XrLabel18", False)
        'AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.EditValue = Now
        filterPeriodoDe2.EditValue = Now
        filterPeriodoAl.EditValue = Now

    End Sub

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Private Sub BarLargeButtonItem1_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Informe Analítico de Obligaciones Diferentes de Financiamientos"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Informe Analítico de Obligaciones Diferentes de Financiamientos"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem3_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Informe Analítico de Obligaciones Diferentes de Financiamientos"
        dlg.Filter = "Archivo de Hoja de Cálculo|*.xls"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToXls(dlg.FileName)
        End If
    End Sub



    Public Sub BarButtonItem4_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim ds As DataSet = DirectCast(reporte.DataSource, DataSet)
        Dim notas As New List(Of String)()
        notas.Add("FechaContrato")
        notas.Add("FechaInicio")
        notas.Add("FechaVencimiento")
        notas.Add("MontoInversion")
        notas.Add("PlazoPactado")
        notas.Add("MontoPromedio")
        notas.Add("MontoPromedio2")
        notas.Add("MontoPagado")
        notas.Add("MontoPagado2")
        notas.Add("SaldoPendiente")

        Dim excepciones As New List(Of String)()
        'excepciones.Add("12300")
        'excepciones.Add("12340")
        'excepciones.Add("12350")
        'excepciones.Add("12360")
        'excepciones.Add("12390")
        'excepciones.Add("12400")
        'excepciones.Add("12410")
        'excepciones.Add("12420")
        'excepciones.Add("12430")
        'excepciones.Add("12440")
        'excepciones.Add("12450")
        'excepciones.Add("12460")
        'excepciones.Add("12470")
        'excepciones.Add("12480")

        Dim frm As New Frm_Edit_NoteTable("Concepto", notas, ds, excepciones)
        frm.Text = "Informe Analítico de Obligaciones Diferentes de Financiamientos"
        frm.Width = 1200
        frm.Height = 400
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim i As Integer = 0
            For Each dr As DataRow In frm.dsNotas.Tables(0).Rows
                For j As Integer = i To ds.Tables(0).Rows.Count
                    If ds.Tables(0).Rows(j)("Concepto") = dr("Concepto") Then
                        ds.Tables(0).Rows(j)("FechaContrato") = dr("FechaContrato")
                        ds.Tables(0).Rows(j)("FechaInicio") = dr("FechaInicio")
                        ds.Tables(0).Rows(j)("FechaVencimiento") = dr("FechaVencimiento")
                        ds.Tables(0).Rows(j)("MontoInversion") = dr("MontoInversion")
                        ds.Tables(0).Rows(j)("PlazoPactado") = dr("PlazoPactado")
                        ds.Tables(0).Rows(j)("MontoPromedio") = dr("MontoPromedio")
                        ds.Tables(0).Rows(j)("MontoPromedio2") = dr("MontoPromedio2")
                        ds.Tables(0).Rows(j)("MontoPagado") = dr("MontoPagado")
                        ds.Tables(0).Rows(j)("MontoPagado2") = dr("MontoPagado2")
                        ds.Tables(0).Rows(j)("SaldoPendiente") = dr("SaldoPendiente")
                        i += 1
                        Exit For
                    End If
                    i += 1
                Next
            Next
            reporte.CreateDocument()
        End If
    End Sub
End Class
