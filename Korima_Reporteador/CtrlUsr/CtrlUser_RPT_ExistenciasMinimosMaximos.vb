Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_ExistenciasMinimosMaximos

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        'If FilterProv.Text = "" Then
        '    ErrorProvider1.SetError(FilterProv, "Debe seleccionar una cuenta contable")
        '    Exit Sub
        'End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_ExistenciasMinimosMaximos
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
        Dim SQLComando As New SqlCommand("SP_RPT_ExistenciasConMinimosyMaximos", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@IdAlmacen", IIf(ComboAlmacen.EditValue Is Nothing, DBNull.Value, ComboAlmacen.EditValue)))
        'SQLComando.Parameters.Add(New SqlParameter("@Reorden", IIf(numReorden.Value = 0, DBNull.Value, numReorden.Value)))

        If numReorden.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Reorden", 0))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@Reorden", Convert.ToInt32(numReorden.Value)))
        End If
        'SQLComando.Parameters.Add(New SqlParameter("@Fecha1", filterPeriodoDe.DateTime))
        'SQLComando.Parameters.Add(New SqlParameter("@Fecha2", FilterPeriodoAl.DateTime))

        SQLComando.CommandTimeout = 9999999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_ExistenciasConMinimosyMaximos")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_ExistenciasConMinimosyMaximos"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte de Máximos y Mínimos"
            .lblTitulo.Text = ""
            .lblRptDescripcionFiltrado.Text = "" '"Pedidos del " + filterPeriodoDe.Text + " al " + FilterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Existencias con Mínimos y Máximos' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub
    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterProv.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterProv.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Proveedores ", " Order by RazonSocial ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
   
    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.DateTime = Now
        FilterPeriodoAl.DateTime = Now
        'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        'With FilterProv.Properties
        '    .DataSource = ObjTempSQL2.List("", 0, " C_Proveedores ", " Order by RazonSocial ")
        '    .DisplayMember = "RazonSocial"
        '    .ValueMember = "IdProveedor"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        'End With

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboAlmacen.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Almacenes ", " Order by IdAlmacen ")
            .DisplayMember = "Almacen"
            .ValueMember = "IdAlmacen"
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
    Private Sub ComboAlmacen_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboAlmacen.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboAlmacen.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Almacenes ", " Order by IdAlmacen ")
            .DisplayMember = "Almacen"
            .ValueMember = "IdAlmacen"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        ComboAlmacen.ItemIndex = 0
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        'ComboAlmacen.Properties.DataSource = Nothing
        'ComboAlmacen.Properties.NullText = ""
        ComboAlmacen.ItemIndex = 0
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        numReorden.Value = 0
    End Sub
End Class