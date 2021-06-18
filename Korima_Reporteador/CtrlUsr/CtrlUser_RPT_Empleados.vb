Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Empleados

    Function Radios() As String

        If RadioButton1.Checked = True Then
            Return "Activos"
        End If

        If RadioButton2.Checked = True Then
            Return "Inactivos"
        End If

        If RadioButton3.Checked = True Then
            Return "Todos"
        End If
    End Function

    Function Combo_Valor() As String

        If ComboBox1.Text = "" Then
            'ocultar combos
            ComboUR.Visible = False
            ComboDepto.Visible = False
            FechaDel.Visible = False
            FechaAl.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl2.Visible = False
            LabelControl4.Visible = False
            LabelControl6.Visible = False
            Return "(Ninguno)"

        End If

        If ComboBox1.Text = "Unidad Responsable" Then
            ComboUR.Visible = True
            LabelControl1.Visible = True
            'ocultar combos
            ComboDepto.Visible = False
            FechaDel.Visible = False
            FechaAl.Visible = False
            'ocultar etiquetas
            LabelControl2.Visible = False
            LabelControl4.Visible = False
            LabelControl6.Visible = False
            Return "UR"
        End If

        If ComboBox1.Text = "Departamento" Then
            ComboDepto.Visible = True
            LabelControl2.Visible = True
            'ocultar combos
            ComboUR.Visible = False
            FechaDel.Visible = False
            FechaAl.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl4.Visible = False
            LabelControl6.Visible = False
            Return "D"
        End If

        If ComboBox1.Text = "Fecha de Alta" Then
            FechaDel.Visible = True
            FechaAl.Visible = True
            LabelControl4.Visible = True
            LabelControl6.Visible = True
            'ocultar combos
            ComboUR.Visible = False
            ComboDepto.Visible = False
            'ocultar etiquetas
            LabelControl1.Visible = False
            LabelControl2.Visible = False
            Return "F"
        End If


    End Function

    Dim filtrado As String

    Function F_filtrado() As String



        If ComboBox1.Text = "" Then
            filtrado = "Todos"
        End If

        If ComboBox1.Text <> "" Then
            filtrado = ComboBox1.Text
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
        Dim reporte As New RPT_Empleados
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
        Dim SQLComando As New SqlCommand("SP_RPT_CatalogoEmpleados", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Filtro", Combo_Valor()))
        SQLComando.Parameters.Add(New SqlParameter("@Radio", Radios()))
        SQLComando.Parameters.Add(New SqlParameter("@UR", IIf(ComboUR.Properties.KeyValue Is Nothing, 0, ComboUR.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Depto", IIf(ComboDepto.Properties.KeyValue Is Nothing, 0, ComboDepto.Properties.KeyValue)))
        SQLComando.Parameters.Add(New SqlParameter("@FechaDel", FechaDel.Text))
        SQLComando.Parameters.Add(New SqlParameter("@FechaAl", FechaAl.Text))

        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_CatalogoEmpleados")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_CatalogoEmpleados"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Catálogo de Empleados registrados en el sistema"
            .lblTitulo.Text = "Por: " + filtrado
            '.lblRptDescripcionFiltrado.Text = "Facturas del " + filterPeriodoDe.Text + " al " + FilterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblSubtitulo.Text = "Con Estatus: " + Radios()
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Catálogo de Empleados' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        ComboBox1.Text = ""
        RadioButton1.Checked = True
    End Sub

    Private Sub CtrlUser_RPT_Proveedores_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ComboBox1.SelectedIndex = 0

    End Sub

    Private Sub ComboUR_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboUR.Properties
            .DataSource = ObjTempSQL2.List(" ", 0, " C_AreaResponsabilidad ", " Order by IdAreaResp ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub ComboDepto_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles Me.Load
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With ComboDepto.Properties
            .DataSource = ObjTempSQL2.List(" ", 0, " C_Departamentos ", " Order by IdDepartamento ")
            .DisplayMember = "NombreDepartamento"
            .ValueMember = "IdDepartamento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub ComboBox1_SelectedIndexChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ComboBox1.SelectedIndexChanged
        Combo_Valor()
        F_filtrado()
    End Sub

End Class