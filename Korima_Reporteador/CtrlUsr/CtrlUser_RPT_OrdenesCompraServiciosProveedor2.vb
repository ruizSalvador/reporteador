Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_OrdenesCompraServiciosProveedor2



    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click

        ErrorProvider1.Clear()
        If filterPeriodoDe.DateTime.Year <> filterPeriodoAl.DateTime.Year Then
            ErrorProvider1.SetError(filterPeriodoAl, "El periodo de tiempo tiene que pertenecer al mismo ejercicio")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_OrdenesCompraServiciosProveedor2
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
        'Dim SQLComando As New SqlCommand("SP_RPT_CatalogoProveedores3", SQLConexion)
        Dim SQLComando As New SqlCommand("SP_RPT_CatalogoProveedores3", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", filterPeriodoDe.DateTime.Date))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", filterPeriodoAl.DateTime.Date))
        'SQLComando.Parameters.Add(New SqlParameter("@Proveedor1", filterProveedor1.Text.Trim))
        SQLComando.Parameters.Add(New SqlParameter("@Proveedor1", filterProveedor1.EditValue))
        SQLComando.Parameters.Add(New SqlParameter("@Proveedor2", filterProveedor2.EditValue))
        'SQLComando.Parameters.Add(New SqlParameter("@Proveedor2", filterProveedor2.Text.Trim))
        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_CatalogoProveedores3")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_CatalogoProveedores3"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte de Proveedores Mensual Pagado"
            .lblRptDescripcionFiltrado.Text = "Movimientos del: " + filterPeriodoDe.Text + " Al: " + filterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario

            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Cheques y Transferencias Electronicas' ", New SqlConnection(cnnString))
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
        filterPeriodoDe.DateTime = Now
        filterPeriodoAl.DateTime = Now

        '---Llenar listas
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor1.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        With filterProveedor2.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True

        End With

    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        filterProveedor1.Properties.DataSource = Nothing
        filterProveedor1.Properties.NullText = ""
        CheckEdit1.Enabled = True
        CheckEdit1.Checked = True
    End Sub

    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterProveedor1.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor1.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub filterProveedor2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterProveedor2.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor2.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by IdProveedor ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterProveedor_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterProveedor1.EditValueChanged
        CheckEdit1.Enabled = False
        CheckEdit1.Checked = True
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterProveedor2.Properties.DataSource = Nothing
        filterProveedor2.Properties.NullText = ""
        CheckEdit1.Enabled = True
        CheckEdit1.Checked = True
    End Sub

    Private Sub filterProveedor2_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterProveedor2.EditValueChanged
        CheckEdit1.Enabled = False
        CheckEdit1.Checked = True
    End Sub
End Class