Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Imports System.ComponentModel
Public Class CtrlUser_RPT_ExistenciasAlmacen


   

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        'If FilterProv.Text = "" Then
        '    ErrorProvider1.SetError(FilterProv, "Debe seleccionar una cuenta contable")
        '    Exit Sub
        'End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_ExistenciasAlmacen
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
        Dim SQLComando As New SqlCommand("SP_RPT_K2_ExistenciasAlmacen", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@IdAlmacen", IIf(ComboAlmacen.Properties.KeyValue Is Nothing, DBNull.Value, ComboAlmacen.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@ClavePartida", IIf(ComboPartida.Properties.KeyValue Is Nothing, DBNull.Value, ComboPartida.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@TipoProducto", IIf(ComboBox1.Text.Trim = "", DBNull.Value, Tipo(ComboBox1.Text))))
        SQLComando.Parameters.Add(New SqlParameter("@IdGrupo", IIf(ComboGrupo.Properties.KeyValue Is Nothing, DBNull.Value, ComboGrupo.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@IdSubGrupo", IIf(ComboSubGrupo.Properties.KeyValue Is Nothing, DBNull.Value, ComboSubGrupo.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@IdFamilia", IIf(ComboClases.Properties.KeyValue Is Nothing, DBNull.Value, ComboClases.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@IdSubClase", IIf(ComboSubClase.Properties.KeyValue Is Nothing, DBNull.Value, ComboSubClase.Properties.KeyValue)))


        SQLComando.CommandTimeout = 99999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_ExistenciasAlmacen")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_ExistenciasAlmacen"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Catálogo de productos registrados en el sistema"
            .lblTitulo.Text = "Al Dia " + Now.Date
            '.lblRptDescripcionFiltrado.Text = "Facturas del " + filterPeriodoDe.Text + " al " + FilterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblSubtitulo.Text = "Con Estatus "
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Existencias en almacén' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub
    Function Tipo(sTipo As String) As Integer
        Select Case sTipo
            Case "Consumible"
                Return 1
            Case "Activo Fijo"
                Return 2
            Case "Control"
                Return 4
            Case Else
                Return 0
        End Select

    End Function

    Private Sub CtrlUser_RPT_ExistenciasAlmace_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        '
    End Sub

    Private Sub ComboGrupo_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboGrupo.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboGrupo.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_grupos ", " Order by IdGrupo ")
            .DisplayMember = "NombreGrupo"
            .ValueMember = "IdGrupo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboSubGrupo_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboSubGrupo.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboSubGrupo.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_subgrupos ", " Order by IdSubgrupo ")
            .DisplayMember = "NombreSubgrupo"
            .ValueMember = "IdSubgrupo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboClases_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboClases.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboClases.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_Familias ", " Order by IdFamilia ")
            .DisplayMember = "NombreFamilia"
            .ValueMember = "IdFamilia"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboSubClases_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboSubClase.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboSubClase.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_SubClases ", " Order by IdSubClase ")
            .DisplayMember = "NombreSubClase"
            .ValueMember = "IdSubClase"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
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
    End Sub

    Private Sub ComboPartida_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load, ComboPartida.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboPartida.Properties
            .DataSource = ObjTempSQL2.List("", 0, " C_PartidasPres ", " Order by IdPartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub SimpleButton2_Click_1(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        ComboAlmacen.Properties.DataSource = Nothing
        ComboAlmacen.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        ComboPartida.Properties.DataSource = Nothing
        ComboPartida.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton8_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton8.Click
        ComboBox1.SelectedItem = Nothing
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        ComboGrupo.Properties.DataSource = Nothing
        ComboGrupo.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton5.Click
        ComboSubGrupo.Properties.DataSource = Nothing
        ComboSubGrupo.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton6_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton6.Click
        ComboClases.Properties.DataSource = Nothing
        ComboClases.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton7_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton7.Click
        ComboSubClase.Properties.DataSource = Nothing
        ComboSubClase.Properties.NullText = ""
    End Sub
End Class