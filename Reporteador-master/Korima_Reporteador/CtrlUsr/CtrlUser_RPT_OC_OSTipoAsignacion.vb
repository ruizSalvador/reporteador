Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_OC_OSTipoAsignacion
    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        'If FilterCuenta.Text = "" Then
        '    ErrorProvider1.SetError(FilterCuenta, "Debe seleccionar una cuenta contable")
        '    Exit Sub
        'End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_OC_OSTipoAsignacion
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        ErrorProvider1.Clear()

        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_OrdenCompraTipoAsignacion", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Periodo", filterPeriodoDe.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.Time.Year))
        If FilterCuenta.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@TipoAsignacion", " "))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@TipoAsignacion", FilterCuenta.Properties.KeyValue))
        End If

        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_OrdenCompraTipoAsignacion")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_OrdenCompraTipoAsignacion"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "OC/OS por Tipo de Asignación"
            .lblTitulo.Text = ""
            .lblRptDescripcionFiltrado.Text = "Movimientos del Ejercicio " + filterPeriodoAl.Text + " Período " + filterPeriodoDe.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .lblSubtitulo.Text = ""
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub
    Private Sub FilterCuenta_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuenta.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" RevisionComite=1 ", 0, " C_TiposCompra ", " Order by IdTipoCompra ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoCompra"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.Time = Now
        filterPeriodoAl.Time = Now
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" RevisionComite=1 ", 0, " C_TiposCompra ", " Order by IdTipoCompra ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoCompra"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub SimpleButton2_Click_1(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterCuenta.Properties.DataSource = Nothing
        FilterCuenta.Properties.NullText = ""
    End Sub

    Private Sub FilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs)
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" RevisionComite=1 ", 0, " C_TiposCompra ", " Order by IdTipoCompra ")
            .DisplayMember = "Descripcion"
            .ValueMember = "IdTipoCompra"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
End Class