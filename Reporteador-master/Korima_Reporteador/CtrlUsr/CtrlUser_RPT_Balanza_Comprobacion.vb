Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Balanza_Comprobacion

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Balanza_Comprobacion()
        Dim printTool As New ReportPrintTool(reporte)

        '--- Armado de filtro
        Dim FiltroSQL As String = ""

        FiltroSQL &= "    Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & ""

        If RBTSaldoMayor0.Checked Then
            '" AND CargosSinFlujo>0 AND AbonosSinFlujo>0 AND TotalCargos>0 AND TotalAbonos>0
            FiltroSQL &= " AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0) "
        ElseIf RBTMovimientos.Checked Then
            ' CargosSinFlujo<>0 OR AbonosSinFlujo<>0 OR SaldoDeudor<>0 OR SaldoAcreedor<>0
            FiltroSQL &= " AND (TotalCargos <> 0 OR TotalAbonos <> 0) "
        End If
        If RBTMovimientoSaldoNOcero.Checked Then
            FiltroSQL &= " AND ((SaldoDeudor <> 0 or SaldoAcreedor <> 0) AND (TotalCargos<>0 OR TotalAbonos <> 0))"
        End If
        If RBTMovimientoOSaldoNOcero.Checked Then
            FiltroSQL &= " AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0 or TotalCargos <> 0 OR TotalAbonos <> 0)"
        End If
        If ChkMayor.Checked Then
            FiltroSQL &= " AND Financiero = 1"
        End If
        'If filterUnidadResponsabl.Text <> "" Then
        '    FiltroSQL &= " AND UnidadResponsable_Clave = '" & filterUnidadResponsable.Properties.KeyValue & "'"
        'End If

        'If filterPartida.Text <> "" Then
        '    FiltroSQL &= " AND PartPres_Clave = '" & filterPartida.Properties.KeyValue & "'"
        'End If


        'If filterProveedor.Text <> "" Then
        '    FiltroSQL &= " AND Proveedores_ID = '" & filterProveedor.Properties.KeyValue & "'"
        'End If


        Dim adapter As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Balanza_De_Comprobacion Where " & FiltroSQL & " Order by NumeroCuenta", cnnString)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.FillSchema(ds, SchemaType.Source)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "VW_RPT_K2_Balanza_De_Comprobacion"


        'subreporte 
        Dim adapterB As SqlClient.SqlDataAdapter
        adapterB = New SqlClient.SqlDataAdapter("SELECT SUM(CargosSinFlujo) as CargosSinFlujo ,SUM(AbonosSinFlujo)as AbonosSinFlujo ,SUM(totalcargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,SUM(SaldoDeudor)as SaldoDeudor,SUM(SaldoAcreedor)as SaldoAcreedor FROM VW_RPT_K2_Balanza_De_Comprobacion  " & " where Afectable=1 AND " & "    Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & "", cnnString)
        Dim dsB As New DataSet()
        dsB.EnforceConstraints = False
        adapterB.Fill(dsB, "VW_RPT_K2_Balanza_De_Comprobacion")
        reporte.XrSubreport1.ReportSource.DataSource = dsB
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterB
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Balanza_De_Comprobacion"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Reporte Balanza de Comprobacion"
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .lblFechaRango.Text = "Ejercicio " & filterPeriodoAl.Text & " Periodo " & filterPeriodoDe.Text
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Reporte Balanza de Comprobacion' ", New SqlConnection(cnnString))
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


End Class
