﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient


Public Class CtrlNotas_dree_cpcporRecuperar
    Public reporte As NOTA_dree_cpcporRecuperar



    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New NOTA_dree_cpcporRecuperar()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection2 As New SqlConnection(cnnString)
        Dim prmEjercicio As New SqlParameter("ejercicio", Year(filterPeriodoAl.EditValue))
        Dim prmPeriodo As New SqlParameter("periodo", Month(filterPeriodoDe.EditValue))
        Dim prmMiles As New SqlParameter("Miles", chkMiles.Checked)
        Dim command As New SqlCommand("sp_nota_dree_cpcporRecuperar", conection2)
        command.CommandType = CommandType.StoredProcedure
        command.Parameters.Add(prmEjercicio)
        command.Parameters.Add(prmPeriodo)
        command.Parameters.Add(prmMiles)
        Dim adapter2 As New SqlDataAdapter(command)
        Dim dsB As New DataSet()
        dsB.EnforceConstraints = False
        adapter2.Fill(dsB, "sp_nota_dree_cpcporRecuperar")
        reporte.DataSource = dsB

        reporte.DataAdapter = adapter2
        reporte.DataMember = "sp_nota_dree_cpcporRecuperar"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Derecho a Recibir Efvo y Eq/Contribuciones' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblTitulo.Text = "Derechos a Recibir Efectivo o Equivalentes"
            .lblSubtitulo.Text = "Contribuciones pendientes de cobro y por recuperar"
            If chkMiles.Checked = True Then
                .XrLabel1.Text = "(En miles de pesos)"
            Else
                .XrLabel1.Text = ""
            End If
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Derecho a Recibir Efvo y Eq/Contribuciones' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        Mdlrpt = reporte
        MdluserCtrl = Me
        Dim ctrl As XRLabel
        For Each prm As Parameter In reporte.Parameters
            ctrl = reporte.FindControl("lbl_" & prm.Name, False)
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

    Private Sub BarLargeButtonItem1_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota de Situación Financiera"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota de Situación Financiera"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem3_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota Índice Desglose de Notas"
        dlg.Filter = "Archivo de Hoja de Cálculo|*.xls"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToXls(dlg.FileName)
        End If
    End Sub

    Public Sub BarButtonItem4_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim ds As DataSet = DirectCast(reporte.DataSource, DataSet)
        Dim notas As New List(Of String)()
        notas.Add("Nota1")
        '  notas.Add("Nota2")

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

        Dim frm As New Frm_Edit_NoteTable("Cuenta", notas, ds, excepciones)
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim i As Integer = 0
            For Each dr As DataRow In frm.dsNotas.Tables(0).Rows
                For j As Integer = i To ds.Tables(0).Rows.Count
                    If ds.Tables(0).Rows(j)("Cuenta") = dr("Cuenta") Then
                        ds.Tables(0).Rows(j)("Nota1") = dr("Nota1")
                        'ds.Tables(0).Rows(j)("Nota2") = dr("Nota2")
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
