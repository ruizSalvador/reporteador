Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Informativa_Proveedores
    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Informativa_Proveedores
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_Informativa_Proveedores", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Periodo1", filterPeriodoDe.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Periodo2", filterPeriodoAl.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Ejercicio.Time.Year))
        If FilterProv.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdProveedor", 0))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@IdProveedor", Convert.ToInt32(FilterProv.EditValue)))
        End If

        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_Informativa_Proveedores")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_Informativa_Proveedores"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Informativa de Proveedores"
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
    Private Sub FilterProv_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterProv.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterProv.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Proveedores ", " Order by CLAVE ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
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
        With FilterProv.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Proveedores ", " Order by CLAVE ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub SimpleButton2_Click_1(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterProv.Properties.DataSource = Nothing
        FilterProv.Properties.NullText = ""
    End Sub

End Class