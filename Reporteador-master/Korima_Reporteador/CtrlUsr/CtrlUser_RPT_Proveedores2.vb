Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Proveedores2

    Function CheckTodos() As String

        If CheckBox1.Checked = True Then
            Return "Activos"
        End If
        If CheckBox1.Checked = False Then
            Return ""
        End If


    End Function

    Function Combo_Valor() As String

        If ComboBox1.Text = "" Then
            Return "(Ninguno)"
        End If
        If ComboBox1.Text = "Proveedor" Then
            Return "P"
        End If
        If ComboBox1.Text = "Contratista" Then
            Return "C"
        End If
        If ComboBox1.Text = "Beneficiario" Then
            Return "V"
        End If
    End Function

    Function CamposVisibles()


    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click


        ErrorProvider1.Clear()
        'If FilterProv.Text = "" Then
        '    ErrorProvider1.SetError(FilterProv, "Debe seleccionar una cuenta contable")
        '    Exit Sub
        'End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Proveedores2
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
        Dim SQLComando As New SqlCommand("SP_RPT_CatalogoProveedores2", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Todo", CheckTodos()))
        SQLComando.Parameters.Add(New SqlParameter("@Tipo", Combo_Valor()))
        SQLComando.Parameters.Add(New SqlParameter("@Periodo", Month(filterPeriodo.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@SaldoMayorCero", CheckBox_SaldoMayorCero.Checked))
        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_CatalogoProveedores2")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_CatalogoProveedores2"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0

        If ComboBox1.Text = "" Then
            'reporte.XrLabel10.Visible = True
            'reporte.XrLabel13.Visible = True
        Else
            'reporte.XrLabel10.Visible = False
            'reporte.XrLabel13.Visible = False
            'reporte.XrLabel11.WidthF = 1092.98
            'reporte.XrLabel14.WidthF = 1092.98
        End If

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Catálogo de Proveedores"
            .lblTitulo.Text = ""
            '.lblRptDescripcionFiltrado.Text = "Facturas del " + filterPeriodoDe.Text + " al " + FilterPeriodoAl.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario

            If ComboBox1.Text = "" Then
                .lblSubtitulo.Visible = False
            Else
                .lblSubtitulo.Visible = True
                .lblSubtitulo.Text = "Por: " + ComboBox1.Text
            End If

            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Catalogo de Proveedores' ", New SqlConnection(cnnString))
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
    End Sub

    Private Sub CtrlUser_RPT_Proveedores_Load(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles MyBase.Load
        ComboBox1.SelectedIndex = 0
        filterPeriodo.EditValue = Now
        filterEjercicio.EditValue = Now
    End Sub
End Class