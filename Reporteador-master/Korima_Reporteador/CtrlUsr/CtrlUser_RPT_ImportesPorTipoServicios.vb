Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_ImportesPorTipoServicios
    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
      
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_ImportesPorTipoServicios
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_ImportesPorTipoServicios", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Mes1", filterPeriodoDe.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Mes2", filterPeriodoAl.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Ejercicio.Time.Year))
        If FilterTipoServicio.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@TipoServicio", " "))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@TipoServicio", FilterTipoServicio.Properties.KeyValue))
        End If

        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_ImportesPorTipoServicios")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_ImportesPorTipoServicios"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Importes por tipo de Servicios"
            .lblTitulo.Text = ""
            .lblRptDescripcionFiltrado.Text = "Movimientos del Ejercicio " + Ejercicio.Text + " Período del " + filterPeriodoDe.Text + " al " + filterPeriodoAl.Text
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
    Private Sub FilterTipoServicio_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterTipoServicio.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterTipoServicio.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TipoServicios ", " Order by IdTipoServicio ")
            .DisplayMember = "DescripcionTipoServicio"
            .ValueMember = "IdTipoServicio"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.Time = Now
        filterPeriodoAl.Time = Now
        Ejercicio.Time = Now
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterTipoServicio.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TipoServicios ", " Order by IdTipoServicio")
            .DisplayMember = "DescripcionTipoServicio"
            .ValueMember = "IdTipoServicio"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub SimpleButton2_Click_1(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterTipoServicio.Properties.DataSource = Nothing
        FilterTipoServicio.Properties.NullText = ""
    End Sub

    Private Sub FilterTipoServicio_EditValueChanged_1(sender As System.Object, e As System.EventArgs) Handles FilterTipoServicio.EditValueChanged
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterTipoServicio.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_TipoServicios ", " Order by IdTipoServicio")
            .DisplayMember = "DescripcionTipoServicio"
            .ValueMember = "IdTipoServicio"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
End Class