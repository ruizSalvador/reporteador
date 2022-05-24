Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_PolizaAuxiliarMayor
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
        If (srchRangoDe.Text = "" And srchRangoA.Text <> "") Or (srchRangoDe.Text <> "" And srchRangoA.Text = "") Then
            MessageBox.Show("Debe seleccionar ambos rangos", "Información", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_AuxiliarMayor
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""
        Dim i As Integer
        i = srchFilterCuenta.Properties.View.GetFocusedRowCellValue("Nivel")

        ErrorProvider1.Clear()
        If (srchFilterCuenta.Text <> "") Then
            If srchFilterCuenta.Properties.View.GetFocusedRowCellValue("Nivel") = 0 Then
                strFiltro = strFiltro & srchFilterCuenta.Text.Substring(0, 1)
            ElseIf srchFilterCuenta.Properties.View.GetFocusedRowCellValue("Nivel") = 1 Then
                strFiltro = strFiltro & srchFilterCuenta.Text.Substring(0, 2)
            ElseIf srchFilterCuenta.Properties.View.GetFocusedRowCellValue("Nivel") = 2 Then
                strFiltro = strFiltro & srchFilterCuenta.Text.Substring(0, 3)
            ElseIf srchFilterCuenta.Properties.View.GetFocusedRowCellValue("Nivel") = 3 Then
                strFiltro = strFiltro & srchFilterCuenta.Text.Substring(0, 4)
            ElseIf srchFilterCuenta.Properties.View.GetFocusedRowCellValue("Nivel") = 4 Then
                strFiltro = strFiltro & srchFilterCuenta.Text.Substring(0, 5)
            Else 'If filterProveedor1.Properties.KeyValue = 5 Then
                strFiltro = srchFilterCuenta.Text

            End If
        End If


        Dim FiltroSQL As String = ""
        'Se limita el funcionamiento a un solo mes, solo por esta version
        'FiltroSQL &= "Where month(fecha)>= " & filterPeriodoDe.Time.Month & " and month(fecha)<= " & filterPeriodoAl.Time.Month & " and YEAR(fecha)= " & FilterEjercicio.Time.Year
        'FiltroSQL &= " AND Mes >= " & filterPeriodoDe.Time.Month & " AND Mes <= " & filterPeriodoAl.Time.Month & " AND [Year] = " & FilterEjercicio.Time.Year
        'FiltroSQL &= "Where month(fecha)= " & filterPeriodoDe.Time.Month & " and YEAR(fecha)= " & FilterEjercicio.Time.Year
        'FiltroSQL &= " AND Mes = " & filterPeriodoDe.Time.Month & " AND [Year] = " & FilterEjercicio.Time.Year

        'If FilterCuenta.Text <> "" Then
        '    FiltroSQL &= " AND (NumeroCuentaContable = '" & FilterCuenta.Text & "'" & " OR CuentaAcumulacion LIKE " & "'" & strFiltro & "%')"
        'End If
        'If FilterCuentaAfectable.Text.Trim <> "" Then
        '    FiltroSQL &= " AND NumeroCuentaContable = '" & FilterCuentaAfectable.Text & "'"
        'End If
        'If CheckBox1.Checked = False Then
        '    FiltroSQL &= " AND (ImporteCargo<>0 or ImporteAbono<>0 or SaldoFila <> 0 or SaldoInicial <> 0)"
        'End If
        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_AuxiliarMayor", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        If srchFilterCuenta.Text.Trim <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@NumeroCuenta", ""))
            SQLComando.Parameters.Add(New SqlParameter("@CuentaAcumulable", strFiltro))
        End If

        If srchFilterCuentaAfectable.Text.Trim <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@NumeroCuenta", srchFilterCuentaAfectable.Text.Trim))
            SQLComando.Parameters.Add(New SqlParameter("@CuentaAcumulable", srchFilterCuentaAfectable.Text.Trim))
        End If

        If srchFilterCuentaAfectable.Text.Trim = "" And srchFilterCuenta.Text.Trim = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@NumeroCuenta", ""))
            SQLComando.Parameters.Add(New SqlParameter("@CuentaAcumulable", ""))
        End If

        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", FilterEjercicio.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@MesInicio", filterPeriodoDe.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@MesFin", filterPeriodoAl.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@MuestraVacios", CheckBox1.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@CuentaInicio", IIf(srchRangoDe.Text.Length > 0, srchRangoDe.Text, "")))
        SQLComando.Parameters.Add(New SqlParameter("@CuentaFin", IIf(srchRangoA.Text.Length > 0, srchRangoA.Text, "")))
        SQLComando.Parameters.Add(New SqlParameter("@MuestraSinSaldo", CheckBox3.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@IdCuenta", IIf(srchFilterCuentaAfectable.Text.Length > 0, Convert.ToInt32(srchFilterCuentaAfectable.EditValue), 0)))

        'SQLComando.CommandTimeout = 999999995
        SQLComando.CommandTimeout = 0

        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)
        'adapter = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_AuxiliarDeMayor " & FiltroSQL & " ORDER BY NumeroCuentaContable,Fecha", cnnString)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_AuxiliarMayor")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_AuxiliarMayor"

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        Dim total As Double
        total = 0
        With reporte
            If CheckBox2.Checked Then
                .XrPageBreak1.Visible = False

            Else
                Dim summary As New XRSummary()
                summary.Func = SummaryFunc.RunningSum
                summary.Running = SummaryRunning.Page
                summary.IgnoreNullValues = True
                summary.FormatString = "{0:n2}"
                Dim summary2 As New XRSummary()
                summary2.Func = SummaryFunc.RunningSum
                summary2.Running = SummaryRunning.Page
                summary2.IgnoreNullValues = True
                summary2.FormatString = "{0:n2}"
                .label14.Summary = summary
                .label15.Summary = summary2
            End If
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = "AUXILIAR DE MAYOR."

            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            'Se limita la funcionalidad a un solo mes solo por esta version
            '.lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoDe.Time.Month) & " del " & filterPeriodoDe.Time.Year.ToString & " a " & MesLetra(filterPeriodoAl.Time.Month) & " del " & filterPeriodoAl.Time.Year.ToString
            '.lblSubtitulo.Text = "Ejercicio del " & filterPeriodoAl.Time.Year.ToString
            .lblRptDescripcionFiltrado.Text = "Periodo: " & MesLetra(filterPeriodoDe.Time.Month) & " a " & MesLetra(filterPeriodoAl.Time.Month) & " del " & FilterEjercicio.Time.Year.ToString
            If filterPeriodoDe.Time.Month = filterPeriodoAl.Time.Month Then
                .lblRptDescripcionFiltrado.Text = "Periodo: " & MesLetra(filterPeriodoDe.Time.Month) & " del " & FilterEjercicio.Time.Year.ToString
            End If

            If srchFilterCuenta.Text = "" Then
                '.XrLblTotCargo.Visible = False
                '.XrLabel20.Visible = False
                '.XrLabel14.Visible = False
                '.XrLabel12.Visible = False
                .XrLabel9.Visible = False
                .XrLabel21.Visible = False
                .XrLabel22.Visible = False
                ''.XrLabel23.Visible = False
                ''.XrLabel22.Visible = False

                .XrLabel14.Visible = False
                .XrLblTotCargo.Visible = False
                .XrLabel20.Visible = False
                .XrLabel12.Visible = False
            Else
                '.XrLblTotCargo.Visible = True
                '.XrLabel20.Visible = True
                '.XrLabel14.Visible = True
                '.XrLabel12.Visible = True
                .XrLabel9.Visible = True
                .XrLabel21.Visible = True
                .XrLabel22.Visible = True
                ''.XrLabel23.Visible = True
                ''.XrLabel22.Visible = True

                .XrLabel14.Visible = True
                .XrLblTotCargo.Visible = True
                .XrLabel20.Visible = True
                .XrLabel12.Visible = True
            End If

            .lblSubtitulo.Text = "Ejercicio del " & FilterEjercicio.Time.Year.ToString
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Auxiliar de Mayor' ", New SqlConnection(cnnString))
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
        filterPeriodoDe.Time = Now
        filterPeriodoAl.Time = Now
        FilterEjercicio.Time = Now
        CheckBox2.Text = "Sin saltos de pagina" + vbCrLf + "(SubTotales por cuenta)"
        '--Llenar listas
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With srchFilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '____0-00000' or numerocuenta like '____0-000000' or numerocuenta like '_____0-000000' or numerocuenta like '_____0-00000'", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
        With srchFilterCuentaAfectable.Properties
            '.DataSource = ObjTempSQL2.List(" nivel >= 4", 0, "C_Contable", " Order by NumeroCuenta ")
            .DataSource = ObjTempSQL2.List(" Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "IdCuentaContable"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
        With srchRangoDe.Properties

            .DataSource = ObjTempSQL2.List("Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
        With srchRangoA.Properties

            .DataSource = ObjTempSQL2.List("Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With

    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        'srchFilterCuenta.Properties.DataSource = Nothing
        'srchFilterCuenta.Properties.NullText = ""
        srchFilterCuenta.Text = ""
        srchFilterCuentaAfectable.Enabled = True
        SimpleButton2.Enabled = True

        CheckBox1.Checked = False
        CheckBox1.Enabled = True
        CheckBox3.Enabled = True

        'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        'With srchFilterCuenta.Properties
        '    .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '____0-00000' or numerocuenta like '____0-000000' or numerocuenta like '_____0-000000'", 0, "C_Contable", " Order by NumeroCuenta ")
        '    .DisplayMember = "NumeroCuenta"
        '    .ValueMember = "NumeroCuenta"
        '    '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    '.ShowHeader = True
        'End With
        'srchFilterCuenta.Text = ""

        If srchFilterCuentaAfectable.Text = "" Then
            srchRangoA.Enabled = True
            srchRangoDe.Enabled = True
            SimpleButton3.Enabled = True
            SimpleButton5.Enabled = True
        End If

    End Sub

    'Private Sub srchFilterCuenta_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchFilterCuenta.GotFocus

    '    Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    '    With srchFilterCuenta.Properties
    '        .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '____0-00000' or numerocuenta like '____0-000000' or numerocuenta like '_____0-000000'", 0, "C_Contable", " Order by NumeroCuenta ")
    '        .DisplayMember = "NumeroCuenta"
    '        .ValueMember = "NumeroCuenta"
    '        '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '        .NullText = ""
    '        '.ShowHeader = True
    '    End With

    'End Sub
    Private Sub srchFilterCuentaAfectable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchFilterCuentaAfectable.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With srchFilterCuentaAfectable.Properties
            '.DataSource = ObjTempSQL2.List(" nivel >= 4", 0, "C_Contable", " Order by NumeroCuenta ")
            .DataSource = ObjTempSQL2.List(" Afectable =1 and Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "IdCuentaContable"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
    End Sub

    Private Sub srchFilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles srchFilterCuenta.EditValueChanged
        srchFilterCuentaAfectable.Enabled = False
        SimpleButton2.Enabled = False
        'lookups inferiores
        srchRangoA.Enabled = False
        srchRangoDe.Enabled = False
        SimpleButton3.Enabled = False
        SimpleButton5.Enabled = False
        'CheckBox1.Checked = True
        'CheckBox1.Enabled = False
    End Sub

    Private Sub srchFilterCuentaAfectable_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles srchFilterCuentaAfectable.EditValueChanged
        srchFilterCuenta.Enabled = False
        SimpleButton4.Enabled = False
        'lookups inferiores
        srchRangoA.Enabled = False
        srchRangoDe.Enabled = False
        SimpleButton3.Enabled = False
        SimpleButton5.Enabled = False
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        srchFilterCuentaAfectable.Properties.DataSource = Nothing
        srchFilterCuentaAfectable.Properties.NullText = ""
        srchFilterCuenta.Enabled = True
        SimpleButton4.Enabled = True
        If srchFilterCuenta.Text = "" Then
            srchRangoA.Enabled = True
            srchRangoDe.Enabled = True
            SimpleButton3.Enabled = True
            SimpleButton5.Enabled = True
        End If
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        srchRangoDe.Properties.DataSource = Nothing
        srchRangoDe.Properties.NullText = ""
        If srchRangoA.Text = "" Then
            srchFilterCuenta.Enabled = True
            srchFilterCuentaAfectable.Enabled = True
            SimpleButton2.Enabled = True
            SimpleButton4.Enabled = True
        End If
    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton5.Click
        srchRangoA.Properties.DataSource = Nothing
        srchRangoA.Properties.NullText = ""
        If srchRangoDe.Text = "" Then
            srchFilterCuenta.Enabled = True
            srchFilterCuentaAfectable.Enabled = True
            SimpleButton2.Enabled = True
            SimpleButton4.Enabled = True
        End If
    End Sub
    Private Sub srchRangoDe_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchRangoDe.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With srchRangoDe.Properties
            '.DataSource = ObjTempSQL2.List(" nivel >= 4", 0, "C_Contable", " Order by NumeroCuenta ")
            .DataSource = ObjTempSQL2.List("Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
    End Sub
    Private Sub srchRangoA_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchRangoA.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With srchRangoA.Properties
            '.DataSource = ObjTempSQL2.List(" nivel >= 4", 0, "C_Contable", " Order by NumeroCuenta ")
            .DataSource = ObjTempSQL2.List("Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With
    End Sub

    Private Sub srchRangoDe_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles srchRangoDe.EditValueChanged
        srchFilterCuenta.Enabled = False
        srchFilterCuentaAfectable.Enabled = False
        SimpleButton2.Enabled = False
        SimpleButton4.Enabled = False
    End Sub

    Private Sub srchRangoA_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles srchRangoA.EditValueChanged
        srchFilterCuenta.Enabled = False
        srchFilterCuentaAfectable.Enabled = False
        SimpleButton2.Enabled = False
        SimpleButton4.Enabled = False
    End Sub

    Private Sub srchFilterCuenta_EditValueChanging(sender As System.Object, e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles srchFilterCuenta.EditValueChanging

    End Sub

    Private Sub srchFilterCuenta_Click(sender As System.Object, e As System.EventArgs) Handles srchFilterCuenta.Click
        If srchFilterCuenta.Text <> "" Then
            srchFilterCuentaAfectable.Enabled = False
            SimpleButton2.Enabled = False
            'lookups inferiores
            srchRangoA.Enabled = False
            srchRangoDe.Enabled = False
            SimpleButton3.Enabled = False
            SimpleButton5.Enabled = False
        End If
    End Sub

    Private Sub srchFilterCuentaAfectable_Click(sender As System.Object, e As System.EventArgs) Handles srchFilterCuentaAfectable.Click
        If srchFilterCuentaAfectable.Text <> "" Then
            srchFilterCuenta.Enabled = False
            SimpleButton4.Enabled = False
            'lookups inferiores
            srchRangoA.Enabled = False
            srchRangoDe.Enabled = False
            SimpleButton3.Enabled = False
            SimpleButton5.Enabled = False
        End If
    End Sub

    Private Sub srchRangoDe_Click(sender As System.Object, e As System.EventArgs) Handles srchRangoDe.Click
        If srchRangoDe.Text <> "" Then
            srchFilterCuenta.Enabled = False
            srchFilterCuentaAfectable.Enabled = False
            SimpleButton2.Enabled = False
            SimpleButton4.Enabled = False
        End If
    End Sub

    Private Sub srchRangoA_Click(sender As System.Object, e As System.EventArgs) Handles srchRangoA.Click
        If srchRangoA.Text <> "" Then
            srchFilterCuenta.Enabled = False
            srchFilterCuentaAfectable.Enabled = False
            SimpleButton2.Enabled = False
            SimpleButton4.Enabled = False
        End If
    End Sub


    Private Sub PrintPreviewBarCheckItem5_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs) Handles PrintPreviewBarCheckItem5.ItemClick
        'xls
        If CheckBox2.Checked = False Then
            CheckBox2.Checked = True
            SimpleButton1.PerformClick()
        End If

    End Sub

    Private Sub PrintPreviewBarCheckItem6_ItemClick(sender As System.Object, e As DevExpress.XtraBars.ItemClickEventArgs) Handles PrintPreviewBarCheckItem6.ItemClick
        'xlsx
        If CheckBox2.Checked = False Then
            CheckBox2.Checked = True
            SimpleButton1.PerformClick()
        End If
    End Sub

    Private Sub CheckBox1_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles CheckBox1.CheckedChanged
        'If CheckBox1.Checked = True Then
        '    CheckBox3.Enabled = True
        'Else
        '    CheckBox3.Enabled = False
        '    CheckBox3.Checked = False
        'End If
    End Sub

    Private Sub srchFilterCuenta_CloseUp(sender As System.Object, e As DevExpress.XtraEditors.Controls.CloseUpEventArgs) Handles srchFilterCuenta.CloseUp
        'CheckBox1.Checked = True
        'CheckBox1.Enabled = False
    End Sub
End Class