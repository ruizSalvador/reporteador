Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports DevExpress.XtraPivotGrid
Public Class CtrlUser_RPT_CuadroComparativoNProveedores

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        If FilterProv.Text = "" Then
            ErrorProvider1.SetError(FilterProv, "Debe seleccionar una cotización")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_CuadroComparativo
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        ErrorProvider1.Clear()
        'gcData.DataSource = Nothing


        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_CuadroComparativonProveedores", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@IdCotizacion", FilterProv.EditValue))

        SQLComando.CommandTimeout = 0
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Try
            GridView1.Columns.Clear()
            Dim ds As New DataSet()
            ds.EnforceConstraints = False
            adapter.Fill(ds, "SP_RPT_CuadroComparativonProveedores")
            gcData.DataSource = ds
            gcData.DataMember = "SP_RPT_CuadroComparativonProveedores"
            Me.GridView1.Columns.Clear()
            Me.GridView1.PopulateColumns()
            Me.GridView1.OptionsBehavior.Editable = False
            gcData.Refresh()
        Catch
            MessageBox.Show("Ocurrió un error al generar los datos", "Kórima", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
        End Try


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne

        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .XrLabel43.Text = FilterProv.EditValue.ToString
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "CUADRO COMPARATIVO DE 'N' COTIZACIONES"
            .lblTitulo.Text = ""
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Cuadro Comparativo' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        'PrintControl1.PrintingSystem = reporte.PrintingSystem
        'reporte.CreateDocument()

        Me.Cursor = Cursors.Default
    End Sub
    Private Sub FilterProv_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterProv.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterProv.Properties
            .DataSource = ObjTempSQL2.List("", 0, " T_Cotizaciones ", " Order by IdCotizacion ")
            .DisplayMember = "IdSolicitud"
            .ValueMember = "IdCotizacion"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.DateTime = Now
        FilterPeriodoAl.DateTime = Now
        FilterProv.EditValue = FilterProv.Properties.GetDataSourceValue(FilterProv.Properties.ValueMember, 1)

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterProv.Properties
            .DataSource = ObjTempSQL2.List("", 0, " T_Cotizaciones ", " Order by IdCotizacion ")
            .DisplayMember = "IdSolicitud"
            .ValueMember = "IdCotizacion"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterProv.Properties.DataSource = Nothing
        FilterProv.Properties.NullText = ""
    End Sub

    Private Sub FilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles FilterProv.EditValueChanged
        '
    End Sub

    Private Sub btnExport_Click(sender As System.Object, e As System.EventArgs) Handles btnExport.Click
        Dim save As New SaveFileDialog()

        save.Filter = "xlsx files (*.xlsx)|*.xlsx|All files (*.*)|*.*"
   
        If save.ShowDialog() = DialogResult.OK Then
            gcData.ExportToXlsx(save.FileName)
            Open(save.FileName)
        End If

       
    End Sub

    Private Sub Open(ByVal FileName As String)
        Try
            Dim process As New Process()
            process.StartInfo.FileName = FileName
            process.StartInfo.Verb = "Open"
            process.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Normal
            process.Start()
        Catch
            MessageBox.Show("Ocurrió un error al abrir el archivo", "Kórima", MessageBoxButtons.OK, MessageBoxIcon.Exclamation)
        End Try
    End Sub
End Class