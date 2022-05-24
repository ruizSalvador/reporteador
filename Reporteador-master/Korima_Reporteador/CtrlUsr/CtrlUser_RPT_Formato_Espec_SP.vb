Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports DevExpress.XtraReports.Parameters
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Formato_Espec_SP
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

    Dim reporte As RPT_Formato_Espec_SP

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        reporte = New RPT_Formato_Espec_SP()
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_Formato_Espec_SP", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure


        '--- Parametros IN

        If ChAnual.Checked = True Then
            PeriodoAl.EditValue = Nothing
            PeriodoDel.EditValue = Nothing
            SQLComando.Parameters.Add(New SqlParameter("@PeriodoDel", 0))
            SQLComando.Parameters.Add(New SqlParameter("@PeriodoAl", 0))

        Else
            SQLComando.Parameters.Add(New SqlParameter("@PeriodoDel", PeriodoDel.Text))
            SQLComando.Parameters.Add(New SqlParameter("@PeriodoAl", PeriodoAl.Text))
        End If

        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", TimeEdit1.Text))

        If filterFuenteFinan.Properties.KeyValue <> Nothing Then
            SQLComando.Parameters.Add(New SqlParameter("@FuenteFinanciamiento", filterFuenteFinan.Properties.KeyValue))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@FuenteFinanciamiento", ""))
        End If

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_Formato_Espec_SP")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_Formato_Espec_SP"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Formato Específico de Aplicación de Recursos a Seguridad Pública' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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

        With reporte
            .lblRptEntidadFederativa.Text = "Formato Especifico"
            .lblRptNombreReporte.Text = "Sistema Nacional de Seguridad Pública"
            If ChAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "(cifras correspondientes al año " + TimeEdit1.Text + ")"
            Else
                .lblRptDescripcionFiltrado.Text = "(cifras del Periodo " + PeriodoDel.Text + " al Periodo " + PeriodoAl.Text + " del " + TimeEdit1.Text + ")"
            End If

            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblTitulo.Text = "Avance en la Aplicación de los Recursos Asignados a los Programas de Seguridad Pública " + TimeEdit1.Text
            .XrLabel13.Text = "Entidad Federativa: " + pRPTCFGDatosEntes.EntidadFederativa
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            .lblRptEnteEF.Text = pRPTCFGDatosEntes.EntidadFederativa
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= 'Formato Específico de Aplicación de Recursos a Seguridad Pública'", New SqlConnection(cnnString))
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

    Public Sub New()
        ' This call is required by the designer.
        InitializeComponent()
        ' Add any initialization after the InitializeComponent() call.

    End Sub

    Private Sub BarLargeButtonItem1_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarLargeButtonItem1.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Formato Gral"
        dlg.Filter = "Archivos PDF|*.pdf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToPdf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem2_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem2.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Formato Gral"
        dlg.Filter = "Archivos de Formato de Texto Enriquecido|*.rtf"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToRtf(dlg.FileName)
        End If
    End Sub

    Private Sub BarButtonItem3_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles BarButtonItem3.ItemClick
        Dim dlg As New SaveFileDialog()
        dlg.Title = "Exporta Formato Gral"
        dlg.Filter = "Archivo de Hoja de Cálculo|*.xls"
        If dlg.ShowDialog(Me) = DialogResult.OK Then
            reporte.ExportToXls(dlg.FileName)
        End If
    End Sub

    Private Sub TimeEdit1_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles TimeEdit1.EditValueChanged

    End Sub

    Private Sub filterFuenteFinan_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterFuenteFinan.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinan.Properties
            '.DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento where TIPOORIGENRECURSO in('F','R','T') UNION Select '' as FUENTEFINANCIAMIENTO, '' as DESCRIPCION, '' as CLAVE, '' as TIPOORIGENRECURSO, '' as IDCUENTABANCARIA, '' as DESACTIVAR, '' as IDCLAVE, '' as DATOSCLAVE", " Order by DESCRIPCION ")
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento where TIPOORIGENRECURSO in('F','R','T')", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "DESCRIPCION"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub CtrlUser_RPT_Formato_Gral_SP_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load

        TimeEdit1.EditValue = Now


        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinan.Properties
            '.DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento where TIPOORIGENRECURSO in('F','R','T')  UNION Select '' as FUENTEFINANCIAMIENTO, '' as DESCRIPCION, '' as CLAVE, '' as TIPOORIGENRECURSO, '' as IDCUENTABANCARIA, '' as DESACTIVAR, '' as IDCLAVE, '' as DATOSCLAVE", " Order by DESCRIPCION ")
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento where TIPOORIGENRECURSO in('F','R','T')", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "DESCRIPCION"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterFuenteFinan.Properties.KeyValue = Nothing
    End Sub
End Class
