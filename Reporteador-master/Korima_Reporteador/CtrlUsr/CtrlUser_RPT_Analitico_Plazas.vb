﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Analitico_Plazas
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
    Dim reporte As RPT_Analitico_Plazas

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New RPT_Analitico_Plazas()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection As New SqlConnection(cnnString)
        Dim command As New SqlCommand("SP_RPT_K2_Analitico_Plazas", conection)
        command.CommandType = CommandType.StoredProcedure
        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_Analitico_Plazas")
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_Analitico_Plazas"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Analítico de Plazas' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        With reporte.XrSubreport1.ReportSource
            .DataSource = dsC
            .DataAdapter = adapterC
            .DataMember = "VW_RPT_K2_Firmas"
        End With


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))

        With reporte
            .lblRptNombreEnte.Text = "Entidad Federativa: " + pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Analítico de Plazas"
            .lblRptDescripcionFiltrado.Text = "De: " + filterPeriodoDe.Text + " a: " + filterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblTitulo.Text = ""
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= 'Analítico de Plazas'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        Mdlrpt = reporte
        MdluserCtrl = Me
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now

    End Sub

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Private Sub BarLargeButtonItem1_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarLargeButtonItem1.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota de Situación Financiera"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem2.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota de Situación Financiera"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem3_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem3.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota"
        dlg.Filter = "Archivo de Hoja de Cálculo|*.xls"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToXls(dlg.FileName)
        End If
    End Sub
End Class
