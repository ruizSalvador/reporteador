Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_PlanCuentas
    Dim Tipocuenta As String
    Dim Afectable As Integer
    Dim Mayor As String
    Dim Numerocuenta As String
    Dim NumerocuentaFin As String
    Dim NumerocuentaInicio As String
    Dim Padres As Boolean
    Dim Hijos As Boolean
    Dim Activo As Integer

    Sub asignavalores()
        'limpia
        Tipocuenta = ""
        Afectable = 3
        Mayor = ""
        Numerocuenta = ""
        NumerocuentaFin = ""
        NumerocuentaInicio = ""
        Padres = False
        Hijos = False
        Activo = 3
        'asigna
        Padres = Chkpadres.Checked
        Hijos = ChkHjos.Checked
        If FilterCuenta.Text = Nothing Then
            Numerocuenta = ""
        Else
            Numerocuenta = FilterCuenta.Text
        End If
        If LookUpEdit1.Text = Nothing Then
            NumerocuentaInicio = ""
        Else
            NumerocuentaInicio = LookUpEdit1.Text
        End If
        If LookUpEdit2.Text = Nothing Then
            NumerocuentaFin = ""
        Else
            NumerocuentaFin = LookUpEdit2.Text
        End If

        'Estatus
        If CmbEstatus.SelectedIndex = 0 Then
            Activo = 3
        End If
        If CmbEstatus.SelectedIndex = 1 Then
            Activo = 1
        End If
        If CmbEstatus.SelectedIndex = 2 Then
            Activo = 0
        End If
        'Afectacion
        If CmbAfectacion.SelectedIndex = 0 Then
            Afectable = 3
        End If
        If CmbAfectacion.SelectedIndex = 1 Then
            Afectable = 1
        End If
        If CmbAfectacion.SelectedIndex = 2 Then
            Afectable = 0
        End If
        'Mayor
        If (ChkMayorSi.Checked Or ChkMayorNo.Checked Or ChkTitulo.Checked Or ChkSubtitulo.Checked) Then
            If ChkMayorSi.Checked Then
                Mayor += ChkMayorSi.Tag
            End If
            If ChkMayorNo.Checked Then
                Mayor += ChkMayorNo.Tag
            End If
            If ChkTitulo.Checked Then
                Mayor += ChkTitulo.Tag
            End If
            If ChkSubtitulo.Checked Then
                Mayor += ChkSubtitulo.Tag
            End If
        End If
        'TipoCuenta
        If (ChkActivoAcreedora.Checked Or ChkActivoDeudora.Checked Or ChkPasivoAcreedora.Checked Or ChkpasivoDeudora.Checked Or ChkPatrimonioAcreedora.Checked Or ChkPatrimonioDeudora.Checked Or ChkResultadosAcreedora.Checked Or ChkResultadosDeudora.Checked Or ChkOrdenAcreedora.Checked Or ChkOrdenDeudora.Checked Or ChkControl.Checked) Then
            If ChkActivoAcreedora.Checked Then
                Tipocuenta += ChkActivoAcreedora.Tag
            End If
            If ChkActivoDeudora.Checked Then
                Tipocuenta += ChkActivoDeudora.Tag
            End If
            If ChkPasivoAcreedora.Checked Then
                Tipocuenta += ChkPasivoAcreedora.Tag
            End If
            If ChkpasivoDeudora.Checked Then
                Tipocuenta += ChkpasivoDeudora.Tag
            End If
            If ChkPatrimonioAcreedora.Checked Then
                Tipocuenta += ChkPatrimonioAcreedora.Tag
            End If
            If ChkPatrimonioDeudora.Checked Then
                Tipocuenta += ChkPatrimonioDeudora.Tag
            End If
            If ChkResultadosAcreedora.Checked Then
                Tipocuenta += ChkResultadosAcreedora.Tag
            End If
            If ChkResultadosDeudora.Checked Then
                Tipocuenta += ChkResultadosDeudora.Tag
            End If
            If ChkOrdenAcreedora.Checked Then
                Tipocuenta += ChkOrdenAcreedora.Tag
            End If
            If ChkOrdenDeudora.Checked Then
                Tipocuenta += ChkOrdenDeudora.Tag
            End If
            If ChkControl.Checked Then
                Tipocuenta += ChkControl.Tag
            End If
        Else
            Tipocuenta = ""
        End If

    End Sub

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
        If (LookUpEdit1.Text <> "" And LookUpEdit2.Text = "") Or (LookUpEdit1.Text = "" And LookUpEdit2.Text <> "") Then
            ErrorProvider1.SetError(LookUpEdit1, "Selecione inicio y fin del rango de cuentas")
            Exit Sub
        End If
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        Dim reporte As New RPT_PlanCuentas
        Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString
        If FilterCuenta.Text = "" Then
            Chkpadres.Checked = False
            ChkHjos.Checked = False
        End If
        asignavalores()


        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_K2_PlanCuentas", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros IN
        SQLComando.Parameters.Add(New SqlParameter("@TipoCuenta", Tipocuenta))
        SQLComando.Parameters.Add(New SqlParameter("@Afectable", Afectable))
        SQLComando.Parameters.Add(New SqlParameter("@Mayor", Mayor))
        SQLComando.Parameters.Add(New SqlParameter("@NumeroCuenta", Numerocuenta))
        SQLComando.Parameters.Add(New SqlParameter("@MuestraHijos", Hijos))
        SQLComando.Parameters.Add(New SqlParameter("@MuestaPadres", Padres))
        SQLComando.Parameters.Add(New SqlParameter("@Activo", Activo))
        SQLComando.Parameters.Add(New SqlParameter("@NumeroCuentaFin", NumerocuentaFin))
        SQLComando.Parameters.Add(New SqlParameter("@NumeroCuentaInicio", NumerocuentaInicio))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_K2_PlanCuentas")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_K2_PlanCuentas"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = "Catálogo Plan de Cuentas"
            .lblRptNombreReporte.Text = ""
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            .lblRptDescripcionFiltrado.Text = "" ' "Periodo: al " & filterPeriodoDe.DateTime.Date.ToShortDateString
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Catálogo Plan de Cuentas' ", New SqlConnection(cnnString))
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
        'filterPeriodoDe.DateTime = Now
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '_____-_____%' or NumeroCuenta Like '______-______%' or NumeroCuenta Like '_____-______%' ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NombreCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL3 As New clsRPT_CFG_DatosEntesCtrl
        With LookUpEdit1.Properties
            .DataSource = ObjTempSQL3.List(" NumeroCuenta Like '_____-_____%' or NumeroCuenta Like '______-______%' or NumeroCuenta Like '_____-______%' ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NombreCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        Dim ObjTempSQL4 As New clsRPT_CFG_DatosEntesCtrl
        With LookUpEdit2.Properties
            .DataSource = ObjTempSQL4.List(" NumeroCuenta Like '_____-_____%' or NumeroCuenta Like '______-______%' or NumeroCuenta Like '_____-______%' ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NombreCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub filterProveedor_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCuenta.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCuenta.Properties
            .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '_____-_____%' or NumeroCuenta Like '______-______%' or NumeroCuenta Like '_____-______%' ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NombreCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        FilterCuenta.Properties.DataSource = Nothing
        FilterCuenta.Properties.NullText = ""
        ChkHjos.Enabled = False
        Chkpadres.Enabled = False
        ChkHjos.Checked = False
        Chkpadres.Checked = False

        If FilterCuenta.Text <> "" Then
            LookUpEdit1.Enabled = False
            LookUpEdit2.Enabled = False
            SimpleButton2.Enabled = False
            SimpleButton3.Enabled = False
        Else
            LookUpEdit1.Enabled = True
            LookUpEdit2.Enabled = True
            SimpleButton2.Enabled = True
            SimpleButton3.Enabled = True
        End If

    End Sub

    Private Sub FilterCuenta_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles FilterCuenta.EditValueChanged
        If FilterCuenta.Text <> "" Then
            ChkHjos.Enabled = True
            Chkpadres.Enabled = True
            'ChkHjos.Checked = True
            'Chkpadres.Checked = True
            LookUpEdit1.Enabled = False
            LookUpEdit2.Enabled = False
            SimpleButton2.Enabled = False
            SimpleButton3.Enabled = False
        Else
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            LookUpEdit1.Enabled = True
            LookUpEdit2.Enabled = True
            SimpleButton2.Enabled = True
            SimpleButton3.Enabled = True
        End If
    End Sub

    Private Sub SimpleButton2_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton2.Click
        LookUpEdit1.Properties.DataSource = Nothing
        LookUpEdit1.Properties.NullText = ""
        'ChkHjos.Enabled = False
        'Chkpadres.Enabled = False
        'ChkHjos.Checked = False
        'Chkpadres.Checked = False

        If LookUpEdit1.Text <> "" Then
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            FilterCuenta.Enabled = False
            SimpleButton4.Enabled = False
        ElseIf LookUpEdit2.Text = "" Then
            Chkpadres.Enabled = True
            FilterCuenta.Enabled = True
            SimpleButton4.Enabled = True
            ChkHjos.Enabled = True
            Chkpadres.Enabled = True
            'ChkHjos.Checked = True
            'Chkpadres.Checked = True
        End If
    End Sub

    Private Sub LookUpEdit1_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles LookUpEdit1.EditValueChanged
        If LookUpEdit1.Text <> "" Then
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            FilterCuenta.Enabled = False
            SimpleButton4.Enabled = False
        ElseIf LookUpEdit2.Text = "" Then
            Chkpadres.Enabled = True
            FilterCuenta.Enabled = True
            SimpleButton4.Enabled = True
            ChkHjos.Enabled = True
            Chkpadres.Enabled = True
            'ChkHjos.Checked = True
            'Chkpadres.Checked = True
        End If
    End Sub
    Private Sub LookUpEdit1_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles LookUpEdit1.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LookUpEdit1.Properties
            .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '_____-_____%' or NumeroCuenta Like '______-______%' or NumeroCuenta Like '_____-______%' ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NombreCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        LookUpEdit2.Properties.DataSource = Nothing
        LookUpEdit2.Properties.NullText = ""

        If LookUpEdit2.Text <> "" Then
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            FilterCuenta.Enabled = False
            SimpleButton4.Enabled = False
        ElseIf LookUpEdit1.Text = "" Then
            ChkHjos.Enabled = True
            Chkpadres.Enabled = True
            'ChkHjos.Checked = True
            'Chkpadres.Checked = True
            Chkpadres.Enabled = True
            FilterCuenta.Enabled = True
            SimpleButton4.Enabled = True
        End If
    End Sub
    Private Sub LookUpEdit2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles LookUpEdit2.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With LookUpEdit2.Properties
            .DataSource = ObjTempSQL2.List(" NumeroCuenta Like '_____-_____%' or NumeroCuenta Like '______-______%' or NumeroCuenta Like '_____-______%' ", 0, "C_Contable", " Order by NumeroCuenta ")
            .DisplayMember = "NumeroCuenta"
            .ValueMember = "NombreCuenta"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub LookUpEdit2_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles LookUpEdit2.EditValueChanged
        If LookUpEdit2.Text <> "" Then
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            FilterCuenta.Enabled = False
            SimpleButton4.Enabled = False
        ElseIf LookUpEdit1.Text = "" Then
            ChkHjos.Enabled = True
            Chkpadres.Enabled = True
            'ChkHjos.Checked = True
            'Chkpadres.Checked = True
            Chkpadres.Enabled = True
            FilterCuenta.Enabled = True
            SimpleButton4.Enabled = True

        End If
    End Sub

    Private Sub LookUpEdit2_Enter(sender As System.Object, e As System.EventArgs) Handles LookUpEdit2.Click
        If LookUpEdit2.Text <> "" Then
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            FilterCuenta.Enabled = False
            SimpleButton4.Enabled = False
        ElseIf LookUpEdit1.Text = "" Then
            ChkHjos.Enabled = True
            Chkpadres.Enabled = True
            'ChkHjos.Checked = True
            'Chkpadres.Checked = True
            Chkpadres.Enabled = True
            FilterCuenta.Enabled = True
            SimpleButton4.Enabled = True
        End If
    End Sub

    Private Sub LookUpEdit1_Enter(sender As System.Object, e As System.EventArgs) Handles LookUpEdit1.Click
        If LookUpEdit1.Text <> "" Then
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            FilterCuenta.Enabled = False
            SimpleButton4.Enabled = False
        ElseIf LookUpEdit2.Text = "" Then
            Chkpadres.Enabled = True
            FilterCuenta.Enabled = True
            SimpleButton4.Enabled = True
            ChkHjos.Enabled = True
            Chkpadres.Enabled = True
            'ChkHjos.Checked = True
            'Chkpadres.Checked = True
        End If
    End Sub

    Private Sub FilterCuenta_Enter(sender As System.Object, e As System.EventArgs) Handles FilterCuenta.Click
        If FilterCuenta.Text <> "" Then
            ChkHjos.Enabled = True
            Chkpadres.Enabled = True
            'ChkHjos.Checked = True
            'Chkpadres.Checked = True
            LookUpEdit1.Enabled = False
            LookUpEdit2.Enabled = False
            SimpleButton2.Enabled = False
            SimpleButton3.Enabled = False
        Else
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            ChkHjos.Enabled = False
            Chkpadres.Enabled = False
            LookUpEdit1.Enabled = True
            LookUpEdit2.Enabled = True
            SimpleButton2.Enabled = True
            SimpleButton3.Enabled = True
        End If
    End Sub

End Class