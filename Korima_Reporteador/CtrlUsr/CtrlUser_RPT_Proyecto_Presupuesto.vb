Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Proyecto_Presupuesto
    'Dim strFirmas
    'Dim strTitulo
    'Public strReporte
    Public notas1 As New Dictionary(Of String, String)
    Public notas2 As New Dictionary(Of String, String)
    Public notas3 As New Dictionary(Of String, String)

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

    Dim reporte As RPT_Proyecto_Presupuesto

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New RPT_Proyecto_Presupuesto()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection As New SqlConnection(cnnString)
        Dim prmEjercicio As New SqlParameter("Columnas", 18)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        reporte.DataSource = ds

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Proyecto del Presupuesto de Egresos' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        With reporte.XrSubreport1.ReportSource
            .DataSource = dsC
            .DataAdapter = adapterC
            .DataMember = "VW_RPT_K2_Firmas2"
        End With

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        ' Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))

        With reporte
            .lblRptEntidadFederativa.Text = pRPTCFGDatosEntes.Nombre
            .XrLabel1.Text = pRPTCFGDatosEntes.Nombre
            .XrLabel153.Text = pRPTCFGDatosEntes.Nombre
            .XrLabel194.Text = pRPTCFGDatosEntes.Nombre
            .XrLabel208.Text = pRPTCFGDatosEntes.Nombre
            .XrLabelXX.Text = pRPTCFGDatosEntes.Nombre
            .XrLabel241.Text = pRPTCFGDatosEntes.Nombre
            .XrLabel244.Text = pRPTCFGDatosEntes.Nombre
            .XrLabel254.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Información Adicional del Proyecto del Presupuesto de Egresos Armonizado"
            .lblRptDescripcionFiltrado.Text = "Del Ejercicio Fiscal " + TimeEdit1.Text
            .XrLabel2.Text = "Presupuesto de Egresos para el Ejercicio Fiscal " + TimeEdit1.Text
            .XrLabel169.Text = "Presupuesto de Egresos para el Ejercicio Fiscal " + TimeEdit1.Text
            .XrLabel193.Text = "Presupuesto de Egresos para el Ejercicio Fiscal " + TimeEdit1.Text
            .XrLabel207.Text = "Presupuesto de Egresos para el Ejercicio Fiscal " + TimeEdit1.Text
            .XrLabel217.Text = "Presupuesto de Egresos para el Ejercicio Fiscal " + TimeEdit1.Text
            .XrLabel240.Text = "Presupuesto de Egresos para el Ejercicio Fiscal " + TimeEdit1.Text
            .XrLabel245.Text = "Presupuesto de Egresos para el Ejercicio Fiscal " + TimeEdit1.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblTitulo.Text = ""
            '.lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= 'Proyecto del Presupuesto de Egresos'", New SqlConnection(cnnString))
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
        'ctrl = reporte.FindControl("lbl_Nota3", False)
        'AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        '  filterPeriodoDe.EditValue = Now
        '  filterPeriodoAl.EditValue = Now

    End Sub

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Private Sub BarLargeButtonItem1_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarLargeButtonItem1.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota de Situación Financiera"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem2.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota de Situación Financiera"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem3_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem3.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Nota"
        dlg.Filter = "Archivo de Hoja de Cálculo|*.xls"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToXls(dlg.FileName)
        End If
    End Sub

    Private Sub TimeEdit1_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        TimeEdit1.EditValue = Now
    End Sub
End Class
