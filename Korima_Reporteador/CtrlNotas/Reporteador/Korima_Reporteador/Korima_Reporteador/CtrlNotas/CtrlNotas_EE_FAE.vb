﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlNotas_EE_FAE
    Public reporte As NOTA_EE_FAE

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New NOTA_EE_FAE()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection As New SqlConnection(cnnString)
        Dim prmEjercicio As New SqlParameter("ejercicio", Year(filterPeriodoAl.EditValue))
        Dim prmPeriodo As New SqlParameter("periodo", Month(filterPeriodoDe.EditValue))
        Dim command As New SqlCommand("sp_nota_ee_fae", conection)
        command.CommandType = CommandType.StoredProcedure
        command.Parameters.Add(prmEjercicio)
        command.Parameters.Add(prmPeriodo)
        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "sp_nota_ee_fae")
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "sp_nota_ee_fae"
        
        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Fondos con Afectación Específica' Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Notas al Estado de Situación Financiera"
            .lblRptDescripcionFiltrado.Text = "Al " & lastDay.AddMonths(1).AddDays(-1)
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .lblTitulo.Text = "Efectivo y Equivalentes"
            .lblSubtitulo.Text = "Fondos con Afectación Específica"
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        Mdlrpt = reporte
        MdluserCtrl = Me

        For Each prm As Parameter In reporte.Parameters
            Dim ctrl As XRLabel = reporte.FindControl("lbl_" & prm.Name, False)
            AddHandler ctrl.PreviewClick, AddressOf CapturaNota
            AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
            ctrl.Tag = prm
        Next
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
