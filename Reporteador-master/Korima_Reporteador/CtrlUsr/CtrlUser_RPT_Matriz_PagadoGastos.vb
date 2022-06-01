﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Matriz_PagadoGastos
    Dim TipoReporte
    Public notas1 As New Dictionary(Of String, String)
    Public notas2 As New Dictionary(Of String, String)
    Public notas3 As New Dictionary(Of String, String)

    Public reporte As RPT_MatrizPagadoGastos
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
        Dim reporte As New RPT_MatrizPagadoGastos
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        'ErrorProvider1.Clear()

        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_MatrizPagadoGastos", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.CommandTimeout = 9999999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_MatrizPagadoGastos")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_MatrizPagadoGastos"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "A2 Matriz pagado de gasto"
            .lblTitulo.Text = ""
            '.lblRptDescripcionFiltrado.Text = "Facturas del " + filterPeriodoDe.Text + " al " + FilterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario


            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Matriz Pagado Gasto' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
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
        dlg.Title = "Exporta Proyecciones de Egresos"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Proyecciones de Egresos"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem3_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Proyecciones de Egresos"
        dlg.Filter = "Archivo de Hoja de Cálculo|*.xls"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToXls(dlg.FileName)
        End If
    End Sub



    Public Sub BarButtonItem4_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs)
        Dim ds As DataSet = DirectCast(reporte.DataSource, DataSet)
        Dim notas As New List(Of String)()
        notas.Add("AñoCuestion")
        notas.Add("Año1")
        notas.Add("Año2")
        notas.Add("Año3")
        notas.Add("Año4")
        notas.Add("Año5")

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
        frm.Text = "Proyecciones de Egresos"
        If frm.ShowDialog(MdluserCtrl) = DialogResult.OK Then
            Dim i As Integer = 0
            For Each dr As DataRow In frm.dsNotas.Tables(0).Rows
                For j As Integer = i To ds.Tables(0).Rows.Count
                    If ds.Tables(0).Rows(j)("Concepto") = dr("Concepto") Then
                        ds.Tables(0).Rows(j)("AñoCuestion") = dr("AñoCuestion")
                        ds.Tables(0).Rows(j)("Año1") = dr("Año1")
                        ds.Tables(0).Rows(j)("Año2") = dr("Año2")
                        ds.Tables(0).Rows(j)("Año3") = dr("Año3")
                        ds.Tables(0).Rows(j)("Año4") = dr("Año4")
                        ds.Tables(0).Rows(j)("Año5") = dr("Año5")
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
