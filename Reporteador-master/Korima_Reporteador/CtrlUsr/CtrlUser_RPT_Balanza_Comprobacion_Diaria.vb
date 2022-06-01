Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Balanza_Comprobacion_Diaria

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Balanza_Comprobacion_Diaria()
        Dim printTool As New ReportPrintTool(reporte)
        If (LUE_RangoDe.Text = "" And LUE_RangoA.Text <> "") Or (LUE_RangoDe.Text <> "" And LUE_RangoA.Text = "") Then
            Me.Cursor = Cursors.Default
            MsgBox("Debe completar el rango de cuentas, o dejarlo en blanco")
            Exit Sub
        End If
        'Dim cmd2 As New SqlCommand("EXEC SP_InsertaCuentasSinValor  " + filterPeriodoDe.Text + "," + filterPeriodoAl.Text, New SqlConnection(cnnString))
        'cmd2.Connection.Open()
        'Dim reader2 = cmd2.ExecuteScalar()
        'cmd2.Connection.Close()
        Dim datePar As New Date
        Dim datePar2 As New Date
        datePar = Convert.ToDateTime(filterDay.Text)
        datePar2 = Convert.ToDateTime(filterDay2.Text)
        'Dim Str As String = "EXEC SP_RPT_K2_Balanza_Diaria  " + "'" + datePar.ToString("yyyy-MM-dd") + "'"
        Dim cmd2 As New SqlCommand("EXEC SP_RPT_K2_Balanza_Diaria  " + "'" + datePar.ToString("yyyy-MM-dd") + "'", New SqlConnection(cnnString))
        cmd2.Connection.Open()
        Dim reader2 = cmd2.ExecuteScalar()
        cmd2.Connection.Close()

        '--- Armado de filtro
        Dim FiltroSQL As String = ""
        Dim FiltroSQL2 As String = ""

        FiltroSQL &= "1=1" '"    Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & ""
        FiltroSQL2 &= "1=1" '"    Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & ""

        If RBTSaldoMayor0.Checked Then
            FiltroSQL &= " AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0) "
            FiltroSQL2 &= " AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0) "
        ElseIf RBTMovimientos.Checked Then
            FiltroSQL &= " AND (TotalCargos <> 0 OR TotalAbonos <> 0) "
            FiltroSQL2 &= " AND (TotalCargos <> 0 OR TotalAbonos <> 0) "
        End If
        If RBTMovimientoSaldoNOcero.Checked Then
            FiltroSQL &= " AND ((SaldoDeudor <> 0 or SaldoAcreedor <> 0) AND (TotalCargos<>0 OR TotalAbonos <> 0))"
            FiltroSQL2 &= " AND ((SaldoDeudor <> 0 or SaldoAcreedor <> 0) AND (TotalCargos<>0 OR TotalAbonos <> 0))"
        End If
        If RBTMovimientoOSaldoNOcero.Checked Then
            FiltroSQL &= " AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0 or TotalCargos <> 0 OR TotalAbonos <> 0)"
            FiltroSQL2 &= " AND (SaldoDeudor <> 0 or SaldoAcreedor <> 0 or TotalCargos <> 0 OR TotalAbonos <> 0)"
        End If
        If ChkMayor.Checked Then
            FiltroSQL &= " AND Financiero = 1"
            ' aqui no se asigna filtrosql2 para que no afecte los totales
        End If
        If ChkDeOrden.Checked = False Then
            FiltroSQL &= " AND NumeroCuenta NOT LIKE '8%' AND NumeroCuenta NOT LIKE '7%' AND NumeroCuenta NOT LIKE '9%' "
            FiltroSQL2 &= " AND NumeroCuenta NOT LIKE '8%' AND NumeroCuenta NOT LIKE '7%' AND NumeroCuenta NOT LIKE '9%' "
        End If
        If LUE_RangoA.Text <> "" And LUE_RangoDe.Text <> "" Then
            FiltroSQL &= "AND CuentaNumero Between " + LUE_RangoDe.Text.Replace("-", "") + " AND " + LUE_RangoA.Text.Replace("-", "")
            FiltroSQL2 &= "AND CuentaNumero Between " + LUE_RangoDe.Text.Replace("-", "") + " AND " + LUE_RangoA.Text.Replace("-", "")

        End If

        
        Dim adapter As New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Balanza_De_Comprobacion_Diaria Where " & FiltroSQL & " Order by NumeroCuenta", cnnString)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.FillSchema(ds, SchemaType.Source)
        reporte.DataSource = ds

        reporte.DataAdapter = adapter
        reporte.DataMember = "VW_RPT_K2_Balanza_De_Comprobacion_Diaria"

        Dim strFiltroSubreporte = "SELECT SUM(CargosSinFlujo) as CargosSinFlujo ,SUM(AbonosSinFlujo)as AbonosSinFlujo ,SUM(totalcargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,SUM(SaldoDeudor)as SaldoDeudor,SUM(SaldoAcreedor)as SaldoAcreedor FROM VW_RPT_K2_Balanza_De_Comprobacion_Diaria WHERE " & FiltroSQL2 & " and Afectable=1 "
        '"SELECT SUM(CargosSinFlujo) as CargosSinFlujo ,SUM(AbonosSinFlujo)as AbonosSinFlujo ,SUM(totalcargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,SUM(SaldoDeudor)as SaldoDeudor,SUM(SaldoAcreedor)as SaldoAcreedor FROM VW_RPT_K2_Balanza_De_Comprobacion  " & " where " & FiltroSQL & " AND Afectable=1 " ' AND " & "    Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & ""
        'If ChkMayor.Checked = True And (LUE_RangoA.Text = "" And LUE_RangoDe.Text = "") Then
        '    'strFiltroSubreporte = "SELECT SUM(CargosSinFlujo) as CargosSinFlujo ,SUM(AbonosSinFlujo)as AbonosSinFlujo ,SUM(totalcargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,SUM(SaldoDeudor)as SaldoDeudor,SUM(SaldoAcreedor)as SaldoAcreedor FROM VW_RPT_K2_Balanza_De_Comprobacion  " & " where " & FiltroSQL
        '    strFiltroSubreporte = "SELECT SUM(CargosSinFlujo) as CargosSinFlujo ,SUM(AbonosSinFlujo)as AbonosSinFlujo ,SUM(totalcargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,SUM(SaldoDeudor)as SaldoDeudor,SUM(SaldoAcreedor)as SaldoAcreedor FROM VW_RPT_K2_Balanza_De_Comprobacion WHERE Afectable=1 " & " AND   Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & ""
        'Else
        '    strFiltroSubreporte = "SELECT SUM(CargosSinFlujo) as CargosSinFlujo ,SUM(AbonosSinFlujo)as AbonosSinFlujo ,SUM(totalcargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,SUM(SaldoDeudor)as SaldoDeudor,SUM(SaldoAcreedor)as SaldoAcreedor FROM VW_RPT_K2_Balanza_De_Comprobacion WHERE Afectable=1 " & " AND   Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & ""
        '    'strFiltroSubreporte = "SELECT SUM(CargosSinFlujo) as CargosSinFlujo ,SUM(AbonosSinFlujo)as AbonosSinFlujo ,SUM(totalcargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,SUM(SaldoDeudor)as SaldoDeudor,SUM(SaldoAcreedor)as SaldoAcreedor FROM VW_RPT_K2_Balanza_De_Comprobacion  " & " where " & FiltroSQL & " AND Afectable=1 "

        'End If
        'If ChkDeOrden.Checked = False Then
        '    strFiltroSubreporte = "SELECT SUM(CargosSinFlujo) as CargosSinFlujo ,SUM(AbonosSinFlujo)as AbonosSinFlujo ,SUM(totalcargos) as TotalCargos, SUM(TotalAbonos) as TotalAbonos,SUM(SaldoDeudor)as SaldoDeudor,SUM(SaldoAcreedor)as SaldoAcreedor FROM VW_RPT_K2_Balanza_De_Comprobacion  " & " where " & FiltroSQL & " AND NumeroCuenta NOT LIKE '8%' " 'Afectable=1 AND " & "    Mes = " & Month(filterPeriodoDe.EditValue) & " And [Year] = " & Year(filterPeriodoAl.EditValue) & " AND NumeroCuenta NOT LIKE '8%' "
        'End If
        'subreporte 
        Dim adapterB As SqlClient.SqlDataAdapter
        adapterB = New SqlClient.SqlDataAdapter(strFiltroSubreporte, cnnString)
        Dim dsB As New DataSet()
        dsB.EnforceConstraints = False
        adapterB.Fill(dsB, "VW_RPT_K2_Balanza_De_Comprobacion_Diaria")
        reporte.XrSubreport1.ReportSource.DataSource = dsB
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterB
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Balanza_De_Comprobacion_Diaria"

        Dim dt As DataTable
        dt = dsB.Tables(0)

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Balanza de Comprobación Diaria"
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblFechaRango.Text = "Del " & datePar.ToString("dd-MM-yyyy") & "  Al " & datePar2.ToString("dd-MM-yyyy") '"Ejercicio " & filterPeriodoAl.Text & " Periodo " & filterPeriodoDe.Text
            .lblFechaRango.Text = datePar.ToString("dd-MM-yyyy")
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            If (IIf(IsDBNull(dt.Rows(0).Item(0)), 0, dt.Rows(0).Item(0)) <> IIf(IsDBNull(dt.Rows(0).Item(1)), 0, dt.Rows(0).Item(1))) Or (IIf(IsDBNull(dt.Rows(0).Item(2)), 0, dt.Rows(0).Item(2)) <> IIf(IsDBNull(dt.Rows(0).Item(3)), 0, dt.Rows(0).Item(3))) Or (IIf(IsDBNull(dt.Rows(0).Item(4)), 0, dt.Rows(0).Item(4)) <> IIf(IsDBNull(dt.Rows(0).Item(5)), 0, dt.Rows(0).Item(5))) Then
                .XrLabel3.Visible = True
            End If
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Balanza de Comprobacion' ", New SqlConnection(cnnString))
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
        filterDay.DateTime = Now
        filterDay2.DateTime = Now
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LUE_RangoDe.Properties
            .DataSource = ObjTempSQL2.List("Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        With LUE_RangoA.Properties
            .DataSource = ObjTempSQL2.List("Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub LUE_RangoDe_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles LUE_RangoDe.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LUE_RangoDe.Properties
            .DataSource = ObjTempSQL2.List("Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub LUE_RangoA_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles LUE_RangoA.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LUE_RangoA.Properties
            .DataSource = ObjTempSQL2.List("Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        LUE_RangoDe.Properties.DataSource = Nothing
    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton5.Click
        LUE_RangoA.Properties.DataSource = Nothing
    End Sub
End Class
