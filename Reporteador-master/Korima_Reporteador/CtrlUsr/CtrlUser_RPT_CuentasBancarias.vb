Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_CuentasBancarias
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
        Dim reporte As New RPT_CuentasBancarias
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
        Dim SQLComando As New SqlCommand("SP_RPT_K2_CuentasBancarias", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterEjercicio.Text))
        SQLComando.Parameters.Add(New SqlParameter("@Periodo", filterPeriodo.Text))
        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_CuentasBancarias")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_CuentasBancarias"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Relación de cuentas bancarias productivas específicas' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ultimo As Date = New DateTime(filterPeriodo.Time.Year, filterPeriodo.Time.Month, 1)
        ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)

            With reporte
                .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
                .lblRptNombreReporte.Text = "Relacion de Cuentas Bancarias utilizadas en el Ejercicio"
                .lblRptDescripcionFiltrado.Text = "Al Ejercicio: " + filterEjercicio.Text
                .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
                .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
                .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
                .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
                .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
                .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
                .lblSubtitulo.Text = ""
                .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            .LabelSaldoAl.Text = "Saldo al " & ultimo.ToString("dd") & " " & MesLetra(filterPeriodo.EditValue.Month) & " de " & filterEjercicio.EditValue.Year.ToString()

                Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Relación de cuentas bancarias productivas específicas' ", New SqlConnection(cnnString))
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
        filterEjercicio.Time = DateTime.Now
        filterPeriodo.Time = DateTime.Now
    End Sub

    Private Sub Chk_Virtual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub
End Class