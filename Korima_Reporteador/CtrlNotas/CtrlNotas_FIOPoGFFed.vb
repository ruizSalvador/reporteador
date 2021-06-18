Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlNotas_FIOPoGFFed
    Dim TipoReporte
    Public notas1 As New Dictionary(Of String, String)
    Public notas2 As New Dictionary(Of String, String)
    Public notas3 As New Dictionary(Of String, String)
    Public notas4 As New Dictionary(Of String, String)
    Public notas5 As New Dictionary(Of String, String)
    Public notas6 As New Dictionary(Of String, String)
    Public notas7 As New Dictionary(Of String, String)
    Public notas8 As New Dictionary(Of String, String)
    Public notas9 As New Dictionary(Of String, String)
    Public notas10 As New Dictionary(Of String, String)

    Public reporte As NOTA_FIOPoGFFed

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New NOTA_FIOPoGFFed()
        Dim printTool As New ReportPrintTool(reporte)

        Dim conection As New SqlConnection(cnnString)

        Dim command As New SqlCommand("SP_NOTA_FIOPoGFFed", conection)
        command.CommandType = CommandType.StoredProcedure
        Dim adapter As New SqlDataAdapter(command)
        Dim ds As New DataSet()

        command.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_NOTA_FIOPoGFFed")
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_NOTA_FIOPoGFFed"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        'Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoDe.EditValue), 1))
        Dim tri As String = ""
        'If CheckBox1.Checked Then
        'tri = "Anual"
        'Else
        If RadioButton1.Checked Then tri = "Trimestre de Enero a Marzo"
        If RadioButton2.Checked Then tri = "Trimestre de Abril a Junio"
        If RadioButton3.Checked Then tri = "Trimestre de Julio a Septiembre"
        If RadioButton4.Checked Then tri = "Trimestre de Octubre a Diciembre"
        ' End If

        '-----------------------SP SubReporte1
        Dim conection2 As New SqlConnection(cnnString)
        Dim command2 As New SqlCommand("SP_SUB_NOTA_FIOPoGFFed2", conection2)
        command2.CommandType = CommandType.StoredProcedure

        If RadioButton1.Checked Then
            command2.Parameters.Add(New SqlParameter("@Mes", 1))
            command2.Parameters.Add(New SqlParameter("@Mes2", 3))
            command2.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        End If

        If RadioButton2.Checked Then
            command2.Parameters.Add(New SqlParameter("@Mes", 4))
            command2.Parameters.Add(New SqlParameter("@Mes2", 6))
            command2.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        End If

        If RadioButton3.Checked Then
            command2.Parameters.Add(New SqlParameter("@Mes", 7))
            command2.Parameters.Add(New SqlParameter("@Mes2", 9))
            command2.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        End If

        If RadioButton4.Checked Then
            command2.Parameters.Add(New SqlParameter("@Mes", 10))
            command2.Parameters.Add(New SqlParameter("@Mes2", 12))
            command2.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        End If

        Dim adapter2 As New SqlDataAdapter(command2)
        Dim ds2 As New DataSet()
        ds2.EnforceConstraints = False
        adapter2.Fill(ds2, "SP_SUB_NOTA_FIOPoGFFed2")
        reporte.XrSubreport2.ReportSource.DataSource = ds2
        reporte.XrSubreport2.ReportSource.DataAdapter = adapter2
        reporte.XrSubreport2.ReportSource.DataMember = "SP_SUB_NOTA_FIOPoGFFed2"


        '-----------------------SP SubReporte2
        Dim conection3 As New SqlConnection(cnnString)
        Dim command3 As New SqlCommand("SP_SUB_NOTA_FIOPoGFFed", conection3)
        command3.CommandType = CommandType.StoredProcedure


        If RadioButton1.Checked Then
            command3.Parameters.Add(New SqlParameter("@Mes", 1))
            command3.Parameters.Add(New SqlParameter("@Mes2", 3))
            command3.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        End If

        If RadioButton2.Checked Then
            command3.Parameters.Add(New SqlParameter("@Mes", 4))
            command3.Parameters.Add(New SqlParameter("@Mes2", 6))
            command3.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        End If

        If RadioButton3.Checked Then
            command3.Parameters.Add(New SqlParameter("@Mes", 7))
            command3.Parameters.Add(New SqlParameter("@Mes2", 9))
            command3.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        End If

        If RadioButton4.Checked Then
            command3.Parameters.Add(New SqlParameter("@Mes", 10))
            command3.Parameters.Add(New SqlParameter("@Mes2", 12))
            command3.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.EditValue.Year.ToString))

        End If




        Dim adapter3 As New SqlDataAdapter(command3)
        Dim ds3 As New DataSet()
        ds3.EnforceConstraints = False
        adapter3.Fill(ds3, "SP_SUB_NOTA_FIOPoGFFed")
        reporte.XrSubreport1.ReportSource.DataSource = ds3
        reporte.XrSubreport1.ReportSource.DataAdapter = adapter3
        reporte.XrSubreport1.ReportSource.DataMember = "SP_SUB_NOTA_FIOPoGFFed"

        '-----------------


        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Obligaciones pagadas o garantizadas con fondos federales' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') order by orden", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.Firmas.ReportSource.DataSource = dsC
        reporte.Firmas.ReportSource.DataAdapter = adapterC
        reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas2"



        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Formato de información de obligaciones pagadas o garantizadas con fondos federales"
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
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Obligaciones pagadas o garantizadas con fondos federales' ", New SqlConnection(cnnString))
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
        ctrl = reporte.FindControl("lbl_prm6", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        ctrl = reporte.FindControl("lbl_prm7", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        ctrl = reporte.FindControl("lbl_prm8", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        ctrl = reporte.FindControl("lbl_prm9", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        ctrl = reporte.FindControl("lbl_prm10", False)
        AddHandler ctrl.PreviewMouseMove, AddressOf ctrlMouseUp
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        ' filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now

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

    'Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CheckBox1.CheckedChanged
    'If CheckBox1.Checked Then
    ' RadioButton1.Enabled = False
    ' RadioButton2.Enabled = False
    ' RadioButton3.Enabled = False
    ' RadioButton4.Enabled = False
    'Else
    'RadioButton1.Enabled = True
    ' RadioButton2.Enabled = True
    ' RadioButton3.Enabled = True
    'RadioButton4.Enabled = True
    ' End If
    'End Sub
End Class
