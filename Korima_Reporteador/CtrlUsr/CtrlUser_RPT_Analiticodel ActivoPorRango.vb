Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_AnaliticodelactivoPorRango
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
        Dim reporte As New RPT_AnaliticodelActivoPorRango
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        '--- Armado de filtro
        'Dim FiltroSQL As String = ""
        'rango de Periodos queda como mejora para proxima version
        'FiltroSQL &= "where Mes >= " & Month(filterPeriodoDe.EditValue) & "AND Mes <= " & Month(filterPeriodoAl.EditValue) & " AND [Year] = " & Year(FilterEjercicio.EditValue)
        'FiltroSQL &= "where Mes = " & Month(filterPeriodoDe.EditValue) & " AND [Year] = " & Year(FilterEjercicio.EditValue)
        'If ChkMuestraNulos.Checked = False Then
        'FiltroSQL = FiltroSQL & " AND (CargosSinFlujo <> 0 OR TotalCargos <> 0 OR TotalAbonos <> 0 OR SaldoFinal <> 0 OR FlujoDelperiodo <> 0)"
        'End If
        'Dim vista As String
        'Dim vistaTotal As String
        'If ChkMiles.Checked = True Then
        'vista = " VW_RPT_K2_AnaliticoDelActivo "
        'vistaTotal = " VW_RPT_K2_AnaliticoDelActivo_Total "
        'reporte.XrLabel1.Visible = True
        'Else
        'vista = " VW_RPT_K2_AnaliticoDelActivoSinMiles "
        'vistaTotal = " VW_RPT_K2_AnaliticoDelActivo_TotalSinMiles "
        'reporte.XrLabel1.Visible = False
        'End If
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_AnaliticoActivoPorRango", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.Parameters.Add(New SqlParameter("@Miles", ChkMiles.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Totales", 0))
        SQLComando.Parameters.Add(New SqlParameter("@PeriodoFinal", filterPeriodoAl.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", FilterEjercicio.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@MostarSinSaldo", ChkMuestraNulos.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@PeriodoInicial", filterPeriodoDe.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Redondeo", chkRedondeo.Checked))

        SQLComando.CommandTimeout = 999
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)



        'Dim adapter As SqlClient.SqlDataAdapter
        'adapter = New SqlClient.SqlDataAdapter("SELECT * FROM " & vista & FiltroSQL & " ORDER BY NumeroCuenta ", cnnString)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_AnaliticoActivo")
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_AnaliticoActivo"

        'subreporte 

        Dim SQLComando2 As New SqlCommand("SP_RPT_K2_AnaliticoActivo", SQLConexion)
        SQLComando2.CommandType = CommandType.StoredProcedure
        SQLComando2.Parameters.Add(New SqlParameter("@Miles", ChkMiles.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@Totales", 1))
        SQLComando2.Parameters.Add(New SqlParameter("@Periodo", filterPeriodoDe.Time.Month))
        SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", FilterEjercicio.Time.Year))
        SQLComando2.Parameters.Add(New SqlParameter("@MostarSinSaldo", ChkMuestraNulos.Checked))
        SQLComando2.CommandTimeout = 999
        Dim adapterB As New SqlClient.SqlDataAdapter(SQLComando2)

        'adapterB = New SqlClient.SqlDataAdapter("SELECT * FROM " & vistaTotal & " where Mes = " & Month(filterPeriodoDe.EditValue) & " AND [Year] = " & Year(FilterEjercicio.EditValue), cnnString)
        Dim dsB As New DataSet()
        dsB.EnforceConstraints = False
        adapterB.Fill(dsB, "SP_RPT_K2_AnaliticoActivo")
        reporte.subreport1.ReportSource.DataSource = dsB
        reporte.subreport1.ReportSource.DataAdapter = adapterB
        reporte.subreport1.ReportSource.DataMember = "SP_RPT_K2_AnaliticoActivo"

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Analitico del activo por Rango' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim lastDay As DateTime = (New DateTime(Year(FilterEjercicio.EditValue), Month(filterPeriodoAl.EditValue), 1))

        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .XrLabel1.Visible = ChkMiles.Checked
            .lblRptNombreReporte.Text = "Estado Analitico del Activo"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            'rango de Periodos queda como mejora para proxima version
            '.lblRptDescripcionFiltrado.Text = "Periodo:  De " & MesLetra(Month(filterPeriodoDe.EditValue)) & " a " & MesLetra(Month(filterPeriodoAl.EditValue)) & " Del " & Year(filterPeriodoAl.EditValue).ToString
            .lblRptDescripcionFiltrado.Text = "Del 01/" + filterPeriodoDe.Text + "/" + FilterEjercicio.Time.Year.ToString + " Al " + lastDay.AddMonths(1).AddDays(-1).ToString("dd/MM/yyyy") '"Periodo: " & MesLetra(Month(filterPeriodoDe.EditValue)) & " Del " & Year(FilterEjercicio.EditValue).ToString
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Analitico del activo' ", New SqlConnection(cnnString))
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
        FilterEjercicio.EditValue = Now
    End Sub
End Class