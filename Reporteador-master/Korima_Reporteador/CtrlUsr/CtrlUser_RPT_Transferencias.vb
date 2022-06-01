

Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_Transferencias
    Dim Entregado As Integer = 0
    Dim Estatus As String = ""
    Dim traspaso As Integer
    Dim Inversion As Integer

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


        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True





        If traspaso = 1 Then

            Dim reporte As New RPT_Traspasos

            Dim printTool As New ReportPrintTool(reporte)


            Dim strFiltro As String
            Dim SQLConexion As SqlConnection
            Dim SQLmConnStr As String = ""
            SQLmConnStr = cnnString
            strFiltro = ""

            ErrorProvider1.Clear()
            AsignaEstatusEntregado()

            Dim FiltroSQL As String = ""
            SQLConexion = New SqlConnection(SQLmConnStr)
            SQLConexion.Open()
            Dim SQLComando As New SqlCommand("SP_Traspaso", SQLConexion)

            SQLComando.CommandType = CommandType.StoredProcedure
            SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", filterPeriodoDe.DateTime.Date))
            SQLComando.Parameters.Add(New SqlParameter("@FechaFin", filterPeriodoAl.DateTime.Date))
            SQLComando.Parameters.Add(New SqlParameter("@CuentaBancaria", FilterCuenta.Text.Trim))
            SQLComando.Parameters.Add(New SqlParameter("@Reporte", 1))

            SQLComando.CommandTimeout = 999
            Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

            Dim ds As New DataSet()
            ds.EnforceConstraints = False

            adapter.Fill(ds, "SP_Traspaso")



            reporte.DataSource = ds
            reporte.DataAdapter = adapter
            reporte.DataMember = "RPT_TraspasosBancarios"




            Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
            Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
            pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
            '--- Llenar datos del ente
            Dim total As Double
            total = 0





            With reporte

                If ComboBox1.SelectedIndex = 0 Or ComboBox1.SelectedIndex = 1 Then

                    If (ComboBox2.SelectedItem <> Nothing And ComboBox2.Text <> "Todos") Then

                    End If
                End If

                If FilterCuenta.Text = "" Then

                    .lblSubtitulo.Visible = False
                Else

                    .lblSubtitulo.Visible = True
                End If
                .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
                .lblRptNombreReporte.Text = ""

                If FilterCuenta.Properties.KeyValue IsNot Nothing Then
                    Dim cmd2 As New SqlCommand("select top(1) C_Bancos.NombreBanco from C_Bancos JOIN C_CuentasBancarias ON C_cuentasBancarias.IdBanco=C_Bancos.Idbanco Where C_CuentasBancarias.CuentaBancaria='" + FilterCuenta.Text + "'", New SqlConnection(cnnString))

                    cmd2.Connection.Open()
                    Dim reader2 = cmd2.ExecuteScalar()
                    cmd2.Connection.Close()

                    .lblSubtitulo.Text = " TRASPASOS BANCARIOS "

                End If

                .lblSubtitulo.Text = " TRASPASOS BANCARIOS "

                Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Cheques y Transferencias Electronicas' ", New SqlConnection(cnnString))
                cmd.Connection.Open()
                Dim reader = cmd.ExecuteScalar()
                cmd.Connection.Close()

            End With
            PrintControl1.PrintingSystem = reporte.PrintingSystem
            reporte.CreateDocument()
            Me.Cursor = Cursors.Default



        Else

            Dim Inversionn As Integer
            Inversionn = 0


            Dim reporte As New RPT_Inversiones




            Dim printTool As New ReportPrintTool(reporte)

            Dim strFiltro As String
            Dim SQLConexion As SqlConnection
            Dim SQLmConnStr As String = ""
            SQLmConnStr = cnnString
            strFiltro = ""

            ErrorProvider1.Clear()
            AsignaEstatusEntregado()

            Dim FiltroSQL As String = ""
            SQLConexion = New SqlConnection(SQLmConnStr)
            SQLConexion.Open()
            ' Dim SQLComando As New SqlCommand("SP_Inversion2", SQLConexion)
            Dim SQLComando As New SqlCommand("SP_Traspaso", SQLConexion)

            SQLComando.CommandType = CommandType.StoredProcedure
            SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", filterPeriodoDe.DateTime.Date))
            SQLComando.Parameters.Add(New SqlParameter("@FechaFin", filterPeriodoAl.DateTime.Date))
            SQLComando.Parameters.Add(New SqlParameter("@CuentaBancaria", FilterCuenta.Text.Trim))
            SQLComando.Parameters.Add(New SqlParameter("@Reporte", 2))



            SQLComando.CommandTimeout = 999
            Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

            Dim ds As New DataSet()
            ds.EnforceConstraints = False

            ' adapter.Fill(ds, "SP_Inversion2")
            adapter.Fill(ds, "SP_Traspaso")



            reporte.DataSource = ds
            reporte.DataAdapter = adapter
            reporte.DataMember = "RPT_TraspasosBancarios"




            Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
            Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
            pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
            '--- Llenar datos del ente
            Dim total As Double
            total = 0





            With reporte

                If ComboBox1.SelectedIndex = 0 Or ComboBox1.SelectedIndex = 1 Then

                    If (ComboBox2.SelectedItem <> Nothing And ComboBox2.Text <> "Todos") Then

                    End If
                End If

                If FilterCuenta.Text = "" Then

                    .lblSubtitulo.Visible = False
                Else

                    .lblSubtitulo.Visible = True
                End If
                .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
                .lblRptNombreReporte.Text = ""

                If FilterCuenta.Properties.KeyValue IsNot Nothing Then
                    Dim cmd2 As New SqlCommand("select top(1) C_Bancos.NombreBanco from C_Bancos JOIN C_CuentasBancarias ON C_cuentasBancarias.IdBanco=C_Bancos.Idbanco Where C_CuentasBancarias.CuentaBancaria='" + FilterCuenta.Text + "'", New SqlConnection(cnnString))

                    cmd2.Connection.Open()
                    Dim reader2 = cmd2.ExecuteScalar()
                    cmd2.Connection.Close()

                    .lblSubtitulo.Text = " INVERSIONES BANCARIAS "

                End If
                .lblSubtitulo.Text = " INVERSIONES BANCARIAS "


                Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Cheques y Transferencias Electronicas' ", New SqlConnection(cnnString))
                cmd.Connection.Open()
                Dim reader = cmd.ExecuteScalar()
                cmd.Connection.Close()

            End With
            PrintControl1.PrintingSystem = reporte.PrintingSystem
            reporte.CreateDocument()
            Me.Cursor = Cursors.Default



        End If







    End Sub












    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuenta.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" C_Bancos.IdBanco=C_CuentasBancarias.IdBanco ", 0, " C_CuentasBancarias,C_Bancos ", " Order by NombreBanco,CuentaBancaria ")
            .DisplayMember = "CuentaBancaria"
            .ValueMember = "CuentaBancaria"
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
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" C_Bancos.IdBanco=C_CuentasBancarias.IdBanco ", 0, " C_CuentasBancarias,C_Bancos ", " Order by NombreBanco,CuentaBancaria ")
            .DisplayMember = "CuentaBancaria"
            .ValueMember = "CuentaBancaria"
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
        FilterCuenta.Properties.DataSource = Nothing
        FilterCuenta.Properties.NullText = ""
    End Sub

    Private Sub FilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles FilterCuenta.EditValueChanged
        '
    End Sub

    Private Sub CheckBox1_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles Traspasos.CheckedChanged
        'traspaso = 1
        'Inversion = 0

        If Traspasos.Checked = True Then
            traspaso = 1
            Inversion = 0
            CheckBox2.Checked = False
        End If
        


    End Sub

    Private Sub CheckBox2_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles CheckBox2.CheckedChanged
        'traspaso = 0
        'Inversion = 1

        If CheckBox2.Checked = True Then
            Traspasos.Checked = False
            traspaso = 0
            Inversion = 1
        End If

    End Sub
End Class





