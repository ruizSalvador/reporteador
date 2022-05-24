Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_InformProgramEstadodelEjerciciodelPresupuestoEGR


    Dim _SP As Integer
    Dim _REPORTE As Integer


    Dim _nomREPORTE As String
    Dim _TITULO As String
    Dim _SUBTITULO As String
    Dim _nomTipoReporte As String
    Dim _nomTipoClaves As String
    Dim _nomTipoClaves1 As String
    Dim _nomTipoClaves2 As String
    Dim _nomTipoClaves3 As String
    Dim _nomTipoClaves4 As String
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

    Public Property nomTipoClaves1 As String
        Get
            Return _nomTipoClaves1
        End Get
        Set(ByVal value As String)
            _nomTipoClaves1 = value
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
    Public Property nomTipoClaves3 As String
        Get
            Return _nomTipoClaves3
        End Get
        Set(ByVal value As String)
            _nomTipoClaves3 = value
        End Set
    End Property
    Public Property nomTipoClaves4 As String
        Get
            Return _nomTipoClaves4
        End Get
        Set(ByVal value As String)
            _nomTipoClaves4 = value
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
                Me.nomREPORTE = "Informe Programático"
                Me.TITULO = "Ramo o Dependencia / Función / Programa Presupuestario / Actividad Institucional"
                Me.SUBTITULO = filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "Ramo"
                Me.nomTipoClaves1 = "Función"
                Me.nomTipoClaves2 = "Programa"
                Me.nomTipoClaves3 = "Actividad"
                Me.FIRMAS = "Por Ramo / Función / Programa / Actividad"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal4Colum3Niveles()
                Return rpt

            Case 2
                Me.nomREPORTE = "Informe Programático"
                Me.TITULO = "Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo"
                Me.SUBTITULO = filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text & " - " & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "UR"
                Me.nomTipoClaves1 = "Programa"
                Me.nomTipoClaves2 = "Actividad"
                Me.nomTipoClaves3 = "Objeto"
                Me.FIRMAS = "Por Ramo/ UR / Programa / Actividad / objeto del Gasto Capítulo"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal5Colum4Niveles()
                Me.filterUnidadResponsable.Enabled = True
                Me.SimpleButton4.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.SimpleButton4.Visible = True
                Me.LabelControl3.Visible = True
                Me.LabelControl3.Enabled = True
                Return rpt


            Case 3
                Me.nomREPORTE = "" '"Informe Programático"
                Me.TITULO = "Gasto por Categoria Programatica" '"Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica"
                Me.SUBTITULO = "" 'filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text
                Me.nomTipoReporte = "" '"Ejercicio del Presupuesto"
                Me.nomTipoClaves = "Programa"
                Me.nomTipoClaves1 = "Actividad"
                Me.nomTipoClaves2 = "Objeto"
                Me.nomTipoClaves3 = "Clasif. Económica"
                Me.FIRMAS = "Ramo o Dependencia /Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Capítulo / Clasificación Económica"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal5Colum4NivelesAV2()
                Return rpt


            Case 4
                Me.nomREPORTE = "Informe Programático"
                Me.TITULO = "Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento"
                Me.SUBTITULO = filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text & " - " & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "UR"
                Me.nomTipoClaves1 = "Programa"
                Me.nomTipoClaves2 = "Actividad"
                Me.nomTipoClaves3 = "Objeto"
                Me.nomTipoClaves4 = "Fuente Financiam"
                Me.FIRMAS = "Por Ramo / UR / Programa / Actividad  / Objeto Gasto Partida / Fuente de Financiamiento"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal6Colum5Niveles()
                Me.filterUnidadResponsable.Enabled = True
                Me.SimpleButton4.Enabled = True
                Me.filterUnidadResponsable.Visible = False
                Me.SimpleButton4.Visible = False
                Me.LabelControl3.Visible = False
                Me.LabelControl3.Enabled = True
                Me.lblUR2.Visible = True
                Me.chkListUR.Visible = True
                Return rpt


            Case 5
                Me.nomREPORTE = "Informe Programático"
                Me.TITULO = "Ramo o Dependencia / Unidad Responsable / Programa Presupuestario / Actividad Institucional / Objeto del Gasto por Partida Genérica / Distribución Georgráfica"
                Me.SUBTITULO = filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text & " - " & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "UR"
                Me.nomTipoClaves1 = "Programa"
                Me.nomTipoClaves2 = "Actividad"
                Me.nomTipoClaves3 = "Objeto"
                Me.nomTipoClaves4 = "Distrib. Geográfica"
                Me.FIRMAS = "Por Ramo / UR / Programa/ Actividad/ Objeto Gasto Partida / Distribución Georgráfica"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal6Colum5Niveles()
                Me.filterUnidadResponsable.Enabled = True
                Me.SimpleButton4.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.SimpleButton4.Visible = True
                Me.LabelControl3.Visible = True
                Me.LabelControl3.Enabled = True
                Return rpt


            Case 6
                Me.nomREPORTE = "Informe Programático"
                Me.TITULO = "Ramo o Dependencia / Función / Programas y Proyectos de Inversión"
                Me.SUBTITULO = filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "Función"
                Me.nomTipoClaves1 = "Programa"
                Me.nomTipoClaves2 = "Proyecto"
                Me.FIRMAS = "Por Ramo / Función / Proyecto Inversión"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal4Colum3NivelesProy()
                Return rpt


            Case 7
                Me.nomREPORTE = "Informe Programático"
                Me.TITULO = "Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Capítulo / Clasificación Económica"
                Me.SUBTITULO = filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text & " - " & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "UR"
                Me.nomTipoClaves1 = "Programa"
                Me.nomTipoClaves2 = "Proyecto"
                Me.nomTipoClaves3 = "Objeto"
                Me.nomTipoClaves4 = "Clasif. Económica"
                Me.FIRMAS = "Por Ramo / UR / Proyecto/ Objeto Gasto Capítulo / Clasificación Económica"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal6Colum6NivelesProy()
                Me.filterUnidadResponsable.Enabled = True
                Me.SimpleButton4.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.SimpleButton4.Visible = True
                Me.LabelControl3.Visible = True
                Me.LabelControl3.Enabled = True
                Return rpt


            Case 8
                Me.nomREPORTE = "Informe Programático"
                Me.TITULO = "Ramo o Dependencia / Unidad Responsable / Programas y Proyectos de Inversión / Objeto del Gasto por Partida Genérica / Fuente de Financiamiento"
                Me.SUBTITULO = filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text & " - " & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "UR"
                Me.nomTipoClaves1 = "Programa"
                Me.nomTipoClaves2 = "Proyecto"
                Me.nomTipoClaves3 = "Objeto"
                Me.nomTipoClaves4 = "Fuente Financiam"
                Me.FIRMAS = "Por Ramo / UR / Proyecto/ Objeto Gasto Partida/ Fuente de Financiamiento"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal6Colum5NivelesProy()
                Me.filterUnidadResponsable.Enabled = True
                Me.SimpleButton4.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.SimpleButton4.Visible = True
                Me.LabelControl3.Visible = True
                Me.LabelControl3.Enabled = True
                Return rpt


            Case 9
                Me.nomREPORTE = "Informe Programático"
                Me.TITULO = "Ramo o Dependencia / Distribución Geográfica / Programas y Proyectos de Inversión"
                Me.SUBTITULO = filterRamoDependenciaDe.Text & " - " & filterRamoDependenciaA.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "Dist.Geog."
                Me.nomTipoClaves1 = "Programa"
                Me.nomTipoClaves2 = "Proyecto"
                Me.FIRMAS = "Por Ramo/ Distribución Geográfica /Proyecto"
                rpt = New RPT_InformProgramEdoEjercicioPresupuestal4Colum3NivelesProy()
                Return rpt


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
        If chkListUR.CheckedItems.Count <> 0 Then

            Dim x As Integer

            For x = 0 To chkListUR.CheckedItems.Count - 1
                'ControlChars.CrLf
                str = str & "," & "'" & chkListUR.CheckedItems(x).ToString & "'"
            Next x
        End If

        Dim cadena As String = ""
        If str <> "" Then
            cadena = str.Remove(0, 1)
        End If
        

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codigo para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN

        If ChkAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", 1))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", 12))
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))


        ElseIf ChkAnual.Checked = False Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoInicio.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFinal.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))
        End If

        If filterRamoDependenciaDe.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Clave", filterRamoDependenciaDe.Properties.KeyValue))

        End If

        If filterRamoDependenciaDe.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Clave", ""))

        End If


        If filterRamoDependenciaA.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Clave2", filterRamoDependenciaA.Properties.KeyValue))

        End If

        If filterRamoDependenciaA.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Clave2", ""))

        End If


        If filterUnidadResponsable.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", filterUnidadResponsable.Properties.KeyValue))

        End If


        If filterUnidadResponsable.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", ""))

        End If

        If filterEstructuraProgramatica.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdEP", filterEstructuraProgramatica.Properties.KeyValue))

        End If


        If filterEstructuraProgramatica.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdEP", ""))

        End If
        SQLComando.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@AmpAnual", chkAmpAnual.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@RedAnual", chkRedAnual.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@CadenaUR", cadena))



        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        adapter.SelectCommand.CommandTimeout = 0
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_InformeProgramaEstadoEjercicioPresupuestoEGR"
        SQLComando.Dispose()
        SQLConexion.Close()

        '--Fin SP


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes
        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne


        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblRptNombreReporte.Text = nomREPORTE
            '.lblFechaRango.Text = ""
            .lblTitulo.Text = TITULO
            .lblSubtitulo.Text = SUBTITULO
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            If ChkAnual.Checked = False Then
                If TypeOf reporte Is RPT_InformProgramEdoEjercicioPresupuestal5Colum4NivelesAV2 Then
                    Dim primero As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoInicio.Time.Month, 1)
                    Dim ultimo As Date = New DateTime(filterPeriodoAl.Time.Year, filterPeriodoFinal.Time.Month, 1)
                    ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)

                    .lblRptDescripcionFiltrado.Text = "Del " + primero.ToString("dd/MM/yyyy") + " Al " + ultimo.ToString("dd/MM/yyyy")
                    .label42.text = "TOTAL DE GASTO"
                Else
                    '.lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoInicio.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoFinal.EditValue.Year.ToString    '"Del " & Primer & " al " & Ultimo
                    .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.Text & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.Text    '"Del " & Primer & " al " & Ultimo

                End If

            ElseIf ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            End If

            .lblRptTituloTipo.Text = nomTipoReporte
            .lblRptnomClaves.Text = nomTipoClaves
            .lblRptnomClaves1.Text = nomTipoClaves1
            .lblRptnomClaves2.Text = nomTipoClaves2
            .lblRptnomClaves3.Text = nomTipoClaves3
            If TypeOf reporte Is RPT_InformProgramEdoEjercicioPresupuestal5Colum4NivelesAV2 Then
            Else
                .lblRptnomClaves4.Text = nomTipoClaves4
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
        With filterRamoDependenciaDe.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_RamoPresupuestal", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL3 As New clsRPT_CFG_DatosEntesCtrl
        With filterRamoDependenciaA.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_RamoPresupuestal", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
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

        AsignaReporte()

        '--------------------------------------------
        Dim SQLConexion As SqlConnection
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim iProv As Int16 = 0
        'iProv = filterProv.EditValue
        Dim sql As String = "Select Clave, Nombre From C_AreaResponsabilidad Order by IdAreaResp "
        Dim command As New SqlCommand(sql, SQLConexion)
        Dim reader As SqlDataReader = command.ExecuteReader()

        chkListUR.Items.Clear()
        While reader.Read
            chkListUR.BeginUpdate()
            chkListUR.Items.Add(reader.Item("Clave"))
            chkListUR.EndUpdate()
        End While
        
        'CheckBox1.Checked = False

    End Sub



    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkAnual.CheckedChanged

        If ChkAnual.Checked = True Then
            filterPeriodoInicio.EditValue = ""
            filterPeriodoFinal.EditValue = ""
            chkAprAnual.Checked = False
            chkAmpAnual.Checked = False
            chkRedAnual.Checked = False

        ElseIf ChkAnual.Checked = False And filterPeriodoInicioAnt.EditValue = "" And filterPeriodoFinalAnt.EditValue = "" Then
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



        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 1 Then
            Me.SP = 10
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 2 Then
            Me.SP = 11
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 3 Then
            Me.SP = 12
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 4 Then
            Me.SP = 13
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 5 Then
            Me.SP = 14
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 6 Then
            Me.SP = 15
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 7 Then
            Me.SP = 16
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 8 Then
            Me.SP = 17
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 9 Then
            Me.SP = 18



        End If


    End Sub

    Private Sub filterRamoDependenciaDe_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterRamoDependenciaDe.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterRamoDependenciaDe.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_RamoPresupuestal", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterRamoDependenciaA_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterRamoDependenciaA.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterRamoDependenciaA.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_RamoPresupuestal", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "CLAVE"
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

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterRamoDependenciaDe.Properties.DataSource = Nothing
        filterRamoDependenciaDe.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        filterEstructuraProgramatica.Properties.DataSource = Nothing
        filterEstructuraProgramatica.Properties.NullText = ""
    End Sub

    Private Sub LabelControl1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles LabelControl1.Click

    End Sub

    Private Sub filterRamoDependenciaA_EditValueChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles filterRamoDependenciaA.EditValueChanged

    End Sub

    Private Sub SimpleButton5_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton5.Click
        filterRamoDependenciaA.Properties.DataSource = Nothing
        filterRamoDependenciaA.Properties.NullText = ""
    End Sub

End Class
