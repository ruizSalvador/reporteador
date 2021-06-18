﻿Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_TransferenciasPresupuestales
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
        Dim reporte As New RPT_TransferenciasPresupuestales
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_TransferenciasPresupuestales", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        'Dim no As Int32 = DirectCast(cbTipo.SelectedItem, KeyValuePair(Of Int32, String)).Key
        'Dim val As String = DirectCast(cbTipo.SelectedItem, KeyValuePair(Of Int32, String)).Value

        SQLComando.Parameters.Add(New SqlParameter("@FechaInicio", Convert.ToDateTime(filterPeriodoDe.Text))) 
        SQLComando.Parameters.Add(New SqlParameter("@FechaFin", Convert.ToDateTime(filterPeriodoAl.Text)))
        SQLComando.Parameters.Add(New SqlParameter("@Tipo", DirectCast(cbTipo.SelectedItem, KeyValuePair(Of String, String)).Key))
        SQLComando.CommandTimeout = 99999

        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_TransferenciasPresupuestales")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_TransferenciasPresupuestales"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Transferencias Presupuestales"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblRptDescripcionFiltrado.Text = "Transferencias del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            .lblSubtitulo.Text = ""
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            .lblTitulo.Text = ""

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Transferencias Presupuestales' ", New SqlConnection(cnnString))
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

        Dim cbSource = New Dictionary(Of String, String)
        cbSource.Add("T", "Todas")
        cbSource.Add("A", "Transferencias")
        cbSource.Add("C", "Canceladas")
        cbSource.Add("R", "Recalendarizaciones")

        cbTipo.DataSource = New BindingSource(cbSource, Nothing)
        cbTipo.DisplayMember = "Value"
        cbTipo.ValueMember = "Key"


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
End Class