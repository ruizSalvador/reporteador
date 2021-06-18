Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_EstadodelEjerciciodelPresupuestoGral2

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

    'Public Sub New(ByVal SP As Integer, ByVal REPORTE As Integer)
    '    Me.SP = SP
    '    Me._REPORTE = REPORTE

    '    InitializeComponent()
    'End Sub
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
        Me.nomREPORTE = "Control Presupuestal del Egreso"
        Me.TITULO = ""
        Me.nomTipoReporte = ""
        Me.nomTipoClaves = ""
        Me.FIRMAS = "Control Presupuestal del Egreso"
        Me.SP = 21
        rpt = New RPT_ControlPresupuestalEgresos()
        Return rpt


            
    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True

        Dim reporte = New Object()
        reporte = AsignaReporte()
        Dim printTool As New ReportPrintTool(reporte)

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_EstadoEjercicioPresupuestoEGR", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN

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

        If filterFuenteFinanciamiento.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", filterFuenteFinanciamiento.Properties.KeyValue))
        End If

        If filterFuenteFinanciamiento.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", ""))

        End If

        'Está en cero por cambio pendiente
        SQLComando.Parameters.AddWithValue("@IdArea", 0)
        'Está en cero por cambio pendiente
        SQLComando.Parameters.AddWithValue("@AprAnual", 0)
        'Está en cero por cambio pendiente
        SQLComando.Parameters.AddWithValue("@AmpRedAnual", 0)
        'Está en cero por cambio pendiente
        SQLComando.Parameters.AddWithValue("@IdSello", 0)
        'Está en cero por cambio pendiente
        SQLComando.Parameters.AddWithValue("@IdSelloFin", 0)
        'Está en cero por cambio pendiente
        SQLComando.Parameters.AddWithValue("@IdPartida", 0)
        'Está en cero por cambio pendiente
        SQLComando.Parameters.AddWithValue("@IdCapitulo", 0)


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_EstadoEjercicioPresupuestoEGR")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_EstadoEjercicioPresupuestoEGR"
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
            .lblRptNombreReporte.Text = nomREPORTE
            '.lblFechaRango.Text = ""
            .lblTitulo.Text = TITULO
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            .lblMes.Text = MesLetra(Month(filterPeriodoInicio.Time.Date))
            If ChkAnual.Checked = False Then
                .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) '& " del " & filterPeriodoAl.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString()    '"Del " & Primer & " al " & Ultimo
            ElseIf ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            End If

            ' ASC
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            If ChkAnual.Checked = False Then

                If TypeOf reporte Is RPT_EstadoEjercicioPresupuestal2Niveles Then


                    .lblRptDescripcionFiltrado.Text = "Del " + primero.ToString("dd/MM/yyyy") + " Al " + ultimo.ToString("dd/MM/yyyy")
                    '.label42.text = "TOTAL DE GASTO"
                Else
                    .lblRptDescripcionFiltrado.Text = "Del 01 de " & MesLetra(1) & " " & filterPeriodoAl.EditValue.Year.ToString & " al " + ultimo.Day.ToString + " de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " " & filterPeriodoAl.EditValue.Year.ToString
                End If

            ElseIf ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            End If


            If Me.REPORTE = 4 Then
                '.label42.text = "Totales"
                .label13.text = "Concepto"
                If ChkAnual.Checked = False Then
                    .lblRptDescripcionFiltrado.Text = "Del " + primero.ToString("dd/MM/yyyy") + " Al " + ultimo.ToString("dd/MM/yyyy")
                End If
            End If

            If Me.REPORTE = 2 Or Me.REPORTE = 4 Then
                .label14.forecolor = Color.Transparent
                .label15.Borders = DevExpress.XtraPrinting.BorderSide.Top
            End If
            .lblRptTituloTipo.Text = nomTipoReporte
            '--.lblRptnomClaves.Text = nomTipoClaves
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & FIRMAS & "'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader


        End With

        '******* Firmas ******
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = " & "'" & Me.FIRMAS & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        reporte.Firmas.ReportSource.DataSource = dsC
        reporte.Firmas.ReportSource.DataAdapter = adapterC
        reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas"



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
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        AsignaReporte()

    End Sub



    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkAnual.CheckedChanged

        If ChkAnual.Checked = True Then
            filterPeriodoInicio.EditValue = ""
            filterPeriodoFinal.EditValue = ""

        ElseIf ChkAnual.Checked = False Or filterPeriodoInicioAnt.EditValue = "" Or filterPeriodoFinalAnt.EditValue = "" Then
            filterPeriodoInicio.EditValue = Now
            filterPeriodoFinal.EditValue = Now
        End If


    End Sub

    Private Sub ChkRelativo_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkRelativo.CheckedChanged

        If ChkRelativo.Checked = True And Me.REPORTE = 1 Then
            Me.SP = 1
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 2 Then
            Me.SP = 2
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 3 Then
            Me.SP = 3
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 4 Then
            Me.SP = 4
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 5 Then
            Me.SP = 5
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 6 Then
            Me.SP = 6
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 7 Then
            Me.SP = 7
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 8 Then
            Me.SP = 8
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 9 Then
            Me.SP = 9
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 10 Then
            Me.SP = 10

        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 1 Then
            Me.SP = 11
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 2 Then
            Me.SP = 12
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 3 Then
            Me.SP = 13
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 4 Then
            Me.SP = 14
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 5 Then
            Me.SP = 15
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 6 Then
            Me.SP = 16
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 7 Then
            Me.SP = 17
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 8 Then
            Me.SP = 18
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 9 Then
            Me.SP = 19
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 10 Then
            Me.SP = 20

        End If


    End Sub


    Private Sub filterRamoDependencia_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterFuenteFinanciamiento.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterFuenteFinanciamiento.Properties.DataSource = Nothing
        filterFuenteFinanciamiento.Properties.NullText = ""
    End Sub


End Class