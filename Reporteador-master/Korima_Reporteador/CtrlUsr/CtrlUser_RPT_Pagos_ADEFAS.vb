Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Pagos_ADEFAS
    Dim Entregado As Integer = 0
    Dim Estatus As String = ""
    

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        If filterPeriodoDe.DateTime.Year <> filterPeriodoAl.DateTime.Year Then
            ErrorProvider1.SetError(filterPeriodoAl, "El periodo de tiempo tiene que pertenecer al mismo ejercicio")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Pagos_ADEFAS
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
        Dim SQLComando As New SqlCommand("SP_RPT_Pagos_ADEFAS", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", filterPeriodoDe.DateTime.Date))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", filterPeriodoAl.DateTime.Date))
        SQLComando.Parameters.Add(New SqlParameter("@IdProveedor", IIf(filterProveedor.Text.Length > 0, Convert.ToInt32(filterProveedor.EditValue), 0)))
        SQLComando.Parameters.Add(New SqlParameter("@IdPartida", IIf(filterPartida1.Text.Length > 0, Convert.ToInt32(filterPartida1.EditValue), 0)))
        SQLComando.Parameters.Add(New SqlParameter("@IdUR", IIf(filterUnidadResponsable.Text.Length > 0, Convert.ToInt32(filterUnidadResponsable.EditValue), 0)))
        'SQLComando.Parameters.Add(New SqlParameter("@Estatus", Estatus))
        'SQLComando.Parameters.Add(New SqlParameter("@Entregado", Entregado))
        'SQLComando.CommandTimeout = 999999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_Pagos_ADEFAS")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_Pagos_ADEFAS"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            'If ((ComboBox1.SelectedIndex = 0 Or ComboBox1.SelectedIndex = 1) And (ComboBox2.SelectedItem <> Nothing And ComboBox2.Text <> "Todos")) Then
           
          
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Pagos Administrativos de ADEFAS."
            .lblRptDescripcionFiltrado.Text = "Del  " + filterPeriodoDe.Text + " Al " + filterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = ""
            

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

        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida1.Properties
            .DataSource = ObjTempSQL1.List(" IdPartida Like '9%'", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by RazonSocial ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        Dim ObjTempSQL5 As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL5.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


    End Sub
   
    

    

    Private Sub FilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs)
        '
    End Sub

    Private Sub filterUnidadResponsable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL1.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterProveedor.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterProveedor.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by RazonSocial ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterPartida1_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartida1.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida1.Properties
            .DataSource = ObjTempSQL1.List(" IdPartida Like '991%'", 0, "c_partidaspres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub CleanUnidadResponsable_Click(sender As System.Object, e As System.EventArgs) Handles CleanUnidadResponsable.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs)

    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs)

    End Sub

    Private Sub SimpleButton4_Click_1(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        filterProveedor.Properties.DataSource = Nothing
        filterProveedor.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs)

    End Sub

    Private Sub SimpleButton3_Click_1(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        filterPartida1.Properties.DataSource = Nothing
        filterPartida1.Properties.NullText = ""
    End Sub
End Class