Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_Comparativo_Calendarizado_Pres


    Dim _SP As Integer
    Dim _REPORTE As Integer


    Dim _nomREPORTE As String
    Dim _TITULO As String
    Dim _SUBTITULO As String
    Dim _nomTipoReporte As String
    Dim _nomTipoClaves As String
    Dim _nomTipoClaves2 As String
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
        Me.SP = 13
        Me._REPORTE = 14

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

    Public Property SUBTITULO As String
        Get
            Return _SUBTITULO
        End Get
        Set(ByVal value As String)
            _SUBTITULO = value
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

    Public Property nomTipoClaves2 As String
        Get
            Return _nomTipoClaves2
        End Get
        Set(ByVal value As String)
            _nomTipoClaves2 = value
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

            
            Case 14
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Programa - Objeto del gasto por Capítulo"
                Me.SUBTITULO = filterRamoDependencia.Text & "-" & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Capítulo"
                Me.nomTipoClaves2 = "Concepto"
                Me.FIRMAS = "Por Ramo / UR / Programa / Objeto Gasto por Capítulo"
                rpt = New RPT_Comparativo_Calendarizado_Pres()
                Me.filterUnidadResponsable.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Enabled = True
                Me.LblCategoriaProgramatica.Enabled = True
                Me.filterEstructuraProgramatica.Enabled = True
                Me.CleanCategoriaProgramatica.Enabled = True
                Me.LblCategoriaProgramatica.Visible = True
                Me.filterEstructuraProgramatica.Visible = True
                Me.CleanCategoriaProgramatica.Visible = True
                Me.LblPartida.Visible = True
                Me.filterPartida.Visible = True
                Me.CleanPartida.Visible = True
                Me.LblFuenteFinanciameinto.Visible = True
                Me.filterFuenteFinanciamiento.Visible = True
                Me.CleanFuenteFinanciamiento.Visible = True

                Return rpt


            Case Else
                MessageBox.Show("Hubo un error", "Error2", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return Nothing
        End Select
    End Function

    Public Sub FillLookUp()
        cmbMomentos.Properties.Columns.Add(New DevExpress.XtraEditors.Controls.LookUpColumnInfo("Key", "Nombre"))
        cmbMomentos.Properties.Columns.Add(New DevExpress.XtraEditors.Controls.LookUpColumnInfo("Value", "Valor"))
        Dim dic As New Dictionary(Of String, Integer)
        dic.Add("Modificado vs Comprometido", 1)
        dic.Add("Modificado vs Devengado ", 2)
        dic.Add("Devengado vs Comprometido", 3)
        cmbMomentos.Properties.DisplayMember = "Key"
        cmbMomentos.Properties.ValueMember = "Value"
        cmbMomentos.Properties.DataSource = New BindingSource(dic, "")
        cmbMomentos.Properties.Columns("Value").Visible = False
        cmbMomentos.ItemIndex = 0
    End Sub


    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click


        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True


        Dim reporte = New Object()
        'reporte = New RPT_Comparativo_Calendarizado_Pres()
        reporte = AsignaReporte()
        Dim printTool As New ReportPrintTool(reporte)

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codigo para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("RPT_SP_Comparativo_Calendarizado_Pres", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN


        If ChkAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@PeriodoFin", 12))

        ElseIf ChkAnual.Checked = False Then
            SQLComando.Parameters.Add(New SqlParameter("@PeriodoFin", Month(filterPeriodoInicio.EditValue)))

        End If

        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))

        If filterCapitulo.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", Convert.ToInt32(filterCapitulo.EditValue)))
        End If

        If filterCapitulo.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", 0))

        End If

        If filterPartida.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida", Convert.ToInt32(filterPartida.Text)))
        End If

        If filterPartida.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida", 0))
        End If



        If filterUnidadResponsable.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdUR", filterUnidadResponsable.EditValue))

        End If

        If filterUnidadResponsable.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdUR", ""))

        End If

        If filterRamoDependencia.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdDepto", filterRamoDependencia.EditValue))

        End If
        If filterRamoDependencia.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdDepto", ""))

        End If


        If filterEstructuraProgramatica.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveProg", filterEstructuraProgramatica.EditValue))

        End If


        If filterEstructuraProgramatica.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveProg", ""))

        End If


        If filterFuenteFinanciamiento.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdFF", filterFuenteFinanciamiento.EditValue))
        End If

        If filterFuenteFinanciamiento.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdFF", ""))

        End If


        SQLComando.Parameters.Add(New SqlParameter("@Tipo", cmbMomentos.EditValue))
        'SQLComando.Parameters.Add(New SqlParameter("@Anual", ChkAprAnual.Checked))
        'SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", chkAmpRedAnual.Checked))



        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "RPT_SP_Comparativo_Calendarizado_Pres")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "RPT_SP_Comparativo_Calendarizado_Pres"
        SQLComando.Dispose()
        SQLConexion.Close()

        '--Fin SP


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne


        '--- Llenar datos del ente
        With reporte

            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = ""
            .lblRptNombreReporte.Text = txtTitulo.Text
            '.lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblRptDescripcionFiltrado.Text = "Periodo: del " & filterPeriodoDe.DateTime.Date.ToShortDateString & " Al " & filterPeriodoAl.DateTime.Date.ToShortDateString
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario

            If ChkAnual.Checked = False Then
                .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString
            ElseIf ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(12) & " del " & filterPeriodoAl.EditValue.Year.ToString
            End If


            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & Me.FIRMAS & "'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader

        End With

        '******* Firmas ******
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = " & "'" & Me.FIRMAS & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
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
        With filterRamoDependencia.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_Departamentos", " Order by IdDepartamento ")
            .DisplayMember = "NombreDepartamento"
            .ValueMember = "IdDepartamento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL1.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With



        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterEstructuraProgramatica.Properties
            .DataSource = ObjTempSQL2.List(" Ejercicio =" & Year(filterPeriodoAl.EditValue), 0, "VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR", " Order by Id ")
            .DisplayMember = "Proyecto"
            .ValueMember = "Id"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL3 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida.Properties
            .DataSource = ObjTempSQL3.List("", 0, "C_PartidasPres", " Order by IdPartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL4 As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        With filterCapitulo.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        AsignaReporte()
        FillLookUp()


    End Sub



    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkAnual.CheckedChanged

        If ChkAnual.Checked = True Then
            filterPeriodoInicio.Enabled = False
            'filterPeriodoFinal.EditValue = ""


        ElseIf ChkAnual.Checked = False Then
            'And String.IsNullOrEmpty(filterPeriodoInicio.EditValue) Then
            'And String.IsNullOrEmpty(filterPeriodoFinal.EditValue) Then
            filterPeriodoInicio.Enabled = True
            'filterPeriodoInicio.EditValue = Now
            'filterPeriodoFinal.EditValue = Now
        End If


    End Sub


    Private Sub filterPartida_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartida.GotFocus

        If REPORTE = 16 Then
            Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
            With filterPartida.Properties
                .DataSource = ObjTempSQL.List("", 0, "C_PartidasGenericasPres", " Order by ClavePartida ")
                .DisplayMember = "ClavePartida"
                .ValueMember = "ClavePartida"
                .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
                .NullText = ""
                .ShowHeader = True
            End With
        Else
            Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
            With filterPartida.Properties
                .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by IdPartida ")
                .DisplayMember = "ClavePartida"
                .ValueMember = "ClavePartida"
                .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
                .NullText = ""
                .ShowHeader = True
            End With
        End If
    End Sub


    Private Sub filterRamoDependencia_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterRamoDependencia.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterRamoDependencia.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_Departamentos", " Order by IdDepartamento ")
            .DisplayMember = "NombreDepartamento"
            .ValueMember = "IdDepartamento"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterUnidadResponsable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL1.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub


    Private Sub filterFuenteFinanciamiento_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterFuenteFinanciamiento.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterCapitulo_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterCapitulo.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterCapitulo.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_CapitulosNEP", " Order by IdCapitulo ")
            .DisplayMember = "IdCapitulo"
            .ValueMember = "IdCapitulo"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanRamoOdependencia.Click
        filterRamoDependencia.Properties.DataSource = Nothing
        filterRamoDependencia.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanUnidadResponsable.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
    End Sub


    Private Sub filterEstructuraProgramatica_GotFocus(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterEstructuraProgramatica.GotFocus
        Dim ObjTempSQL2 As New clsRPT_CFG_DatosEntesCtrl
        With filterEstructuraProgramatica.Properties
            .DataSource = ObjTempSQL2.List("Ejercicio=" & Year(filterPeriodoAl.EditValue), 0, "VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR", " Order by Id ")
            .DisplayMember = "Proyecto"
            .ValueMember = "Id"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles CleanCategoriaProgramatica.Click
        filterEstructuraProgramatica.Properties.DataSource = Nothing
        filterEstructuraProgramatica.Properties.NullText = ""
    End Sub

    Private Sub LabelControl1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LblRamoDependencia.Click

    End Sub

    Private Sub filterUnidadResponsable_EditValueChanged(sender As System.Object, e As System.EventArgs) Handles filterUnidadResponsable.EditValueChanged

    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs) Handles CleanPartida.Click
        filterPartida.Properties.DataSource = Nothing
        filterPartida.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton6_Click(sender As System.Object, e As System.EventArgs) Handles CleanFuenteFinanciamiento.Click
        filterFuenteFinanciamiento.Properties.DataSource = Nothing
        filterFuenteFinanciamiento.Properties.NullText = ""
    End Sub


    Private Sub CleanProgramaOperativo_Click(sender As System.Object, e As System.EventArgs) Handles CleanProgramaOperativo.Click
        filterCapitulo.Properties.DataSource = Nothing
        filterCapitulo.Properties.NullText = ""
    End Sub

End Class