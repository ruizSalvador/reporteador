Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_SolicitudesPago
    Private Function MesLetra(ByVal Mes As Integer) As String
        Select Case Mes
            Case 1
                Return "Enero"
            Case 2
                Return "Febrero"
            Case 3
                Return "Marzo"
            Case 4
                Return "Abril"
            Case 5
                Return "Mayo"
            Case 6
                Return "Junio"
            Case 7
                Return "Julio"
            Case 8
                Return "Agosto"
            Case 9
                Return "Septiembre"
            Case 10
                Return "Octubre"
            Case 11
                Return "Noviembre"
            Case 12
                Return "Diciembre"
            Case Else
                Return ""
        End Select
    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_SolicitudesPago
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_SolicitudesPago", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        'SQLComando.Parameters.Add(New SqlParameter("@CuentaBancaria", FilterCuenta.Text))
        SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", Convert.ToDateTime(filterPeriodoDe.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", Convert.ToDateTime(filterPeriodoAl.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@IdTipo", Convert.ToInt32(cmbTipoServicio.SelectedValue)))
        SQLComando.CommandTimeout = 99999

        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_SolicitudesPago")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_SolicitudesPago"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte de Solicitudes de Pago"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblRptDescripcionFiltrado.Text = filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            '.lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            .lblTitulo.Text = ""

            '******* Firmas ******
            Dim adapterC As SqlClient.SqlDataAdapter
            adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = " & "'" & "Reporte de Solicitudes de Pago" & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
            Dim dsC As New DataSet()
            dsC.EnforceConstraints = False
            adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
            reporte.Firmas.ReportSource.DataSource = dsC
            reporte.Firmas.ReportSource.DataAdapter = adapterC
            reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas2"

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Reporte de Solicitudes de Pago' ", New SqlConnection(cnnString))
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

        Dim comboSource As New Dictionary(Of String, String)()
        comboSource.Add("0", "")
        comboSource.Add("3", "Servicios")
        comboSource.Add("4", "Honorarios")
        comboSource.Add("5", "Obra")
        comboSource.Add("6", "Deuda")
        comboSource.Add("7", "Subsidios")
        comboSource.Add("2", "Activos")
        comboSource.Add("1", "Consumibles")

        cmbTipoServicio.DataSource = New BindingSource(comboSource, Nothing)
        cmbTipoServicio.DisplayMember = "Value"
        cmbTipoServicio.ValueMember = "Key"

        '--Llenar listas
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CuentasBancarias", " Order by CuentaBancaria ")
            .DisplayMember = "CuentaBancaria"
            .ValueMember = "CuentaBancaria"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        FilterCuenta.Properties.DataSource = Nothing
        FilterCuenta.Properties.NullText = ""
    End Sub

    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuenta.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CuentasBancarias", " Order by CuentaBancaria ")
            .DisplayMember = "CuentaBancaria"
            .ValueMember = "CuentaBancaria"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterCuentaAfectable_EditValueChanged(sender As System.Object, e As System.EventArgs)
        FilterCuenta.Enabled = False
        SimpleButton4.Enabled = False
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        cmbTipoServicio.SelectedIndex = 0
    End Sub
End Class