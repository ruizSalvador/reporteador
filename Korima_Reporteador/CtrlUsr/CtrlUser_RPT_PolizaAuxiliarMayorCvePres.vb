Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient
Public Class CtrlUser_RPT_PolizaAuxiliarMayorCvePres
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
        ErrorProvider1.Clear()
        If (srchSello1.Text.Trim = "") Then
            If (srchSello1.Text.Trim = "") Then ErrorProvider1.SetError(srchSello1, "Debe Indicar el sello presupuestal")
            Exit Sub
        End If
        'If (FiltroSello.Text = "" And LUE_RangoA.Text <> "") Or (FiltroSello.Text <> "" And LUE_RangoA.Text = "") Then
        '    MessageBox.Show("Debe seleccionar ambos rangos", "Información", MessageBoxButtons.OK, MessageBoxIcon.Information)
        '    Exit Sub
        'End If

        If (srchSello2.Text.Trim = "") Then
            If (srchSello2.Text.Trim = "") Then ErrorProvider1.SetError(srchSello2, "Debe Indicar el sello presupuestal")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        'Dim reporte As New RPT_AuxiliarMayorCvePres
        Dim reporte As New RPT_AuxiliarMayorCvePres
        Dim printTool As New ReportPrintTool(reporte)
        Dim strFiltro As String
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        strFiltro = ""
        Dim i As Integer
        i = FilterCuenta.GetColumnValue("Nivel")


        ErrorProvider1.Clear()
        If (FilterCuenta.Text <> "") Then
            If FilterCuenta.GetColumnValue("Nivel") = 0 Then
                strFiltro = strFiltro & FilterCuenta.Text.Substring(0, 1)
            ElseIf FilterCuenta.GetColumnValue("Nivel") = 1 Then
                strFiltro = strFiltro & FilterCuenta.Text.Substring(0, 2)
            ElseIf FilterCuenta.GetColumnValue("Nivel") = 2 Then
                strFiltro = strFiltro & FilterCuenta.Text.Substring(0, 3)
            ElseIf FilterCuenta.GetColumnValue("Nivel") = 3 Then
                strFiltro = strFiltro & FilterCuenta.Text.Substring(0, 4)
            ElseIf FilterCuenta.GetColumnValue("Nivel") = 4 Then
                strFiltro = strFiltro & FilterCuenta.Text.Substring(0, 5)
            Else 'If filterProveedor1.Properties.KeyValue = 5 Then
                strFiltro = FilterCuenta.Text
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
        Dim SQLComando As New SqlCommand("SP_RPT_K2_AuxiliarMayorCvePres", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        If FilterCuenta.Text.Trim <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@NumeroCuenta", ""))
            SQLComando.Parameters.Add(New SqlParameter("@CuentaAcumulable", strFiltro))
        End If
        If FilterCuentaAfectable.Text.Trim <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@NumeroCuenta", FilterCuentaAfectable.Text.Trim))
            SQLComando.Parameters.Add(New SqlParameter("@CuentaAcumulable", FilterCuentaAfectable.Text.Trim))
        End If
        If FilterCuentaAfectable.Text.Trim = "" And FilterCuenta.Text.Trim = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@NumeroCuenta", ""))
            SQLComando.Parameters.Add(New SqlParameter("@CuentaAcumulable", ""))
        End If

        'Dim x As Integer = Convert.ToInt32(FilterSello.EditValue)
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", FilterEjercicio.Time.Year))
        SQLComando.Parameters.Add(New SqlParameter("@MesInicio", filterPeriodoDe.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@MesFin", filterPeriodoAl.Time.Month))
        SQLComando.Parameters.Add(New SqlParameter("@MuestraVacios", CheckBox1.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@CuentaInicio", ""))
        SQLComando.Parameters.Add(New SqlParameter("@CuentaFin", ""))
        'SQLComando.Parameters.Add(New SqlParameter("@CvePres", IIf(FilterSello.Text = "", 0, Convert.ToInt32(FilterSello.Text))))
        'SQLComando.Parameters.Add(New SqlParameter("@CvePres2", IIf(FiltroSello.Text = "", 0, Convert.ToInt32(FiltroSello.Text))))
        SQLComando.Parameters.Add(New SqlParameter("@CvePres", Convert.ToInt32(srchSello1.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@CvePres2", Convert.ToInt32(srchSello2.EditValue)))
        If filterFuenteFinanciamiento.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", filterFuenteFinanciamiento.EditValue))
        End If

        If filterFuenteFinanciamiento.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", ""))

        End If
        SQLComando.CommandTimeout = 0
        'Dim x As Int32 = filterFuenteFinanciamiento.Properties.KeyValue
        Dim adapter As New SqlClient.SqlDataAdapter(SQLComando)
        'adapter = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_AuxiliarDeMayor " & FiltroSQL & " ORDER BY NumeroCuentaContable,Fecha", cnnString)

        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_AuxiliarMayorCvePres")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_AuxiliarMayorCvePres"

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
            .lblRptNombreReporte.Text = "AUXILIAR DE MAYOR POR CLAVE PRESUPUESTAL."

            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            'Se limita la funcionalidad a un solo mes solo por esta version
            '.lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoDe.Time.Month) & " del " & filterPeriodoDe.Time.Year.ToString & " a " & MesLetra(filterPeriodoAl.Time.Month) & " del " & filterPeriodoAl.Time.Year.ToString
            '.lblSubtitulo.Text = "Ejercicio del " & filterPeriodoAl.Time.Year.ToString
            .lblRptDescripcionFiltrado.Text = "Periodo: " & MesLetra(filterPeriodoDe.Time.Month) & " a " & MesLetra(filterPeriodoAl.Time.Month) & " del " & FilterEjercicio.Time.Year.ToString
            If filterPeriodoDe.Time.Month = filterPeriodoAl.Time.Month Then
                .lblRptDescripcionFiltrado.Text = "Periodo: " & MesLetra(filterPeriodoDe.Time.Month) & " del " & FilterEjercicio.Time.Year.ToString
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
        'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl


        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl

        'Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With srchSello1.Properties
            .DataSource = ObjTempSQL2.List(" lYear = " & FilterEjercicio.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "IdSelloPresupuestal"
            .ValueMember = "IdSelloPresupuestal"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With

        With srchSello2.Properties
            .DataSource = ObjTempSQL2.List(" lYear = " & FilterEjercicio.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "IdSelloPresupuestal"
            .ValueMember = "IdSelloPresupuestal"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With

        'With FilterSello.Properties
        '    .DataSource = ObjTempSQL2.List(" lYear = " & FilterEjercicio.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
        '    .DisplayMember = "Sello"
        '    .ValueMember = "IdSelloPresupuestal"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        'End With

        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '____0-00000' or numerocuenta like '____0-000000'", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        With FilterCuentaAfectable.Properties
            '.DataSource = ObjTempSQL2.List(" nivel >= 4", 0, "C_Contable", " Order by NumeroCuenta ")
            .DataSource = ObjTempSQL2.List(" Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        'With FiltroSello.Properties

        '    .DataSource = ObjTempSQL2.List(" lYear = " & FilterEjercicio.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
        '    .DisplayMember = "Sello"
        '    .ValueMember = "IdSelloPresupuestal"
        '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    .NullText = ""
        '    .ShowHeader = True
        '    '.DataSource = ObjTempSQL2.List("Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
        '    '.DisplayMember = "NumeroCuenta"
        '    '.ValueMember = "NumeroCuenta"
        '    '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
        '    '.NullText = ""
        '    '.ShowHeader = True
        'End With
        With LUE_RangoA.Properties

            .DataSource = ObjTempSQL2.List("Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        FilterCuenta.Properties.DataSource = Nothing
        FilterCuenta.Properties.NullText = ""
        FilterCuentaAfectable.Enabled = True
        SimpleButton2.Enabled = True

        If FilterCuentaAfectable.Text = "" Then
            LUE_RangoA.Enabled = True
            'FiltroSello.Enabled = True
            'SimpleButton3.Enabled = True
            SimpleButton5.Enabled = True
        End If
    End Sub

    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuenta.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '____0-00000' or numerocuenta like '____0-000000'", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub FilterCuentaAfectable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuentaAfectable.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuentaAfectable.Properties
            '.DataSource = ObjTempSQL2.List(" nivel >= 4", 0, "C_Contable", " Order by NumeroCuenta ")
            .DataSource = ObjTempSQL2.List(" Afectable =1 and Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterCuenta_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterCuenta.EditValueChanged
        FilterCuentaAfectable.Enabled = False
        SimpleButton2.Enabled = False
        'lookups inferiores
        LUE_RangoA.Enabled = False
        'FiltroSello.Enabled = False
        'SimpleButton3.Enabled = False
        SimpleButton5.Enabled = False
    End Sub

    Private Sub FilterCuentaAfectable_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterCuentaAfectable.EditValueChanged
        FilterCuenta.Enabled = False
        SimpleButton4.Enabled = False
        'lookups inferiores
        LUE_RangoA.Enabled = False
        'FiltroSello.Enabled = False
        'SimpleButton3.Enabled = False
        SimpleButton5.Enabled = False
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        FilterCuentaAfectable.Properties.DataSource = Nothing
        FilterCuentaAfectable.Properties.NullText = ""
        FilterCuenta.Enabled = True
        SimpleButton4.Enabled = True
        If FilterCuenta.Text = "" Then
            LUE_RangoA.Enabled = True
            'FiltroSello.Enabled = True
            'SimpleButton3.Enabled = True
            SimpleButton5.Enabled = True
        End If
    End Sub

    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        srchSello2.Properties.DataSource = Nothing
        srchSello2.Properties.NullText = ""
        If LUE_RangoA.Text = "" Then
            FilterCuenta.Enabled = True
            FilterCuentaAfectable.Enabled = True
            SimpleButton2.Enabled = True
            SimpleButton4.Enabled = True
        End If
    End Sub

    Private Sub SimpleButton5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton5.Click
        LUE_RangoA.Properties.DataSource = Nothing
        LUE_RangoA.Properties.NullText = ""
        If srchSello2.Text = "" Then
            FilterCuenta.Enabled = True
            FilterCuentaAfectable.Enabled = True
            SimpleButton2.Enabled = True
            SimpleButton4.Enabled = True
        End If
    End Sub
    Private Sub filterFuenteFinanciamiento_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterFuenteFinanciamiento.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

    End Sub
    'Private Sub LUE_RangoDe_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FiltroSello.GotFocus
    'Private Sub FiltroSello_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs)

    '    Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    '    With FiltroSello.Properties
    '        .DataSource = ObjTempSQL2.List("lYear = " & FilterEjercicio.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
    '        .DisplayMember = "Sello"
    '        .ValueMember = "IdSelloPresupuestal"
    '        .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '        .NullText = ""
    '        .ShowHeader = True
    '    End With

    'Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    'With LUE_RangoDe.Properties
    '    '.DataSource = ObjTempSQL2.List(" nivel >= 4", 0, "C_Contable", " Order by NumeroCuenta ")
    '    .DataSource = ObjTempSQL2.List("Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
    '    .DisplayMember = "NumeroCuenta"
    '    .ValueMember = "NumeroCuenta"
    '    .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '    .NullText = ""
    '    .ShowHeader = True
    'End With
    'End Sub
    Private Sub LUE_RangoA_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles LUE_RangoA.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LUE_RangoA.Properties
            '.DataSource = ObjTempSQL2.List(" nivel >= 4", 0, "C_Contable", " Order by NumeroCuenta ")
            .DataSource = ObjTempSQL2.List("Afectable =1 AND Nivel >=0 ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NumeroCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub srchSello1_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchSello1.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl

        With srchSello1.Properties
            .DataSource = ObjTempSQL2.List(" lYear = " & FilterEjercicio.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "IdSelloPresupuestal"
            .ValueMember = "IdSelloPresupuestal"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With

    End Sub

    Private Sub srchSello2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles srchSello2.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl

        With srchSello2.Properties
            .DataSource = ObjTempSQL2.List(" lYear = " & FilterEjercicio.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
            .DisplayMember = "IdSelloPresupuestal"
            .ValueMember = "IdSelloPresupuestal"
            '.SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            '.ShowHeader = True
        End With

    End Sub

    Private Sub FiltroSello_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)
        'FilterCuenta.Enabled = False
        'FilterCuentaAfectable.Enabled = False
        'SimpleButton2.Enabled = False
        'SimpleButton4.Enabled = False
    End Sub

    Private Sub LUE_RangoA_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LUE_RangoA.EditValueChanged
        FilterCuenta.Enabled = False
        FilterCuentaAfectable.Enabled = False
        SimpleButton2.Enabled = False
        SimpleButton4.Enabled = False
    End Sub

    Private Sub FilterCuenta_EditValueChanging(ByVal sender As System.Object, ByVal e As DevExpress.XtraEditors.Controls.ChangingEventArgs) Handles FilterCuenta.EditValueChanging, FilterEjercicio.EditValueChanging

    End Sub

    Private Sub FilterCuenta_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterCuenta.Click
        If FilterCuenta.Text <> "" Then
            FilterCuentaAfectable.Enabled = False
            SimpleButton2.Enabled = False
            'lookups inferiores
            LUE_RangoA.Enabled = False
            'FiltroSello.Enabled = False
            'SimpleButton3.Enabled = False
            SimpleButton5.Enabled = False
        End If
    End Sub

    Private Sub FilterCuentaAfectable_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterCuentaAfectable.Click
        If FilterCuentaAfectable.Text <> "" Then
            FilterCuenta.Enabled = False
            SimpleButton4.Enabled = False
            'lookups inferiores
            LUE_RangoA.Enabled = False
            'FiltroSello.Enabled = False
            'SimpleButton3.Enabled = False
            SimpleButton5.Enabled = False
        End If
    End Sub
    'Private Sub filterSello_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs)

    '    Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
    '    With FilterSello.Properties
    '        .DataSource = ObjTempSQL2.List(" lYear = " & FilterEjercicio.Text, 0, "T_SellosPresupuestales", " Order by IdSelloPresupuestal ")
    '        .DisplayMember = "Sello"
    '        .ValueMember = "IdSelloPresupuestal"
    '        .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
    '        .NullText = ""
    '        .ShowHeader = True
    '    End With
    'End Sub
    Private Sub FiltroSello_Click(ByVal sender As System.Object, ByVal e As System.EventArgs)
        'If FiltroSello.Text <> "" Then
        '    FilterCuenta.Enabled = False
        '    FilterCuentaAfectable.Enabled = False
        '    SimpleButton2.Enabled = False
        '    SimpleButton4.Enabled = False
        'End If
    End Sub

    Private Sub LUE_RangoA_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LUE_RangoA.Click
        If LUE_RangoA.Text <> "" Then
            FilterCuenta.Enabled = False
            FilterCuentaAfectable.Enabled = False
            SimpleButton2.Enabled = False
            SimpleButton4.Enabled = False
        End If
    End Sub


    Private Sub PrintPreviewBarCheckItem5_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles PrintPreviewBarCheckItem5.ItemClick
        'xls
        If CheckBox2.Checked = False Then
            CheckBox2.Checked = True
            SimpleButton1.PerformClick()
        End If

    End Sub

    Private Sub PrintPreviewBarCheckItem6_ItemClick(ByVal sender As System.Object, ByVal e As DevExpress.XtraBars.ItemClickEventArgs) Handles PrintPreviewBarCheckItem6.ItemClick
        'xlsx
        If CheckBox2.Checked = False Then
            CheckBox2.Checked = True
            SimpleButton1.PerformClick()
        End If
    End Sub

    Private Sub FilterEjercicio_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles FilterEjercicio.EditValueChanged, FilterEjercicio.DockChanged, FilterEjercicio.TextChanged, FilterEjercicio.Validated, FilterEjercicio.Click, FilterEjercicio.CausesValidationChanged
        srchSello1.Properties.DataSource = Nothing
        srchSello1.Properties.NullText = ""
        srchSello2.Properties.DataSource = Nothing
        srchSello2.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton6_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton6.Click
        srchSello1.Properties.DataSource = Nothing
        srchSello1.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton7_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton7.Click
        filterFuenteFinanciamiento.Properties.DataSource = Nothing
        filterFuenteFinanciamiento.Properties.NullText = ""
    End Sub
End Class