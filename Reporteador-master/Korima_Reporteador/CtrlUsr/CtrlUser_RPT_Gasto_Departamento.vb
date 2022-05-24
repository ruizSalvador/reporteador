Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Gasto_Departamento

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

    Public Sub New()
        'Me.SP = SP
        'Me._REPORTE = REPORTE

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
      
        Me.nomREPORTE = "Gasto por Departamento"
                'Me.TITULO = "Partida Genérica y Fuente de Financiamiento"
        Me.nomTipoReporte = "Gasto por Departamento"
                Me.nomTipoClaves = "Id"
                'Me.FIRMAS = "Por Partida/Fuente de Financiamiento"
        rpt = New RPT_Gasto_Departamento()
                Me.filterDepto.Enabled = True
                Me.SimpleButton2.Enabled = True
                Me.LabelControl3.Enabled = True
                Me.filterDepto.Visible = True
                Me.SimpleButton2.Visible = True
                Me.LabelControl3.Visible = True

                Me.filterPartidaHasta.Enabled = True
                Me.SimpleButton4.Enabled = True
                Me.LabelControl7.Enabled = True
                Me.filterPartidaHasta.Visible = True
                Me.SimpleButton4.Visible = True
                Me.LabelControl7.Visible = True

                Me.filterPartida.Enabled = True
                Me.SimpleButton3.Enabled = True
                Me.LabelControl6.Enabled = True
                Me.filterPartida.Visible = True
                Me.SimpleButton3.Visible = True
                Me.LabelControl6.Visible = True
                Me.lblProgramaOperativo.Visible = True
                Me.filterDeptoHasta.Visible = True
                Me.CleanProgramaOperativo.Visible = True


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
        Dim SQLComando As New SqlCommand("SP_RPT_Gasto_Departamento", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN


        SQLComando.Parameters.Add(New SqlParameter("@Mes1", Month(filterPeriodoInicio.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFinal.EditValue)))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio1", Year(filterPeriodoAl.EditValue)))



        If filterDepto.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdDepto1", Convert.ToInt32(filterDepto.EditValue)))
        End If

        If filterDepto.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdDepto1", 0))
        End If


        If filterDeptoHasta.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdDepto2", Convert.ToInt32(filterDeptoHasta.EditValue)))
        End If

        If filterDeptoHasta.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdDepto2", 0))
        End If

        If filterPartida.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida1", Convert.ToInt32(filterPartida.EditValue)))
        End If

        If filterPartida.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida1", 0))

        End If

        If filterPartidaHasta.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida2", Convert.ToInt32(filterPartidaHasta.EditValue)))
        End If

        If filterPartidaHasta.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida2", 0))

        End If


        'If chkAprAnual.Checked = True Then
        '    SQLComando.Parameters.Add(New SqlParameter("@AprAnual", 1))
        'Else
        '    SQLComando.Parameters.Add(New SqlParameter("@AprAnual", 0))
        'End If
        'SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", ChkAmpRed.Checked))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_Gasto_Departamento")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_Gasto_Departamento"
        SQLComando.Dispose()
        SQLConexion.Close()

        '--Fin SP


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne


        Dim lastDay As DateTime = (New DateTime(Year(filterPeriodoAl.EditValue), Month(filterPeriodoInicio.EditValue), 1))

        Dim Primer As String
        Dim Ultimo As String

        Primer = "01" & "/" & Format((CDate(filterPeriodoInicio.EditValue)).Month, "0#") & "/" & (CDate(filterPeriodoAl.EditValue)).Year
        Ultimo = Date.DaysInMonth((CDate(filterPeriodoAl.EditValue)).Year, (CDate(filterPeriodoFinal.EditValue)).Month) & "/" & Format((CDate(filterPeriodoFinal.EditValue)).Month, "0#") & "/" & (CDate(filterPeriodoAl.EditValue)).Year
        'Dim reporte = New Object()





        '--- Llenar datos del ente
        With reporte

            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = nomREPORTE
            .lblRptDescripcionFiltrado.Text = "Del " & Primer & " al " & Ultimo
            .lblTitulo.Text = TITULO
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            '.PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            'If ChkAnual.Checked = False Then
            '    .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString()    '"Del " & Primer & " al " & Ultimo
            'ElseIf ChkAnual.Checked = True Then
            '    .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            'End If

            ' ASC
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            'If ChkAnual.Checked = False Then

            '    If TypeOf reporte Is RPT_EstadoEjercicioPresupuestal2Niveles Then


            '        '.lblRptDescripcionFiltrado.Text = "Del " + primero.ToString("dd/MM/yyyy") + " Al " + ultimo.ToString("dd/MM/yyyy")
            '        '.label42.text = "TOTAL DE GASTO"
            '    Else
            '        '.lblRptDescripcionFiltrado.Text = "Del 01 de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " " & filterPeriodoAl.EditValue.Year.ToString & " al " + ultimo.Day.ToString + " de " & MesLetra(filterPeriodoFinal.EditValue.Month) & " " & filterPeriodoAl.EditValue.Year.ToString
            '    End If

            'ElseIf ChkAnual.Checked = True Then
            '    .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            'End If


            'If Me.REPORTE = 4 Then
            '    '.label42.text = "Totales"
            '    .label13.text = "Concepto"
            '    If ChkAnual.Checked = False Then
            '        '.lblRptDescripcionFiltrado.Text = "Del " + primero.ToString("dd/MM/yyyy") + " Al " + ultimo.ToString("dd/MM/yyyy")
            '    End If
            'End If

            'If Me.REPORTE = 2 Or Me.REPORTE = 4 Then
            '    .label14.forecolor = Color.Transparent
            '    .label15.Borders = DevExpress.XtraPrinting.BorderSide.Top
            'End If

            '.lblRptTituloTipo.Text = nomTipoReporte
            '.lblRptnomClaves.Text = nomTipoClaves
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & FIRMAS & "'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader


        End With

        '******* Firmas ******
        'Dim adapterC As SqlClient.SqlDataAdapter
        'adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = " & "'" & Me.FIRMAS & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
        'Dim dsC As New DataSet()
        'dsC.EnforceConstraints = False
        'adapterC.Fill(dsC, "VW_RPT_K2_Firmas")
        'reporte.Firmas.ReportSource.DataSource = dsC
        'reporte.Firmas.ReportSource.DataAdapter = adapterC
        'reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas"



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
        With filterDepto.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_Departamentos", " Order by IdDepartamento ")
            .DisplayMember = "NombreDepartamento"
            .ValueMember = "IdDepartamento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        With filterPartidaHasta.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        With filterPartida.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With filterDeptoHasta.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_Departamentos", " Order by IdDepartamento ")
            .DisplayMember = "NombreDepartamento"
            .ValueMember = "IdDepartamento"
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

        If ChkRelativo.Checked = True Then 'And Me.REPORTE = 1 Then
            Me.SP = 1

        ElseIf ChkRelativo.Checked = False Then 'And Me.REPORTE = 1 Then
            Me.SP = 2

        End If


    End Sub

    'filterFuenteFinanciamiento
    Private Sub filterDepto_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterDepto.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterDepto.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_Departamentos", " Order by IdDepartamento ")
            .DisplayMember = "NombreDepartamento"
            .ValueMember = "IdDepartamento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    'filterUnidadResponsable
    Private Sub filterPartidaHasta_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartidaHasta.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterPartidaHasta.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterDeptoHasta_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterDeptoHasta.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterDeptoHasta.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_Departamentos", " Order by IdDepartamento ")
            .DisplayMember = "NombreDepartamento"
            .ValueMember = "IdDepartamento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    'filterPartida

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


    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterDepto.Properties.DataSource = Nothing
        filterDepto.Properties.NullText = ""
    End Sub


    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        filterPartidaHasta.Properties.DataSource = Nothing
        filterPartidaHasta.Properties.NullText = ""
    End Sub


    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        filterPartida.Properties.DataSource = Nothing
        filterPartida.Properties.NullText = ""
    End Sub


    Private Sub CleanProgramaOperativo_Click(sender As System.Object, e As System.EventArgs) Handles CleanProgramaOperativo.Click
        filterDeptoHasta.Properties.DataSource = Nothing
        filterDeptoHasta.Properties.NullText = ""
    End Sub
End Class