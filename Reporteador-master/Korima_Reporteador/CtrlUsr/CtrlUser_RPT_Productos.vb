Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Productos

    Function Combo_Valor() As String

        If ComboBox1.Text = "" Then
            'ocultar combos
            ComboGrupo.Visible = False
            ComboSubGrupo.Visible = False
            ComboClases.Visible = False
            ComboSubClase.Visible = False
            ComboAlmacen.Visible = False
            ComboPartida.Visible = False
            ComboEstatus.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl2.Visible = False
            LabelControl4.Visible = False
            LabelControl5.Visible = False
            LabelControl6.Visible = False
            LabelControl7.Visible = False
            LabelControl8.Visible = False
            Return "(Ninguno)"

        End If
        If ComboBox1.Text = "Grupo" Then
            ComboGrupo.Visible = True
            LabelControl1.Visible = True
            'ocultar combos
            ComboSubGrupo.Visible = False
            ComboClases.Visible = False
            ComboSubClase.Visible = False
            ComboAlmacen.Visible = False
            ComboPartida.Visible = False
            ComboEstatus.Visible = False
            'ocultar etiquetas
            LabelControl2.Visible = False
            LabelControl4.Visible = False
            LabelControl5.Visible = False
            LabelControl6.Visible = False
            LabelControl7.Visible = False
            LabelControl8.Visible = False
            Return "G"
        End If

        If ComboBox1.Text = "SubGrupo" Then
            ComboSubGrupo.Visible = True
            LabelControl2.Visible = True
            'ocultar combos
            ComboGrupo.Visible = False
            ComboClases.Visible = False
            ComboSubClase.Visible = False
            ComboAlmacen.Visible = False
            ComboPartida.Visible = False
            ComboEstatus.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl4.Visible = False
            LabelControl5.Visible = False
            LabelControl6.Visible = False
            LabelControl7.Visible = False
            LabelControl8.Visible = False
            Return "SG"
        End If

        If ComboBox1.Text = "Clase" Then
            ComboClases.Visible = True
            LabelControl4.Visible = True
            'ocultar combos
            ComboGrupo.Visible = False
            ComboSubGrupo.Visible = False
            ComboSubClase.Visible = False
            ComboAlmacen.Visible = False
            ComboPartida.Visible = False
            ComboEstatus.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl2.Visible = False
            LabelControl5.Visible = False
            LabelControl6.Visible = False
            LabelControl7.Visible = False
            LabelControl8.Visible = False
            Return "C"
        End If

        If ComboBox1.Text = "SubClase" Then
            ComboSubClase.Visible = True
            LabelControl5.Visible = True
            'ocultar combos
            ComboGrupo.Visible = False
            ComboSubGrupo.Visible = False
            ComboClases.Visible = False
            ComboAlmacen.Visible = False
            ComboPartida.Visible = False
            ComboEstatus.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl2.Visible = False
            LabelControl4.Visible = False
            LabelControl6.Visible = False
            LabelControl7.Visible = False
            LabelControl8.Visible = False
            Return "SC"
        End If

        If ComboBox1.Text = "Almacén" Then
            ComboAlmacen.Visible = True
            LabelControl6.Visible = True
            'ocultar combos
            ComboGrupo.Visible = False
            ComboSubGrupo.Visible = False
            ComboClases.Visible = False
            ComboSubClase.Visible = False
            ComboPartida.Visible = False
            ComboEstatus.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl2.Visible = False
            LabelControl4.Visible = False
            LabelControl5.Visible = False
            LabelControl7.Visible = False
            LabelControl8.Visible = False
            Return "A"
        End If

        If ComboBox1.Text = "Partida" Then
            ComboPartida.Visible = True
            LabelControl7.Visible = True
            'ocultar combos
            ComboGrupo.Visible = False
            ComboSubGrupo.Visible = False
            ComboClases.Visible = False
            ComboSubClase.Visible = False
            ComboAlmacen.Visible = False
            ComboEstatus.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl2.Visible = False
            LabelControl4.Visible = False
            LabelControl5.Visible = False
            LabelControl6.Visible = False
            LabelControl8.Visible = False
            Return "P"
        End If

        If ComboBox1.Text = "Estatus" Then
            ComboEstatus.Visible = True
            LabelControl8.Visible = True
            'ocultar combos
            ComboGrupo.Visible = False
            ComboSubGrupo.Visible = False
            ComboClases.Visible = False
            ComboSubClase.Visible = False
            ComboAlmacen.Visible = False
            ComboPartida.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl2.Visible = False
            LabelControl4.Visible = False
            LabelControl5.Visible = False
            LabelControl6.Visible = False
            LabelControl7.Visible = False
            Return "E"
        End If

    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        'If FilterProv.Text = "" Then
        '    ErrorProvider1.SetError(FilterProv, "Debe seleccionar una cuenta contable")
        '    Exit Sub
        'End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Productos
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
        Dim SQLComando As New SqlCommand("SP_RPT_CatalogoProductos", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Todo", Combo_Valor()))
        SQLComando.Parameters.Add(New SqlParameter("@Grupo", IIf(ComboGrupo.Properties.KeyValue Is Nothing, 0, ComboGrupo.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@SubGrupo", IIf(ComboSubGrupo.Properties.KeyValue Is Nothing, 0, ComboSubGrupo.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Clase", IIf(ComboClases.Properties.KeyValue Is Nothing, 0, ComboClases.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@SubClase", IIf(ComboSubClase.Properties.KeyValue Is Nothing, 0, ComboSubClase.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Almacen", ComboAlmacen.Text))
        SQLComando.Parameters.Add(New SqlParameter("@Partida", IIf(ComboPartida.Properties.KeyValue Is Nothing, 0, ComboPartida.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Estatus", ComboEstatus.Text))

        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_CatalogoProductos")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_CatalogoProductos"

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

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Catálogo de Productos' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        'FilterTipo.Properties.DataSource = Nothing
        'FilterTipo.Properties.NullText = ""
    End Sub

    Private Sub CtrlUser_RPT_Proveedores_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ComboBox1.SelectedIndex = 0
        ComboEstatus.SelectedIndex = 0
    End Sub

    Private Sub ComboGrupo_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboGrupo.Properties
            .DataSource = ObjTempSQL2.List(" IdGrupo = 2 OR IdGrupo = 5 ", 0, " C_grupos ", " Order by IdGrupo ")
            .DisplayMember = "NombreGrupo"
            .ValueMember = "IdGrupo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboSubGrupo_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboSubGrupo.Properties
            .DataSource = ObjTempSQL2.List(" IdGrupo = 2 OR IdGrupo = 5 ", 0, " C_subgrupos ", " Order by IdSubgrupo ")
            .DisplayMember = "NombreSubgrupo"
            .ValueMember = "IdSubgrupo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboClases_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboClases.Properties
            .DataSource = ObjTempSQL2.List(" IdGrupo = 2 OR IdGrupo = 5 ", 0, " C_Familias ", " Order by IdFamilia ")
            .DisplayMember = "NombreFamilia"
            .ValueMember = "IdFamilia"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboSubClases_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboSubClase.Properties
            .DataSource = ObjTempSQL2.List(" IdGrupo = 2 OR IdGrupo = 5 ", 0, " C_SubClases ", " Order by IdSubClase ")
            .DisplayMember = "NombreSubClase"
            .ValueMember = "IdSubClase"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub ComboAlmacen_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboAlmacen.Properties
            .DataSource = ObjTempSQL2.List("  ", 0, " C_Almacenes ", " Order by IdAlmacen ")
            .DisplayMember = "Almacen"
            .ValueMember = "IdAlmacen"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboPartida_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboPartida.Properties
            .DataSource = ObjTempSQL2.List(" ClavePartida between 2000 and 2999 or ClavePartida between 5000 and 5999 ", 0, " C_PartidasPres ", " Order by IdPartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "IdPartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub ComboBox1_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ComboBox1.SelectedIndexChanged
        Combo_Valor()
    End Sub

    Private Sub SimpleButton2_Click_1(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        ComboBox1.Text = ""
    End Sub
End Class