Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlNotas_ESF_FEDGFR
    Dim TipoReporte
    Public notas1 As New Dictionary(Of String, String)
    Public notas2 As New Dictionary(Of String, String)
    Public notas3 As New Dictionary(Of String, String)
    Public notas4 As New Dictionary(Of String, String)
    Public notas5 As New Dictionary(Of String, String)

    Public reporte As NOTA_FEDGFR

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New NOTA_FEDGFR()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection As New SqlConnection(cnnString)
        Dim command As New SqlCommand("SP_NOTA_FEDGFR", conection)
        command.CommandType = CommandType.StoredProcedure
        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_NOTA_FEDGFR")
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_NOTA_FEDGFR"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))
        Dim tri As String = ""
        If CheckBox1.Checked Then
            tri = "Anual"
        Else
            If RadioButton1.Checked Then tri = RadioButton1.Text
            If RadioButton2.Checked Then tri = RadioButton2.Text
            If RadioButton3.Checked Then tri = RadioButton3.Text
            If RadioButton4.Checked Then tri = RadioButton4.Text
        End If
        
        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Formato del ejercicio y destino de gasto federalizado y reintegros' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') order by orden", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.Firmas.ReportSource.DataSource = dsC
        reporte.Firmas.ReportSource.DataAdapter = adapterC
        reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Formato del ejercicio y destino de gasto federalizado y reintegros"
            .lblRptDescripcionFiltrado.Text = tri + " Ejercicio " + filterPeriodoAl.Time.Year.ToString()
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblTitulo.Text = ""
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Formato del ejercicio y destino de gasto federalizado y reintegros' ", New SqlConnection(cnnString))
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
        'For Each prm As Parameter In reporte.Parameters
        '    ctrl = reporte.FindControl("lbl_" & prm.Name, False)
        '    AddHandler ctrl.PreviewClick, AddressOf CapturaNota
        '    AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        '    ctrl.Tag = prm
        'Next
        ctrl = reporte.FindControl("lbl_prm1", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        ctrl = reporte.FindControl("lbl_prm2", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        ctrl = reporte.FindControl("lbl_prm3", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        ctrl = reporte.FindControl("lbl_prm4", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        ctrl = reporte.FindControl("lbl_prm5", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
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

    Private Sub CheckBox1_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles CheckBox1.CheckedChanged
        If CheckBox1.Checked Then
            RadioButton1.Enabled = False
            RadioButton2.Enabled = False
            RadioButton3.Enabled = False
            RadioButton4.Enabled = False
        Else
            RadioButton1.Enabled = True
            RadioButton2.Enabled = True
            RadioButton3.Enabled = True
            RadioButton4.Enabled = True
        End If
    End Sub
End Class
