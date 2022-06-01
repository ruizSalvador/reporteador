Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Presupuestales_IDEFT

    Dim _SP As Integer
    Dim _REPORTE As Integer
    Dim _nomREPORTE As String
    Dim _TITULO As String
    Dim _nomTipoReporte As String
    Dim _nomTipoClaves As String
    Dim _FIRMAS As String

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

    Public Sub New(ByVal SP As Integer, ByVal REPORTE As Integer)
        Me.SP = SP
        Me._REPORTE = REPORTE

        InitializeComponent()
    End Sub
    Public Property SP As Integer
        Get
            Return _SP
        End Get
        Set(ByVal value As Integer)
            _SP = value
        End Set
    End Property

    Public Property REPORTE As Integer
        Get
            Return _REPORTE
        End Get
        Set(ByVal value As Integer)
            _REPORTE = value
        End Set
    End Property

    Public Property nomREPORTE As String
        Get
            Return _nomREPORTE
        End Get
        Set(ByVal value As String)
            _nomREPORTE = value

        End Set
    End Property

    Public Property TITULO As String
        Get
            Return _TITULO
        End Get
        Set(ByVal value As String)
            _TITULO = value
        End Set
    End Property

    Public Property nomTipoReporte As String
        Get
            Return _nomTipoReporte
        End Get
        Set(ByVal value As String)
            _nomTipoReporte = value
        End Set
    End Property

    Public Property nomTipoClaves As String
        Get
            Return _nomTipoClaves
        End Get
        Set(ByVal value As String)
            _nomTipoClaves = value
        End Set
    End Property

    Public Property FIRMAS As String
        Get
            Return _FIRMAS
        End Get
        Set(ByVal value As String)
            _FIRMAS = value
        End Set
    End Property

    Public Function AsignaReporte() As Object
        Dim rpt As XtraReport
        Select Case REPORTE

            Case 1
                Me.nomREPORTE = "Reporte por Unidad Responsable"
                Me.TITULO = "Reporte por Unidad Responsable"
                Me.nomTipoReporte = ""
                Me.nomTipoClaves = "Clave UR"
                Me.FIRMAS = "IDEFT Unidad Responsable"
               
               
                'Me.LabelControl9.Visible = True
                'Me.FilterCapitulo.Visible = True
                'Me.SimpleButton6.Visible = True
                'Me.chkAprAnual.Visible = True
                Me.chkAprAnual.Visible = True
                Me.ChkAmpRed.Visible = True
                rpt = New RPT_Presupuestal_IDEFT_2Colum()
                Return rpt

            Case 2
                Me.nomREPORTE = "Reporte por Capítulo de Gasto"
                Me.TITULO = "Reporte por Capítulo de Gasto"
                Me.nomTipoReporte = "Concepto "
                Me.nomTipoClaves = "Capítulo" '"Ramo"
                Me.FIRMAS = "IDEFT Capítulo de Gasto"
                Me.chkAprAnual.Visible = True
                Me.ChkAmpRed.Visible = True
                rpt = New RPT_Presupuestal_IDEFT_2Colum()

                Return rpt


            Case 3
                Me.nomREPORTE = "Reporte por Fuente de Financiamiento"
                Me.TITULO = "Reporte por Fuente de Financiamiento"
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Clave FF"
                Me.FIRMAS = "IDEFT Fuente de Financiamiento"
                Me.chkAprAnual.Visible = True
                Me.ChkAmpRed.Visible = True
                rpt = New RPT_Presupuestal_IDEFT_2Colum()
                Return rpt

            Case 4
                Me.nomREPORTE = "Reporte por Unidad Responsable y Capítulo de Gasto"
                Me.TITULO = "Reporte por Unidad Responsable y Capítulo de Gasto"
                Me.nomTipoReporte = "" '"Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Clave" '"Tipo Gasto"
                Me.FIRMAS = "IDEFT Unidad Responsable y Capítulo de Gasto"
                Me.chkAprAnual.Visible = True
                Me.ChkAmpRed.Visible = True
                rpt = New RPT_Presupuestal_IDEFT_4Colum()
                Return rpt

            Case 5
                Me.nomREPORTE = "Reporte por Objeto del Gasto"
                Me.TITULO = "Reporte por Objeto del Gasto"
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "UR"
                Me.chkAprAnual.Visible = True
                Me.ChkAmpRed.Visible = True
                Me.FIRMAS = "IDEFT Objeto del Gasto"
                rpt = New RPT_Presupuestal_IDEFT_4Colum_5()
                Return rpt

            Case 6
                Me.nomREPORTE = "Reporte por Objeto del Gasto"
                Me.TITULO = "Reporte por Objeto del Gasto"
                Me.nomTipoReporte = "Concepto"
                Me.nomTipoClaves = "UR"
                Me.FIRMAS = "IDEFT Objeto del Gasto UR"
                Me.chkAprAnual.Visible = True
                Me.ChkAmpRed.Visible = True
                rpt = New RPT_Presupuestal_IDEFT_4Colum()
                Return rpt

            Case 7
                Me.nomREPORTE = "Reporte Partida Globa Gobierno"
                Me.TITULO = "Reporte Partida Global Gobierno"
                Me.nomTipoReporte = "CONCEPTO"
                Me.nomTipoClaves = "" '"Finalidad"
                Me.FIRMAS = "IDEFT Partida Global Gobierno"
                Me.chkAprAnual.Visible = True
                Me.ChkAmpRed.Visible = True
                rpt = New RPT_Presupuestal_IDEFT_2Colum_7()
                Return rpt

                'Case 8
                '    Me.nomREPORTE = "Comparativo Ingreso vs Egreso "
                '    Me.TITULO = "Comparativo Ingreso vs Egreso "
                '    Me.nomTipoReporte = "Ejercicio del Presupuesto   "
                '    Me.nomTipoClaves = "Finalidad"
                '    Me.FIRMAS = "Por Clasificación Funcional/Subfunción"
                '    Me.chkAprAnual.Visible = True
                '    Me.ChkAmpRed.Visible = True
                '    rpt = New RPT_EstadoEjercicioPresupuestal3Niveles()
                '    Return rpt

            Case Else
                MessageBox.Show("Hubo un error", "Error2", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return Nothing
        End Select
    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True

        Dim reporte = New Object()
        reporte = AsignaReporte()
        Dim printTool As New ReportPrintTool(reporte)

        '-------------------------------------------------------------------------
        Dim str As String = ""
        If chkFF.CheckedItems.Count <> 0 Then

            Dim x As Integer

            For x = 0 To chkFF.CheckedItems.Count - 1
                'ControlChars.CrLf
                str = str & "," & "'" & chkFF.CheckedItems(x).ToString & "'"
            Next x
        End If

        Dim cadena As String = ""
        If str <> "" Then
            cadena = str.Remove(0, 1)
        End If

        If cadena = "" Then
            MessageBox.Show("Debe seleccionar al menos una FF", "Información", MessageBoxButtons.OK, MessageBoxIcon.Information)
            Me.Cursor = Cursors.Default
            Return
        End If

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_Presupuestales_IDEFT", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN

        'Salvador Ruiz 31052022
        'comente las líneas de Debug
        '#If DEBUG Then
        '        MdlIdUsuario = 25
        '#End If

        If ChkAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))

        ElseIf ChkAnual.Checked = False Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoInicio.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFinal.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))

        End If


        ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

        'If GetFiltrarXUR(MdlIdUsuario) = True Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdArea", GetIdUR(MdlIdUsuario)))
        'Else
        '    SQLComando.Parameters.Add(New SqlParameter("@IdArea", 0))
        'End If
        SQLComando.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", ChkAmpRed.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@CadenaFF", cadena))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_Presupuestales_IDEFT")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_Presupuestales_IDEFT"
        SQLComando.Dispose()
        SQLConexion.Close()

        '--Fin SP


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne


        Dim primero As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoInicio.Time.Month, 1)
        Dim ultimo As Date
        If ChkAnual.Checked = True Then
            ultimo = New DateTime(filterPeriodoAl.Time.Year, 12, 1)
            ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        Else
            ultimo = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoFinal.Time.Month, 1)
            ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)
        End If

        '--- Llenar datos del ente
        With reporte

            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            '.lblRptNombreReporte.Text = nomREPORTE
            '.lblFechaRango.Text = ""
            .lblRptNombreReporte.Text = ""
            .lblSubtitulo.Text = ""
            .lblTitulo.Text = TITULO
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            'If ChkAnual.Checked = False Then
            '    .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString()    '"Del " & Primer & " al " & Ultimo
            'ElseIf ChkAnual.Checked = True Then
            '    .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            'End If

            ' ASC
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            If ChkAnual.Checked = False Then

                If TypeOf reporte Is RPT_EstadoEjercicioPresupuestal2Niveles Then
                    .lblRptDescripcionFiltrado.Text = "Del " + primero.ToString("dd/MM/yyyy") + " Al " + ultimo.ToString("dd/MM/yyyy")
                    '.label42.text = "TOTAL DE GASTO"
                Else
                    .lblRptDescripcionFiltrado.Text = "Del 01 de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " " & filterPeriodoAl.EditValue.Year.ToString & " al " + ultimo.Day.ToString + " de " & MesLetra(filterPeriodoFinal.EditValue.Month) & " " & filterPeriodoAl.EditValue.Year.ToString
                End If

            ElseIf ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            End If

            If rdTodo.Checked = True Then
                .lblFF1.Text = "11 NO ETIQUETADO, Recursos Fiscales"
                .lblFF2.Text = "14 NO ETIQUETADO, Recursos Propios"
                .lblFF3.Text = "15 NO ETIQUETADO, Recursos Federales"
                .lblFF4.Text = "25 ETIQUETADO, Recursos Federales"
                .lblRptDescripcionFiltrado.Text = "Avance Financiero al " + ultimo.Day.ToString + " de " & MesLetra(filterPeriodoFinal.EditValue.Month) & " Sólo Todas las Fuentes de Financiamiento"
            ElseIf rdEstatal.Checked = True Then
                .lblFF1.Text = "11 (NO ETIQUETADO, Recursos Fiscales)"
                .lblFF2.Text = "15 (NO ETIQUETADO, Recursos Federales)"
                .lblFF3.Text = ""
                .lblFF4.Text = ""
                .lblRptDescripcionFiltrado.Text = "Avance Financiero al " + ultimo.Day.ToString + " de " & MesLetra(filterPeriodoFinal.EditValue.Month) & " Sólo Recursos Estatales"

            ElseIf rdPropio.Checked = True Then
                .lblFF1.Text = "14 (NO ETIQUETADO, Recursos Propios)"
                .lblFF2.Text = ""
                .lblFF3.Text = ""
                .lblFF4.Text = ""
                .lblRptDescripcionFiltrado.Text = "Avance Financiero al " + ultimo.Day.ToString + " de " & MesLetra(filterPeriodoFinal.EditValue.Month) & " Sólo Recursos Propios"

            ElseIf rdFederal.Checked = True Then
                .lblFF1.Text = "25 (ETIQUETADO, Recursos Federales)"
                .lblFF2.Text = ""
                .lblFF3.Text = ""
                .lblFF4.Text = ""
                .lblRptDescripcionFiltrado.Text = "Avance Financiero al " + ultimo.Day.ToString + " de " & MesLetra(filterPeriodoFinal.EditValue.Month) & " Sólo Recursos Federales"
            Else
                .lblFF1.Text = ""
                .lblFF2.Text = ""
                .lblFF3.Text = ""
                .lblFF4.Text = ""
                .lblRptDescripcionFiltrado.Text = "Avance Financiero al ____ Sólo Recursos Federales"

            End If


            'If Me.REPORTE = 2 Or Me.REPORTE = 4 Then
            '    .label14.forecolor = Color.Transparent
            '    .label15.Borders = DevExpress.XtraPrinting.BorderSide.Top
            'End If
            .lblRptTituloTipo.Text = nomTipoReporte
            .lblRptnomClaves.Text = nomTipoClaves
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            'Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & FIRMAS & "'", New SqlConnection(cnnString))
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='IDEFT Presupuestales' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader


        End With

        '******* Firmas ******
        Dim adapterC As SqlClient.SqlDataAdapter
        'adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = " & "'" & Me.FIRMAS & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'IDEFT Presupuestales' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)

        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.Firmas.ReportSource.DataSource = dsC
        reporte.Firmas.ReportSource.DataAdapter = adapterC
        reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas2"



        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()

        reporte = Nothing
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub CtrlUser_RPT_Adquisiciones_OrdenCompraPartida_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        filterPeriodoInicio.EditValue = Now
        filterPeriodoFinal.EditValue = Now
        filterPeriodoAl.EditValue = Now

        '---Llenar listas

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
       

        With filterPartida.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With FilterCapitulo.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        '--------------------------------------------
        Dim SQLConexion As SqlConnection
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim iProv As Int16 = 0
        'iProv = filterProv.EditValue
        Dim sql As String = "Select Clave, Descripcion From C_FuenteFinanciamiento Where LEFT(Clave,2)= 11 OR LEFT(Clave,2)= 14 OR LEFT(Clave,2)= 15 OR LEFT(Clave,2)= 25 Order by IDFUENTEFINANCIAMIENTO "
        Dim command As New SqlCommand(sql, SQLConexion)
        Dim reader As SqlDataReader = command.ExecuteReader()

        chkFF.Items.Clear()
        While reader.Read
            chkFF.BeginUpdate()
            chkFF.Items.Add(reader.Item("Clave"))
            chkFF.EndUpdate()
        End While

        For x As Integer = 0 To chkFF.Items.Count - 1
            chkFF.SetItemChecked(x, True)
        Next

        AsignaReporte()

    End Sub

    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkAnual.CheckedChanged

        If ChkAnual.Checked = True Then
            filterPeriodoInicio.EditValue = ""
            filterPeriodoFinal.EditValue = ""
            chkAprAnual.Checked = False
            ChkAmpRed.Checked = False

        ElseIf ChkAnual.Checked = False Or filterPeriodoInicioAnt.EditValue = "" Or filterPeriodoFinalAnt.EditValue = "" Then
            filterPeriodoInicio.EditValue = Now
            filterPeriodoFinal.EditValue = Now
        End If

    End Sub
   
   
    Private Sub filterPartida_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartida.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub FilterCapitulo_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles FilterCapitulo.GotFocus

        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With FilterCapitulo.Properties
            .DataSource = ObjTempSQL2.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    'Private Sub ChkRelativo_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)

    '    If ChkRelativo.Checked = True And Me.REPORTE = 1 Then
    '        Me.SP = 1
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 2 Then
    '        Me.SP = 2
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 3 Then
    '        Me.SP = 3
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 4 Then
    '        Me.SP = 4
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 5 Then
    '        Me.SP = 5
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 6 Then
    '        Me.SP = 6
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 7 Then
    '        Me.SP = 7
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 8 Then
    '        Me.SP = 8
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 9 Then
    '        Me.SP = 9
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 10 Then
    '        Me.SP = 10
    '    ElseIf ChkRelativo.Checked = True And Me.REPORTE = 11 Then
    '        Me.SP = 22

    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 1 Then
    '        Me.SP = 11
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 2 Then
    '        Me.SP = 12
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 3 Then
    '        Me.SP = 13
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 4 Then
    '        Me.SP = 14
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 5 Then
    '        Me.SP = 15
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 6 Then
    '        Me.SP = 16
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 7 Then
    '        Me.SP = 17
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 8 Then
    '        Me.SP = 18
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 9 Then
    '        Me.SP = 19
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 10 Then
    '        Me.SP = 20
    '    ElseIf ChkRelativo.Checked = False And Me.REPORTE = 11 Then
    '        Me.SP = 23

    '    End If


    'End Su


    Private Sub SimpleButton5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton5.Click
        filterPartida.Properties.DataSource = Nothing
        filterPartida.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton6_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton6.Click
        FilterCapitulo.Properties.DataSource = Nothing
        FilterCapitulo.Properties.NullText = ""
    End Sub

    Private Sub chkTodo_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles chkTodo.CheckedChanged
        For x As Integer = 0 To chkFF.Items.Count - 1
            chkFF.SetItemChecked(x, chkTodo.Checked)
        Next
    End Sub

    Private Sub chkPropios_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs)

    End Sub

    Private Sub rdEstatal_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rdEstatal.CheckedChanged
        '--------------------------------------------
        Dim SQLConexion As SqlConnection
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim iProv As Int16 = 0
        'iProv = filterProv.EditValue
        Dim sql As String = "Select Clave, Descripcion From C_FuenteFinanciamiento Where LEFT(Clave,2)= 11 OR LEFT(Clave,2)= 15 Order by IDFUENTEFINANCIAMIENTO "
        Dim command As New SqlCommand(sql, SQLConexion)
        Dim reader As SqlDataReader = command.ExecuteReader()

        chkFF.Items.Clear()
        While reader.Read
            chkFF.BeginUpdate()
            chkFF.Items.Add(reader.Item("Clave"))
            chkFF.EndUpdate()
        End While

        For x As Integer = 0 To chkFF.Items.Count - 1
            chkFF.SetItemChecked(x, True)
        Next
    End Sub

    Private Sub rdPropio_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rdPropio.CheckedChanged
        '--------------------------------------------
        Dim SQLConexion As SqlConnection
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim iProv As Int16 = 0
        'iProv = filterProv.EditValue
        Dim sql As String = "Select Clave, Descripcion From C_FuenteFinanciamiento Where LEFT(Clave,2)= 14 Order by IDFUENTEFINANCIAMIENTO "
        Dim command As New SqlCommand(sql, SQLConexion)
        Dim reader As SqlDataReader = command.ExecuteReader()

        chkFF.Items.Clear()
        While reader.Read
            chkFF.BeginUpdate()
            chkFF.Items.Add(reader.Item("Clave"))
            chkFF.EndUpdate()
        End While

        For x As Integer = 0 To chkFF.Items.Count - 1
            chkFF.SetItemChecked(x, True)
        Next
    End Sub

    Private Sub rdFederal_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rdFederal.CheckedChanged
        '--------------------------------------------
        Dim SQLConexion As SqlConnection
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim iProv As Int16 = 0
        'iProv = filterProv.EditValue
        Dim sql As String = "Select Clave, Descripcion From C_FuenteFinanciamiento Where LEFT(Clave,2)= 25 Order by IDFUENTEFINANCIAMIENTO "
        Dim command As New SqlCommand(sql, SQLConexion)
        Dim reader As SqlDataReader = command.ExecuteReader()

        chkFF.Items.Clear()
        While reader.Read
            chkFF.BeginUpdate()
            chkFF.Items.Add(reader.Item("Clave"))
            chkFF.EndUpdate()
        End While

        For x As Integer = 0 To chkFF.Items.Count - 1
            chkFF.SetItemChecked(x, True)
        Next
    End Sub

    Private Sub rdTodo_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles rdTodo.CheckedChanged
        '--------------------------------------------
        Dim SQLConexion As SqlConnection
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim iProv As Int16 = 0
        'iProv = filterProv.EditValue 
        Dim sql As String = "Select Clave, Descripcion From C_FuenteFinanciamiento Where LEFT(Clave,2)= 11 OR LEFT(Clave,2)= 14 OR LEFT(Clave,2)= 15 OR LEFT(Clave,2)= 25 Order by IDFUENTEFINANCIAMIENTO "
        'Dim sql As String = "Select Clave, Descripcion From C_FuenteFinanciamiento Order by IDFUENTEFINANCIAMIENTO "
        Dim command As New SqlCommand(sql, SQLConexion)
        Dim reader As SqlDataReader = command.ExecuteReader()

        chkFF.Items.Clear()
        While reader.Read
            chkFF.BeginUpdate()
            chkFF.Items.Add(reader.Item("Clave"))
            chkFF.EndUpdate()
        End While

        For x As Integer = 0 To chkFF.Items.Count - 1
            chkFF.SetItemChecked(x, True)
        Next
    End Sub
End Class