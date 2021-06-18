Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Balanza_Comprobacion_Acumulada

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_Balanza_Comprobacion_Acumulada()
        Dim printTool As New ReportPrintTool(reporte)
        If (LUE_RangoDe.Text = "" And LUE_RangoA.Text <> "") Or (LUE_RangoDe.Text <> "" And LUE_RangoA.Text = "") Then
            Me.Cursor = Cursors.Default
            MsgBox("Debe completar el rango de cuentas, o dejarlo en blanco")
            Exit Sub
        End If
        Dim cmd2 As New SqlCommand("EXEC SP_InsertaCuentasSinValor  " + filterPeriodoDe.Text + "," + filterPeriodoAl.Text, New SqlConnection(cnnString))
        cmd2.Connection.Open()
        Dim reader2 = cmd2.ExecuteScalar()
        cmd2.Connection.Close()
        '----
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()

        Dim SQLComando As New SqlCommand("SP_RPT_K2_BalanzaAcumulada", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        SQLComando.CommandTimeout = 0
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@PeriodoIncial", filterPeriodoDe.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@PeriodoFinal", TEPeriodoAl.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@Saldo", RBTSaldoMayor0.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Movimientos", RBTMovimientos.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Mayor", ChkMayor.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@DeOrden", ChkDeOrden.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@SaldoYMovimientos", RBTMovimientoSaldoNOcero.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@SaldoOMovimientos", RBTMovimientoOSaldoNOcero.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@CuentaInicio", LUE_RangoDe.Text.Replace("-", "")))
        SQLComando.Parameters.Add(New SqlParameter("@CuentaFin", LUE_RangoA.Text.Replace("-", "")))
        'SQLComando.Parameters.Add(New SqlParameter("@CuentaInicio", DBNull.Value))
        'SQLComando.Parameters.Add(New SqlParameter("@CuentaFin", DBNull.Value))
        SQLComando.Parameters.Add(New SqlParameter("@Suma", 0))
        SQLComando.Parameters.Add(New SqlParameter("@CtoNivel", Chk4Nivel.Checked))



        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)
        adapter.SelectCommand.CommandTimeout = 0
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_BalanzaAcumulada")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_BalanzaAcumulada"

        'SQLComando.Dispose()
        'SQLConexion.Close()

        'subreporte 

        Dim SQLComando2 As New SqlCommand("SP_RPT_K2_BalanzaAcumulada", SQLConexion)
        SQLComando2.CommandType = CommandType.StoredProcedure
        SQLComando2.CommandTimeout = 0
        '--- Parametros IN
        SQLComando2.Parameters.Add(New SqlParameter("@PeriodoIncial", filterPeriodoDe.Time.Month))
        SQLComando2.Parameters.Add(New SqlParameter("@PeriodoFinal", TEPeriodoAl.Time.Month))
        SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", filterPeriodoAl.Time.Year))
        SQLComando2.Parameters.Add(New SqlParameter("@Saldo", RBTSaldoMayor0.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@Movimientos", RBTMovimientos.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@Mayor", ChkMayor.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@DeOrden", ChkDeOrden.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@SaldoYMovimientos", RBTMovimientoSaldoNOcero.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@SaldoOMovimientos", RBTMovimientoOSaldoNOcero.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@CuentaInicio", LUE_RangoDe.Text.Replace("-", "")))
        SQLComando2.Parameters.Add(New SqlParameter("@CuentaFin", LUE_RangoA.Text.Replace("-", "")))
        SQLComando2.Parameters.Add(New SqlParameter("@Suma", 1))
        SQLComando2.Parameters.Add(New SqlParameter("@CtoNivel", Chk4Nivel.Checked))

        Dim adapterB As SqlClient.SqlDataAdapter
        adapterB = New SqlClient.SqlDataAdapter(SQLComando2)
        adapterB.SelectCommand.CommandTimeout = 0
        Dim dsB As New DataSet()
        dsB.EnforceConstraints = False
        adapterB.Fill(dsB, "SP_RPT_K2_BalanzaAcumulada")
        reporte.XrSubreport1.ReportSource.DataSource = dsB
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterB
        reporte.XrSubreport1.ReportSource.DataMember = "SP_RPT_K2_BalanzaAcumulada"

        Dim dt As DataTable
        dt = dsB.Tables(0)

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "Balanza de Comprobación"
            .lblFechaRango.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblFechaRango.Text = "Ejercicio " & filterPeriodoAl.Text & " Periodo del " & filterPeriodoDe.Text & " al " & TEPeriodoAl.Text
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            If (IIf(IsDBNull(dt.Rows(0).Item(0)), 0, dt.Rows(0).Item(0)) <> IIf(IsDBNull(dt.Rows(0).Item(1)), 0, dt.Rows(0).Item(1))) Or (IIf(IsDBNull(dt.Rows(0).Item(2)), 0, dt.Rows(0).Item(2)) <> IIf(IsDBNull(dt.Rows(0).Item(3)), 0, dt.Rows(0).Item(3))) Or (IIf(IsDBNull(dt.Rows(0).Item(4)), 0, dt.Rows(0).Item(4)) <> IIf(IsDBNull(dt.Rows(0).Item(5)), 0, dt.Rows(0).Item(5))) Then
                .XrLabel3.Visible = True
            End If
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Balanza de Comprobación Acumulada' ", New SqlConnection(cnnString))
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
        TEPeriodoAl.EditValue = Now
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
