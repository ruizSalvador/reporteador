Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_AnaliticoPorProveedorContable
    Dim Entregado As Integer = 0
    Dim Estatus As String = ""
    Private Sub AsignaEstatusEntregado()
        'Cheques
        If ComboBox1.SelectedIndex = 0 Then
            Select Case ComboBox2.Text
                Case "No Generados"
                    Estatus = "G"
                Case "Por Imprimir"
                    Estatus = "C"
                Case "Impresos No Entregados"
                    Estatus = "I"
                    Entregado = 0
                Case "Impresos Entregados"
                    Estatus = "I"
                    Entregado = 1
                Case "Cancelados"
                    Estatus = "N"
                Case "Todos"
                    Estatus = ""
            End Select
        End If
        'Transferencias
        If ComboBox1.SelectedIndex = 1 Then
            Select Case ComboBox2.Text
                Case "Pendientes"
                    Estatus = "G"
                Case "Aplicados"
                    Estatus = "D"
                Case "Cancelados"
                    Estatus = "N"
                Case "Todos"
                    Estatus = ""
            End Select
        End If
        'Todos
        If ComboBox1.SelectedIndex = 2 Then
            Estatus = ""
            Entregado = 0
        End If
    End Sub

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        ErrorProvider1.Clear()
        If filterPeriodoDe.DateTime.Year <> filterPeriodoAl.DateTime.Year Then
            ErrorProvider1.SetError(filterPeriodoAl, "El periodo de tiempo tiene que pertenecer al mismo ejercicio")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_AnaliticoPorProveedorContable
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""

        ErrorProvider1.Clear()
        AsignaEstatusEntregado()

        Dim idservicio As Integer
        Dim idcompra As Integer

        If txtServicio.Text = "" Then
            idservicio = 0
        Else
            idservicio = Convert.ToInt32(txtServicio.Text)
        End If

        If txtCompra.Text = "" Then
            idcompra = 0
        Else
            idcompra = Convert.ToInt32(txtCompra.Text)
        End If

        Dim FiltroSQL As String = ""
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_AnaliticoPorProveedorContable", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", filterPeriodoDe.DateTime.Date))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", filterPeriodoAl.DateTime.Date))
        If FilterProveedor.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Proveedor", FilterProveedor.EditValue))
        End If

        If FilterProveedor.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Proveedor", ""))

        End If
        SQLComando.Parameters.Add(New SqlParameter("@FolioServicio", idservicio))
        SQLComando.Parameters.Add(New SqlParameter("@FolioCompra", idcompra))
        SQLComando.Parameters.Add(New SqlParameter("@Cancelados", chkCancel.Checked))
        'SQLComando.Parameters.Add(New SqlParameter("@Entregado", Entregado))
        'SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_AnaliticoPorProveedorContable")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_AnaliticoPorProveedorContable"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "ANALÍTICO POR PROVEEDOR CONTABLE"
            '.lblFechaRango.Text = ""
            .lblRptDescripcionFiltrado.Text = "Del " + filterPeriodoDe.Text + " Al: " + filterPeriodoAl.Text
            .lblTitulo.Text = "" 'Ejercicio del " + Year(filterPeriodoAl.EditValue).ToString
            .XrLabel1.Text = "" '"Polizas de la Fuente de Financiamiento: " + filterFuenteFinanciamiento.Text
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.XrPictureBox1.Image = pRPTCFGDatosEntes.LogoEnte
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            'If ChkAnual.Checked = False Then
            '.lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoDe.EditValue.Month) & " a " & MesLetra(filterPeriodoHasta.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString()    '"Del " & Primer & " al " & Ultimo
            'ElseIf ChkAnual.Checked = True Then
            '    .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            'End If



            '.lblRptTituloTipo.Text = "Concepto"
            '.lblRptnomClaves.Text = "Capítulo"
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & "Analítico por Proveedor Contable" & "'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With
        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default
    End Sub
    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterProveedor.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterProveedor.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by CLAVE ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoDe.DateTime = Now
        filterPeriodoAl.DateTime = Now
        ComboBox1.SelectedIndex = 2
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterProveedor.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_Proveedores", " Order by CLAVE ")
            .DisplayMember = "RazonSocial"
            .ValueMember = "IdProveedor"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        ComboBox1.SelectedIndex = -1
    End Sub
    Private Sub ComboBox1_SelectedIndexChanged(sender As System.Object, e As System.EventArgs) Handles ComboBox1.SelectedIndexChanged
        ComboBox2.Items.Clear()
        Select Case ComboBox1.Text
            Case "Cheques"
                ComboBox2.Enabled = True
                SimpleButton3.Enabled = True
                ComboBox2.Items.Add("No Generados")
                ComboBox2.Items.Add("Por Imprimir")
                ComboBox2.Items.Add("Impresos No Entregados")
                ComboBox2.Items.Add("Impresos Entregados")
                ComboBox2.Items.Add("Cancelados")
                ComboBox2.Items.Add("Todos")
                ComboBox2.SelectedIndex = 0
            Case "Transferencias Electrónicas"
                ComboBox2.Enabled = True
                SimpleButton3.Enabled = True
                ComboBox2.Items.Add("Pendientes")
                ComboBox2.Items.Add("Aplicados")
                ComboBox2.Items.Add("Cancelados")
                ComboBox2.Items.Add("Todos")
                ComboBox2.SelectedIndex = 0
            Case "Ambos"
                ComboBox2.Enabled = False
                SimpleButton3.Enabled = False
                ComboBox1.Text = ""
                'ComboBox2.Items.Add("No Generados")
                'ComboBox2.Items.Add("Por Imprimir")
                'ComboBox2.Items.Add("Impresos No Entregados")
                'ComboBox2.Items.Add("Impresos Entregados")
                'ComboBox2.Items.Add("Pendientes")
                'ComboBox2.Items.Add("Aplicados")
                'ComboBox2.Items.Add("Cancelados")
                'ComboBox2.Items.Add("Todos")

        End Select
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        ComboBox2.SelectedIndex = -1
        ComboBox2.Enabled = True
        SimpleButton3.Enabled = True
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        FilterProveedor.Properties.DataSource = Nothing
        FilterProveedor.Properties.NullText = ""
    End Sub

    Private Sub FilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles FilterProveedor.EditValueChanged
        '
    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton5.Click
        txtServicio.Text = ""
    End Sub

    Private Sub SimpleButton6_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton6.Click
        txtCompra.Text = ""
    End Sub

    Private Sub txtCompra_KeyPress(sender As System.Object, e As System.Windows.Forms.KeyPressEventArgs) Handles txtCompra.KeyPress
        If Asc(e.KeyChar) <> 13 AndAlso Asc(e.KeyChar) <> 8 AndAlso Not IsNumeric(e.KeyChar) Then
            MessageBox.Show("Solo se aceptan números")
            e.Handled = True
        End If
    End Sub

    Private Sub txtServicio_KeyPress(sender As System.Object, e As System.Windows.Forms.KeyPressEventArgs) Handles txtServicio.KeyPress
        If Asc(e.KeyChar) <> 13 AndAlso Asc(e.KeyChar) <> 8 AndAlso Not IsNumeric(e.KeyChar) Then
            MessageBox.Show("Solo se aceptan números")
            e.Handled = True
        End If
    End Sub
End Class