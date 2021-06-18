Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_AnaliticoDeLaDeuda

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
        ErrorProvider1.Clear()
        Dim reporte As New RPT_AnaliticoDeLaDeuda
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        Dim SP As String

        If ChkMiles.Checked = True Then
            SP = "SP_RPT_AnaliticoDeLaDeudaPublica"
            reporte.XrLabel1.Visible = True
        Else
            SP = "SP_RPT_AnaliticoDeLaDeudaPublicaSinMiles"
            reporte.XrLabel1.Visible = False
        End If

        '--- Armado de filtro
        'Dim FiltroSQL As String = ""

        'FiltroSQL &= "where Mes = " & Month(filterPeriodoDe.EditValue) & " AND [Year] = " & Year(filterPeriodoAl.EditValue)
        'If ChkMuestraNulos.Checked = False Then
        '    FiltroSQL = FiltroSQL & " AND (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0)"
        'End If

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand(SP, SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoDe.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Año", Year(filterPeriodoAl.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@MuestraVacios", ChkMuestraNulos.Checked))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, SP)
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = SP

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'subreporte 
        'Dim adapterB As SqlClient.SqlDataAdapter
        'adapterB = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_AnaliticoDelActivo_Total " & "where Mes = " & Month(filterPeriodoDe.EditValue) & " AND [Year] = " & Year(filterPeriodoAl.EditValue), cnnString)
        'Dim dsB As New DataSet()
        'dsB.EnforceConstraints = False
        'adapterB.Fill(dsB, "VW_RPT_K2_AnaliticoDelActivo_Total")
        'reporte.subreport1.ReportSource.DataSource = dsB
        'reporte.subreport1.ReportSource.DataAdapter = adapterB
        'reporte.subreport1.ReportSource.DataMember = "VW_RPT_K2_AnaliticoDelActivo_Total"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Analitico de la deuda pública' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        Dim primero As Date
        Dim ultimo As Date
        Dim grupoOrdenamiento As New DevExpress.XtraReports.UI.GroupField("Ordenamiento")
        Dim grupoDeudaPublica As New DevExpress.XtraReports.UI.GroupField("DeudaPublica")
        primero = filterPeriodoDe.Time.Date
        ultimo = filterPeriodoDe.Time.Date

        primero = primero.AddDays(-primero.Day + 1)
        ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre

            .lblRptNombreReporte.Text = "Analítico de la Deuda Pública"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .lblRptDescripcionFiltrado.Text = "Periodo: al " & ultimo.Day.ToString & " de " & MesLetra(Month(filterPeriodoDe.EditValue)) & " Del " & Year(filterPeriodoAl.EditValue).ToString
            .label16.Text = .label16.Text & " Periodo " & Month(filterPeriodoDe.EditValue).ToString
            .GroupHeader1.GroupFields.Add(grupoOrdenamiento)
            .GroupHeader1.GroupFields.Add(grupoDeudaPublica)
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Analitico de la deuda pública' ", New SqlConnection(cnnString))
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
        filterPeriodoDe.EditValue = Now
        filterPeriodoAl.EditValue = Now
    End Sub

    Private Sub LabelControl4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LabelControl4.Click

    End Sub

    Private Sub CheckBox1_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkMuestraNulos.CheckedChanged

    End Sub
End Class