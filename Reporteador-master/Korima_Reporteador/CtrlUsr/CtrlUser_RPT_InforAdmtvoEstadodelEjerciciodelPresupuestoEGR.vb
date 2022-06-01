Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_InforAdmtvoEstadodelEjerciciodelPresupuestoEGR


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

            Case 1
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable"
                Me.SUBTITULO = filterRamoDependencia.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Ramo / UR"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal2Colum()
                Return rpt

            Case 2
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Clasificación Económica"
                Me.SUBTITULO = filterRamoDependencia.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "Tipo Gasto"
                Me.FIRMAS = "Por Ramo / Clasificación Económica"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal2Colum()
                Return rpt


            Case 3
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Clasificación Económica - Capítulo del Gasto"
                Me.SUBTITULO = filterRamoDependencia.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto"
                Me.nomTipoClaves = "Tipo Gto"
                Me.nomTipoClaves2 = "Capítulo"
                Me.FIRMAS = "Por Ramo / Clasificación Económica / Capítulo Gasto"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal3Colum()
                Return rpt

            Case 4
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Capítulo y Concepto del gasto"
                Me.SUBTITULO = filterRamoDependencia.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Capítulo"
                Me.nomTipoClaves2 = "Concepto"
                Me.FIRMAS = "Por Ramo / Capítulo y Concepto Gasto"
                rpt = New RPT_2InformeAdmtvoEdoEjercicioPresupuestal3Colum3Niveles()
                Return rpt

            Case 5
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Clasificación Funcional y SubFunción"
                Me.SUBTITULO = filterRamoDependencia.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Fin"
                Me.FIRMAS = "Por Ramo / Clasificación Funcional / Subfunción"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal4Colum3Niveles()
                Return rpt

            Case 6
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Capítulo y Concepto del gasto"
                Me.SUBTITULO = filterRamoDependencia.Text & " - " & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Capítulo"
                Me.nomTipoClaves2 = "Concepto"
                Me.FIRMAS = "Por Ramo / UR / Capítulo y Concepto Gasto"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal3Colum3Niveles()
                Me.filterUnidadResponsable.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Enabled = True
                Me.lblProgramaOperativo.Visible = True
                Me.filterProgramaOperativo.Visible = True
                Me.CleanProgramaOperativo.Visible = True
                Return rpt

            Case 7
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Programa"
                Me.SUBTITULO = filterRamoDependencia.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Ramo / Programa"
                Me.LblPartida.Visible = False
                Me.LblPartidaDesde.Visible = True
                Me.LblPartidaHasta.Visible = True
                Me.LblUnidadResponsable.Visible = False
                Me.LblUnidadResponsableDesde.Visible = True
                Me.LblUnidadResponsableHasta.Visible = True
                Me.LblUnidadResponsableDesde.Enabled = True
                Me.LblUnidadResponsableHasta.Enabled = True

                Me.filterUnidadResponsableHasta.Visible = True
                Me.filterUnidadResponsable.Visible = True
                Me.filterUnidadResponsableHasta.Enabled = True
                Me.filterUnidadResponsable.Enabled = True

                Me.filterPartidaHasta.Visible = True
                Me.filterPartida.Visible = True

                Me.CleanPartidaHasta.Visible = True
                Me.CleanUnidadResponsableHasta.Visible = True
                Me.CleanPartidaHasta.Enabled = True
                Me.CleanUnidadResponsableHasta.Enabled = True

                Me.CleanPartida.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.CleanPartida.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True

                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal1Colum()
                Return rpt

            Case 8
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Programa"
                Me.SUBTITULO = filterRamoDependencia.Text & "-" & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Ramo / UR / Programa"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal2ColumB()
                Me.filterUnidadResponsable.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Enabled = True
                Me.LblPartida.Visible = True
                Me.filterPartida.Visible = True
                Me.CleanPartida.Visible = True
                Me.LblFuenteFinanciameinto.Visible = True
                Me.filterFuenteFinanciamiento.Visible = True
                Me.CleanFuenteFinanciamiento.Visible = True
                Me.LblFuenteFinanciameinto.Location = New Point(16, 250)
                Me.filterFuenteFinanciamiento.Location = New Point(14, 269)
                Me.CleanFuenteFinanciamiento.Location = New Point(191, 270)

                Me.filterUnidadResponsableHasta.Visible = False
                Me.filterUnidadResponsable.Visible = False

                Me.filterPartidaHasta.Visible = False
                Me.filterPartida.Visible = False

                Me.CleanPartidaHasta.Visible = False
                Me.CleanUnidadResponsableHasta.Visible = False
                Me.CleanUnidadResponsable.Visible = False
                Me.LblPartida.Visible = False
                Me.CleanPartida.Visible = False

                Return rpt



            Case 9
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Distribución geográfica"
                Me.SUBTITULO = filterRamoDependencia.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Ramo / Distribución Geográfica"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal2Colum()
                Me.LblUnidadResponsable.Visible = True
                Me.filterUnidadResponsable.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Enabled = True
                Me.filterUnidadResponsable.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True
                Me.LblPartida.Visible = True
                Me.filterPartida.Visible = True
                Me.CleanPartida.Visible = True
                Me.LblFuenteFinanciameinto.Visible = True
                Me.filterFuenteFinanciamiento.Visible = True
                Me.CleanFuenteFinanciamiento.Visible = True
                Me.LblFuenteFinanciameinto.Location = New Point(16, 252)
                Me.filterFuenteFinanciamiento.Location = New Point(14, 271)
                Me.CleanFuenteFinanciamiento.Location = New Point(191, 270)
                Me.LblFuenteFinanciameinto.Visible = False
                Me.filterFuenteFinanciamiento.Visible = False
                Me.CleanFuenteFinanciamiento.Visible = False
                Return rpt

            Case 10
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Clasificación económica del gasto - Distribución geográfica"
                Me.SUBTITULO = filterRamoDependencia.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "TipoGto"
                Me.nomTipoClaves2 = "Clave"
                Me.FIRMAS = "Por Ramo / Clasificación Económica / Distribución Geográfica"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal3Colum2Niveles()
                Return rpt

            Case 11
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Partida Genérica"
                Me.SUBTITULO = filterRamoDependencia.Text & "-" & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto   "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Ramo / UR / Partida Genérica"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal7Colum()
                Me.filterUnidadResponsable.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Enabled = True
                Return rpt

            Case 12
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Partida Específica"
                Me.SUBTITULO = filterRamoDependencia.Text & "-" & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Ramo / UR / Partida Específica"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal7Colum()
                Me.filterUnidadResponsable.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Enabled = True
                Me.lblProgramaOperativo.Visible = True
                Me.filterProgramaOperativo.Visible = True
                Me.CleanProgramaOperativo.Visible = True
                Me.LblFuenteFinanciameinto.Visible = True
                Me.filterFuenteFinanciamiento.Visible = True
                Me.CleanFuenteFinanciamiento.Visible = True
                'Me.LabelControl8.Visible = True
                'Me.filterPartida.Visible = True
                'Me.SimpleButton5.Visible = True
                'Me.LabelControl9.Visible = True
                'Me.filterFuenteFinanciamiento.Visible = True
                'Me.SimpleButton6.Visible = True
                'rpt.Report.FindControl("GroupHeader1", True)
                Return (rpt)


            Case 13
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Programa - Actividad Institucional - Objeto del gasto a tercer nivel"
                Me.SUBTITULO = filterUnidadResponsable.Text
                Me.SUBTITULO = filterRamoDependencia.Text & "-" & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Capítulo"
                Me.nomTipoClaves2 = "Concepto"
                Me.FIRMAS = "Por Ramo / UR / Programa / Actividad Institucional / Objeto Gasto 3N"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal3Colum2NivProg2()
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

            Case 14
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Programa - Objeto del gasto por Capítulo"
                Me.SUBTITULO = filterRamoDependencia.Text & "-" & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Capítulo"
                Me.nomTipoClaves2 = "Concepto"
                Me.FIRMAS = "Por Ramo / UR / Programa / Objeto Gasto por Capítulo"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal3Colum2NivelesProg()
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

            Case 15
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Partida Específica Concentrado"
                Me.SUBTITULO = filterRamoDependencia.Text & "-" & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Ramo / UR / Partida Específica Concentrado"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal7ColumB()
                Me.filterUnidadResponsable.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Enabled = True
                Me.LblPartida.Visible = True
                Me.filterPartida.Visible = True
                Me.CleanPartida.Visible = True
                Me.LblFuenteFinanciameinto.Visible = True
                Me.filterFuenteFinanciamiento.Visible = True
                Me.CleanFuenteFinanciamiento.Visible = True
                'Me.LblFuenteFinanciameinto.Location = New Point(16, 252)
                'Me.filterFuenteFinanciamiento.Location = New Point(14, 271)
                'Me.CleanFuenteFinanciamiento.Location = New Point(191, 270)
                Return (rpt)

            Case 16
                Me.nomREPORTE = "Informe Administrativo sobre el Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ramo - Unidad Responsable - Partida Genérica"
                Me.SUBTITULO = filterRamoDependencia.Text & "-" & filterUnidadResponsable.Text
                Me.nomTipoReporte = "Ejercicio del Presupuesto   "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Ramo / UR / Partida Genérica"
                rpt = New RPT_InformeAdmtvoEdoEjercicioPresupuestal7ColumB()
                Me.filterUnidadResponsable.Enabled = True
                Me.CleanUnidadResponsable.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.CleanUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Visible = True
                Me.LblUnidadResponsable.Enabled = True
                Me.LblPartida.Visible = True
                Me.filterPartida.Visible = True
                Me.CleanPartida.Visible = True
                Me.LblFuenteFinanciameinto.Visible = True
                Me.filterFuenteFinanciamiento.Visible = True
                Me.CleanFuenteFinanciamiento.Visible = True
                'Me.LblFuenteFinanciameinto.Location = New Point(16, 252)
                'Me.filterFuenteFinanciamiento.Location = New Point(14, 271)
                'Me.CleanFuenteFinanciamiento.Location = New Point(191, 270)
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

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codigo para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR", SQLConexion)
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

        If filterRamoDependencia.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Clave", filterRamoDependencia.Properties.KeyValue))

        End If

        If filterRamoDependencia.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@Clave", ""))

        End If


        If filterUnidadResponsable.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", filterUnidadResponsable.Properties.KeyValue))

        End If

        If filterUnidadResponsable.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", ""))

        End If

        'UnidadResponsable hasta
        If filterUnidadResponsableHasta.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveURHasta", filterUnidadResponsableHasta.Properties.KeyValue))

        End If

        If filterUnidadResponsableHasta.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveURHasta", ""))

        End If

        If filterEstructuraProgramatica.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdEP", filterEstructuraProgramatica.Properties.KeyValue))

        End If


        If filterEstructuraProgramatica.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdEP", ""))

        End If

        If filterPartida.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida", Convert.ToInt32(filterPartida.Text)))
        End If

        If filterPartida.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartida", 0))
        End If

        'partida hasta
        If filterPartidaHasta.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartidaHasta", Convert.ToInt32(filterPartidaHasta.Text)))
        End If

        If filterPartidaHasta.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdPartidaHasta", 0))
        End If

        If filterFuenteFinanciamiento.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", filterFuenteFinanciamiento.EditValue))
        End If

        If filterFuenteFinanciamiento.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", ""))

        End If

        If filterProgramaOperativo.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveProg", Convert.ToInt32(filterProgramaOperativo.EditValue)))
        End If

        If filterProgramaOperativo.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveProg", 0))

        End If

        SQLComando.Parameters.Add(New SqlParameter("@AprAnual", ChkAprAnual.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", chkAmpRedAnual.Checked))
       


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_InformeAdmtvoEstadoEjercicioPresupuestoEGR"
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
                .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString    '"Del " & Primer & " al " & Ultimo
            ElseIf ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            End If

            .lblRptTituloTipo.Text = nomTipoReporte
            .lblRptnomClaves.Text = nomTipoClaves
            .lblRptnomClaves2.Text = nomTipoClaves2
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
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With


        Dim ObjTempSQL5 As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsableHasta.Properties
            .DataSource = ObjTempSQL1.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        Dim ObjTempSQL6 As New clsRPT_CFG_DatosEntesCtrl
        With filterPartidaHasta.Properties
            .DataSource = ObjTempSQL3.List("", 0, "C_PartidasPres", " Order by IdPartida ")
            .DisplayMember = "ClavePartida"
            .ValueMember = "ClavePartida"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With filterProgramaOperativo.Properties
            .DataSource = ObjTempSQL.List("Ejercicio=" & Year(filterPeriodoAl.EditValue), 0, "C_EP_Ramo", " Order by CLAVE ")
            .DisplayMember = "Clave"
            .ValueMember = "Id"
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
            ChkAprAnual.Checked = False
            chkAmpRedAnual.Checked = False

        ElseIf ChkAnual.Checked = False And String.IsNullOrEmpty(filterPeriodoInicio.EditValue) And String.IsNullOrEmpty(filterPeriodoFinal.EditValue) Then
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
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 11 Then
            Me.SP = 11
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 12 Then
            Me.SP = 12
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 13 Then
            Me.SP = 27
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 14 Then
            Me.SP = 13
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 15 Then
            Me.SP = 29
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 16 Then
            Me.SP = 31

        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 1 Then
            Me.SP = 14
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 2 Then
            Me.SP = 15
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 3 Then
            Me.SP = 16
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 4 Then
            Me.SP = 17
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 5 Then
            Me.SP = 18
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 6 Then
            Me.SP = 19
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 7 Then
            Me.SP = 20
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 8 Then
            Me.SP = 21
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 9 Then
            Me.SP = 22
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 10 Then
            Me.SP = 23
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 11 Then
            Me.SP = 24
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 12 Then
            Me.SP = 25
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 13 Then
            Me.SP = 28
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 14 Then
            Me.SP = 26
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 15 Then
            Me.SP = 30
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 16 Then
            Me.SP = 32


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


    Private Sub filterPartidaHasta_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterPartidaHasta.GotFocus

        If REPORTE = 16 Then
            Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
            With filterPartidaHasta.Properties
                .DataSource = ObjTempSQL.List("", 0, "C_PartidasGenericasPres", " Order by ClavePartida ")
                .DisplayMember = "ClavePartida"
                .ValueMember = "ClavePartida"
                .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
                .NullText = ""
                .ShowHeader = True
            End With
        Else
            Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
            With filterPartidaHasta.Properties
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
    Private Sub filterUnidadResponsableHasta_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsableHasta.GotFocus
        Dim ObjTempSQL1 As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsableHasta.Properties
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
            .ValueMember = "CLAVE"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterProgramaOperativo_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterProgramaOperativo.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterProgramaOperativo.Properties
            .DataSource = ObjTempSQL.List("Ejercicio=" & Year(filterPeriodoAl.EditValue), 0, "C_EP_Ramo", " Order by CLAVE ")
            .DisplayMember = "Clave"
            .ValueMember = "Id"
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

    Private Sub CleanUnidadResponsableHasta_Click(sender As System.Object, e As System.EventArgs) Handles CleanUnidadResponsableHasta.Click
        filterUnidadResponsableHasta.Properties.DataSource = Nothing
        filterUnidadResponsableHasta.Properties.NullText = ""
    End Sub

    Private Sub CleanPartidaHasta_Click(sender As System.Object, e As System.EventArgs) Handles CleanPartidaHasta.Click
        filterPartidaHasta.Properties.DataSource = Nothing
        filterPartidaHasta.Properties.NullText = ""
    End Sub

    Private Sub CleanProgramaOperativo_Click(sender As System.Object, e As System.EventArgs) Handles CleanProgramaOperativo.Click
        filterProgramaOperativo.Properties.DataSource = Nothing
        filterProgramaOperativo.Properties.NullText = ""
    End Sub

End Class