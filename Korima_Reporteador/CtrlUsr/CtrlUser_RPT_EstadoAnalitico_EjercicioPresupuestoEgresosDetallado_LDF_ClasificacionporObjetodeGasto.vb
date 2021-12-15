Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_EstadoAnalitico_EjercicioPresupuestoEgresosDetallado_LDF_ClasificacionporObjetodeGasto
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
                Me.nomREPORTE = "Estado del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Ejercicio del Presupuesto Clasificación General"
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Id"
                Me.FIRMAS = "Clasificación General"
                'Me.LabelControl7.Visible = True
                'Me.FilterSello.Visible = True
                'Me.LabelControl6.Visible = True
                'Me.FilterSelloAl.Visible = True
                'Me.SimpleButton3.Visible = True
                'Me.SimpleButton4.Visible = True
                'Me.LabelControl8.Visible = True
                'Me.filterPartida.Visible = True
                'Me.SimpleButton5.Visible = True
                'Me.LabelControl3.Visible = True
                'Me.filterFuenteFinanciamiento.Visible = True
                'Me.SimpleButton2.Visible = True
                'Me.LabelControl3.Enabled = True
                'Me.filterFuenteFinanciamiento.Enabled = True
                'Me.SimpleButton2.Enabled = True
                'Me.LabelControl9.Visible = True
                'Me.FilterCapitulo.Visible = True
                'Me.SimpleButton6.Visible = True
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                rpt = New RPT_EstadodelEjerciciodelPresupuestoGral()
                Return rpt

            Case 2
                Me.nomREPORTE = "Estado Analítico del Ejercicio del Presupuesto de Egresos Detallado – LDF"
                Me.TITULO = "Clasificación Administrativa"
                Me.nomTipoReporte = "Concepto "
                Me.nomTipoClaves = "" '"Ramo"
                Me.FIRMAS = "LDF Clasificación Administrativa"
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                'rpt = New RPT_EstadoEjercicioPresupuestal2Colum()
                rpt = New RPT_EstadoEjercicioPresupuestal_LDF_Clasificacion_Administrativa_NoEtiquetadoPrincipal()

                Return rpt


            Case 3
                Me.nomREPORTE = "Estado del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Fuente de Financiamiento"
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Por Fuente de Financiamiento"
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                rpt = New RPT_EstadoEjercicioPresupuestal2Colum()
                Return rpt

            Case 4
                Me.nomREPORTE = "Estado Analitico del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Clasificación Económica (Por Tipo de Gasto)"
                Me.nomTipoReporte = "" '"Ejercicio del Presupuesto "
                Me.nomTipoClaves = "" '"Tipo Gasto"
                Me.FIRMAS = "Clasificación Economica (por tipo de Gasto)"
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                rpt = New RPT_EstadoEjercicioPresupuestal2Colum()
                Return rpt

            Case 5
                Me.nomREPORTE = "Estado del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Clasificación Geográfica"
                Me.nomTipoReporte = "Ejercicio del Presupuesto "
                Me.nomTipoClaves = "Clave"
                Me.FIRMAS = "Ejercicio del Presupuesto Clasificación Geográfica"
                rpt = New RPT_EstadoEjercicioPresupuestal2Colum()
                Return rpt

            Case 6
                Me.nomREPORTE = "Estado Analítico del Ejercicio del Presupuesto de Egresos Detallado – LDF"
                Me.TITULO = "Clasificación por Objeto del Gasto (Capitulo y Concepto)"
                Me.nomTipoReporte = "Concepto"
                Me.nomTipoClaves = "Capítulo"
                Me.FIRMAS = "LDF Clasificación por Objeto Gasto(Capitulo y Concepto)"
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                'rpt = New RPT_EstadoEjercicioPresupuestal2Niveles()
                rpt = New RPT_EstadoEjercicioPresupuestal2Niveles_EtiquetadoPrincipal()
                Return rpt

            Case 7
                Me.nomREPORTE = "Estado Analitico del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Clasificación Funcional (Finalidad y Función) Detallado – LDF"
                Me.nomTipoReporte = "CONCEPTO"
                Me.nomTipoClaves = "" '"Finalidad"
                Me.FIRMAS = "LDF Clasificación Funcional (Finalidad Y Función)"
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                'rpt = New RPT_EstadoEjercicioPresupuestal2Niveles3Colum()
                rpt = New RPT_EstadoEjercicioPresupuestal_LDF_Clasificacion_Funcional_NoEtiquetadoPrincipal()
                Return rpt

            Case 8
                Me.nomREPORTE = "Estado del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Clasificación Funcional y Subfunción"
                Me.nomTipoReporte = "Ejercicio del Presupuesto   "
                Me.nomTipoClaves = "Finalidad"
                Me.FIRMAS = "Por Clasificación Funcional/Subfunción"
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                rpt = New RPT_EstadoEjercicioPresupuestal3Niveles()
                Return rpt

            Case 9
                Me.nomREPORTE = "Estado del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Clasificación Económica y Capítulo de Gasto"
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "TipoGto"
                Me.FIRMAS = "Por Clasificación Económica / Capítulo de Gasto"
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                rpt = New RPT_EstadoEjercicioPresupuestal3Colum()
                Return rpt

            Case 10
                Me.nomREPORTE = "Estado del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Partida Genérica y Fuente de Financiamiento"
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Clave Partida"
                Me.FIRMAS = "Por Partida/Fuente de Financiamiento"
                rpt = New RPT_EstadoEjercicioPresupuestal2Desc()
                'Me.filterFuenteFinanciamiento.Enabled = True
                'Me.SimpleButton2.Enabled = True
                'Me.LabelControl3.Enabled = True
                'Me.filterFuenteFinanciamiento.Visible = True
                'Me.SimpleButton2.Visible = True
                'Me.LabelControl3.Visible = True
                'Me.LabelControl9.Visible = True
                'Me.FilterCapitulo.Visible = True
                'Me.SimpleButton6.Visible = True
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True
                'Me.LabelControl9.Location = New System.Drawing.Point(19, 197)
                'Me.FilterCapitulo.Location = New System.Drawing.Point(15, 216)
                'Me.SimpleButton6.Location = New System.Drawing.Point(176, 216)
                'Me.SimpleButton1.Location = New System.Drawing.Point(15, 255)

                Return rpt

            Case 11
                Me.nomREPORTE = "Estado del Ejercicio del Presupuesto de Egresos"
                Me.TITULO = "Por Partida Específica y Fuente de Financiamiento"
                Me.nomTipoReporte = "Ejercicio del Presupuesto  "
                Me.nomTipoClaves = "Clave Partida"
                Me.FIRMAS = "Por Partida/Fuente de Financiamiento"
                rpt = New RPT_EstadoEjercicioPresupuestalPartEspec()
                'Me.filterFuenteFinanciamiento.Enabled = True
                'Me.SimpleButton2.Enabled = True
                'Me.LabelControl3.Enabled = True
                'Me.filterFuenteFinanciamiento.Visible = True
                'Me.SimpleButton2.Visible = True
                'Me.LabelControl3.Visible = True
                'Me.chkAprAnual.Visible = True
                'Me.ChkAmpRed.Visible = True

                Return rpt


            Case Else
                MessageBox.Show("Hubo un error", "Error2", MessageBoxButtons.OK, MessageBoxIcon.Information)
                Return Nothing
        End Select
    End Function

    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        ErrorProvider1.Clear()

        Dim reporte = New Object()
        reporte = AsignaReporte()
        Dim printTool As New ReportPrintTool(reporte)
        'Dim reporte As New RPT_EstadoEjercicioPresupuestal2Niveles_EtiquetadoPrincipal

        'Dim printTool As New ReportPrintTool(reporte)
        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
#If DEBUG Then
        MdlIdUsuario = 25
#End If

        If ChkAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))

        ElseIf ChkAnual.Checked = False Then
            SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            SQLComando.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))

        End If

        'If filterFuenteFinanciamiento.Text <> "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", filterFuenteFinanciamiento.Properties.KeyValue))
        'End If

        'If filterFuenteFinanciamiento.Text = "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", ""))

        'End If
        ''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''''

        If GetFiltrarXUR(MdlIdUsuario) = True Then
            SQLComando.Parameters.Add(New SqlParameter("@IdArea", GetIdUR(MdlIdUsuario)))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@IdArea", 0))
        End If
        SQLComando.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", ChkAmpRed.Checked))
        'SQLComando.Parameters.Add(New SqlParameter("@IdSello", IIf(FilterSello.Text = "", 0, Convert.ToInt32(FilterSello.Text))))
        'SQLComando.Parameters.Add(New SqlParameter("@IdSelloFin", IIf(FilterSelloAl.Text = "", 0, Convert.ToInt32(FilterSelloAl.Text))))
        'If FilterSello.Text <> "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdSello", Convert.ToInt32(FilterSello.Text)))
        'End If

        'If FilterSello.Text = "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdSello", 0))
        'End If
        'If FilterSelloAl.Text <> "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdSelloFin", Convert.ToInt32(FilterSelloAl.Text)))
        'End If

        'If FilterSelloAl.Text = "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdSelloFin", 0))
        'End If

        'If filterPartida.Text <> "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdPartida", Convert.ToInt32(filterPartida.Text)))
        'End If

        'If filterPartida.Text = "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdPartida", 0))
        'End If

        'If FilterCapitulo.Text <> "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", Convert.ToInt32(FilterCapitulo.Text)))
        'End If

        'If FilterCapitulo.Text = "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdCapitulo", 0))
        'End If
        '---------------------------------------------------------------
        'If ChkAnual.Checked = True Then
        '    SQLComando.Parameters.Add(New SqlParameter("@Mes", 0))
        '    SQLComando.Parameters.Add(New SqlParameter("@Mes2", 0))
        '    SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        'ElseIf ChkAnual.Checked = False Then
        '    SQLComando.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
        '    SQLComando.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
        '    SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        'End If

        'If ChkMuestraCeros.Checked = True Then
        '    SQLComando.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
        'ElseIf ChkMuestraCeros.Checked = False Then
        '    SQLComando.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
        'End If

        'SQLComando.Parameters.Add(New SqlParameter("@Tipo", 6))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado")

        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_NoEtiquetado"


        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte


        '--Codgio para Llenar el SubReporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando2 As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado", SQLConexion)
        SQLComando2.CommandType = CommandType.StoredProcedure

        '--- Parametros IN
        If ChkAnual.Checked = True Then
            SQLComando2.Parameters.Add(New SqlParameter("@Mes", 0))
            SQLComando2.Parameters.Add(New SqlParameter("@Mes2", 0))
            SQLComando2.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        ElseIf ChkAnual.Checked = False Then
            SQLComando2.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            SQLComando2.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            SQLComando2.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            SQLComando2.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
        End If

        If ChkMuestraCeros.Checked = True Then
            SQLComando2.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
        ElseIf ChkMuestraCeros.Checked = False Then
            SQLComando2.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
        End If
        If GetFiltrarXUR(MdlIdUsuario) = True Then
            SQLComando2.Parameters.Add(New SqlParameter("@IdArea", GetIdUR(MdlIdUsuario)))
        Else
            SQLComando2.Parameters.Add(New SqlParameter("@IdArea", 0))
        End If
        SQLComando2.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
        SQLComando2.Parameters.Add(New SqlParameter("@AmpRedAnual", ChkAmpRed.Checked))

        'SQLComando2.Parameters.Add(New SqlParameter("@Tipo", 6))

        Dim adapter2 As New SqlDataAdapter(SQLComando2)
        Dim ds2 As New DataSet()
        ds2.EnforceConstraints = False
        adapter2.Fill(ds2, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado")

        reporte.SubReporteEtiquetado.ReportSource.DataSource = ds2
        reporte.SubReporteEtiquetado.ReportSource.DataAdapter = adapter2
        reporte.SubReporteEtiquetado.ReportSource.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado_Etiquetado"

        SQLComando2.Dispose()
        SQLConexion.Close()
        '---Fin de llenado del subreporte

        If Me.SP = 7 Or Me.SP = 17 Or Me.SP = 2 Or Me.SP = 12 Then
            '--Codgio para Llenar el SubReporte Totales con SP
            SQLConexion = New SqlConnection(SQLmConnStr)
            SQLConexion.Open()
            Dim SQLComando3 As New SqlCommand("RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales", SQLConexion)
            SQLComando3.CommandType = CommandType.StoredProcedure
            SQLComando3.CommandTimeout = 0
            '--- Parametros IN
            If ChkAnual.Checked = True Then
                SQLComando3.Parameters.Add(New SqlParameter("@Mes", 0))
                SQLComando3.Parameters.Add(New SqlParameter("@Mes2", 0))
                SQLComando3.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
                SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
            ElseIf ChkAnual.Checked = False Then
                SQLComando3.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
                SQLComando3.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
                SQLComando3.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
                SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
            End If

            If ChkMuestraCeros.Checked = True Then
                SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
            ElseIf ChkMuestraCeros.Checked = False Then
                SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
            End If
            If GetFiltrarXUR(MdlIdUsuario) = True Then
                SQLComando3.Parameters.Add(New SqlParameter("@IdArea", GetIdUR(MdlIdUsuario)))
            Else
                SQLComando3.Parameters.Add(New SqlParameter("@IdArea", 0))
            End If
            SQLComando3.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
            SQLComando3.Parameters.Add(New SqlParameter("@AmpRedAnual", ChkAmpRed.Checked))


            Dim adapter3 As New SqlDataAdapter(SQLComando3)
            Dim ds3 As New DataSet()
            ds3.EnforceConstraints = False
            adapter3.Fill(ds3, "RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales")

            reporte.Totales.ReportSource.DataSource = ds3
            reporte.Totales.ReportSource.DataAdapter = adapter3
            reporte.Totales.ReportSource.DataMember = "RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales"

            SQLComando3.Dispose()
            SQLConexion.Close()
            '---Fin de llenado del subreporte Totales
            'End If
            'ElseIf Me.SP = 2 Or Me.SP = 12 Then
            '    '--Codgio para Llenar el SubReporte Totales con SP
            '    SQLConexion = New SqlConnection(SQLmConnStr)
            '    SQLConexion.Open()
            '    Dim SQLComando3 As New SqlCommand("RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales", SQLConexion)
            '    SQLComando3.CommandType = CommandType.StoredProcedure

            '    '--- Parametros IN
            '    If ChkAnual.Checked = True Then
            '        SQLComando3.Parameters.Add(New SqlParameter("@Mes", 0))
            '        SQLComando3.Parameters.Add(New SqlParameter("@Mes2", 0))
            '        SQLComando3.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            '        SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
            '    ElseIf ChkAnual.Checked = False Then
            '        SQLComando3.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
            '        SQLComando3.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
            '        SQLComando3.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
            '        SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
            '    End If

            '    If ChkMuestraCeros.Checked = True Then
            '        SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
            '    ElseIf ChkMuestraCeros.Checked = False Then
            '        SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
            '    End If
            '    If GetFiltrarXUR(MdlIdUsuario) = True Then
            '        SQLComando3.Parameters.Add(New SqlParameter("@IdArea", GetIdUR(MdlIdUsuario)))
            '    Else
            '        SQLComando3.Parameters.Add(New SqlParameter("@IdArea", 0))
            '    End If
            '    SQLComando3.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
            '    SQLComando3.Parameters.Add(New SqlParameter("@AmpRedAnual", ChkAmpRed.Checked))


            '    Dim adapter3 As New SqlDataAdapter(SQLComando3)
            '    Dim ds3 As New DataSet()
            '    ds3.EnforceConstraints = False
            '    adapter3.Fill(ds3, "RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales")

            '    reporte.Totales.ReportSource.DataSource = ds3
            '    reporte.Totales.ReportSource.DataAdapter = adapter3
            '    reporte.Totales.ReportSource.DataMember = "RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales"

            '    SQLComando3.Dispose()
            '    SQLConexion.Close()

            '---Fin de llenado del subreporte Totales
            'End If


        ElseIf Me.SP = 6 Or Me.SP = 16 Then
            '--Codgio para Llenar el SubReporte Totales con SP
            SQLConexion = New SqlConnection(SQLmConnStr)
            SQLConexion.Open()
            Dim SQLComando3 As New SqlCommand("RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales", SQLConexion)
            SQLComando3.CommandType = CommandType.StoredProcedure

            '--- Parametros IN
            If ChkAnual.Checked = True Then
                SQLComando3.Parameters.Add(New SqlParameter("@Mes", 0))
                SQLComando3.Parameters.Add(New SqlParameter("@Mes2", 0))
                SQLComando3.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
                SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
            ElseIf ChkAnual.Checked = False Then
                SQLComando3.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
                SQLComando3.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
                SQLComando3.Parameters.Add(New SqlParameter("@Tipo", Me.SP))
                SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
            End If

            If ChkMuestraCeros.Checked = True Then
                SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
            ElseIf ChkMuestraCeros.Checked = False Then
                SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
            End If
            If GetFiltrarXUR(MdlIdUsuario) = True Then
                SQLComando3.Parameters.Add(New SqlParameter("@IdArea", GetIdUR(MdlIdUsuario)))
            Else
                SQLComando3.Parameters.Add(New SqlParameter("@IdArea", 0))
            End If
            SQLComando3.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
            SQLComando3.Parameters.Add(New SqlParameter("@AmpRedAnual", ChkAmpRed.Checked))


            Dim adapter3 As New SqlDataAdapter(SQLComando3)
            Dim ds3 As New DataSet()
            ds3.EnforceConstraints = False
            adapter3.Fill(ds3, "RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales")

            reporte.Totales.ReportSource.DataSource = ds3
            reporte.Totales.ReportSource.DataAdapter = adapter3
            reporte.Totales.ReportSource.DataMember = "RPT_SP_ClasificacionporObjetodeGasto_LDF_Totales"

            SQLComando3.Dispose()
            SQLConexion.Close()
            '---Fin de llenado del subreporte Totales
        Else

            '--Codgio para Llenar el SubReporte Totales con SP
            SQLConexion = New SqlConnection(SQLmConnStr)
            SQLConexion.Open()
            Dim SQLComando3 As New SqlCommand("SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado", SQLConexion)
            SQLComando3.CommandType = CommandType.StoredProcedure

            '--- Parametros IN
            If ChkAnual.Checked = True Then
                SQLComando3.Parameters.Add(New SqlParameter("@Mes", 0))
                SQLComando3.Parameters.Add(New SqlParameter("@Mes2", 0))
                SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
            ElseIf ChkAnual.Checked = False Then
                SQLComando3.Parameters.Add(New SqlParameter("@Mes", Month(filterPeriodoIni.EditValue)))
                SQLComando3.Parameters.Add(New SqlParameter("@Mes2", Month(filterPeriodoFin.EditValue)))
                SQLComando3.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterEjercicio.EditValue)))
            End If

            If ChkMuestraCeros.Checked = True Then
                SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 1))
            ElseIf ChkMuestraCeros.Checked = False Then
                SQLComando3.Parameters.Add(New SqlParameter("@MuestraCeros", 0))
            End If

            SQLComando3.Parameters.Add(New SqlParameter("@Tipo", 6))

            Dim adapter3 As New SqlDataAdapter(SQLComando3)
            Dim ds3 As New DataSet()
            ds3.EnforceConstraints = False
            adapter3.Fill(ds3, "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado")

            reporte.Totales.ReportSource.DataSource = ds3
            reporte.Totales.ReportSource.DataAdapter = adapter3
            reporte.Totales.ReportSource.DataMember = "SP_EstadoAnaliticoEjercicio_PresupuestoEgresosDetallado"

            SQLComando3.Dispose()
            SQLConexion.Close()
            '---Fin de llenado del subreporte Totales

        End If


        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        'adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = 'Estado Analitico De Ingresos por Rubro' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = " & "'" & Me.FIRMAS & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.Firmas.ReportSource.DataSource = dsC
        reporte.Firmas.ReportSource.DataAdapter = adapterC
        reporte.Firmas.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne
        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = TITULO
            .lblRptNombreReporte.Text = nomREPORTE '"Estado Analitico del Ejercicio del Presupuesto de Egresos Detallado -LDF"
            .lblRptDescripcionFiltrado.Text = ""
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario

            Dim segundo As DateTime = New DateTime()
            If filterPeriodoFin.Text = "02" Then

                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 28)
            ElseIf filterPeriodoFin.Text = "04" Or filterPeriodoFin.Text = "06" Or filterPeriodoFin.Text = "09" Or filterPeriodoFin.Text = "11" Then
                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 30)
            ElseIf filterPeriodoFin.Text = "01" Or filterPeriodoFin.Text = "03" Or filterPeriodoFin.Text = "05" Or filterPeriodoFin.Text = "07" Or filterPeriodoFin.Text = "08" Or filterPeriodoFin.Text = "10" Or filterPeriodoFin.Text = "12" Then
                segundo = New DateTime(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month, 31)
            End If

            Dim primero As DateTime = New DateTime()
            If filterPeriodoIni.SelectedText = "02" Then

                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 28)
            ElseIf filterPeriodoIni.Text = "04" Or filterPeriodoIni.Text = "06" Or filterPeriodoIni.Text = "09" Or filterPeriodoIni.Text = "11" Then
                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 30)
            ElseIf filterPeriodoIni.Text = "01" Or filterPeriodoIni.Text = "03" Or filterPeriodoIni.Text = "05" Or filterPeriodoIni.Text = "07" Or filterPeriodoIni.Text = "08" Or filterPeriodoIni.Text = "10" Or filterPeriodoIni.Text = "12" Then
                primero = New DateTime(filterEjercicio.Time.Year, filterPeriodoIni.Time.Month, 31)
            End If

            Dim ultimo As Date = New DateTime(filterPeriodoFin.Time.Year, filterPeriodoFin.Time.Month, 1)
            ultimo = ultimo.AddDays(-ultimo.Day + 1).AddMonths(1).AddDays(-1)

            If ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Del 1 de Enero " & filterEjercicio.Time.Year.ToString & " Al " & "31 de Diciembre " & filterEjercicio.Time.Year.ToString
            Else
                ' .lblRptDescripcionFiltrado.Text = "Del 1 de Enero Al " & DateTime.DaysInMonth(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month).ToString & " de " & filterPeriodoFin.Time.Month.ToString & " de " & filterEjercicio.Time.Year.ToString
                .lblRptDescripcionFiltrado.Text = "Del 1 de " + MesLetra(primero.Month) + " Al " + ultimo.Day.ToString + " de " + MesLetra(segundo.Month) + " del " & filterEjercicio.Time.Year.ToString
            End If
            .lblRptTituloTipo.Text = nomTipoReporte
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & FIRMAS & "'", New SqlConnection(cnnString))
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
        filterPeriodoFin.Time = Now
        filterEjercicio.Time = Now
        filterPeriodoIni.Time = Now
    End Sub

    Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkAnual.CheckedChanged
        If ChkAnual.Checked = True Then
            filterPeriodoFin.Enabled = False
            filterPeriodoIni.Enabled = False
        Else
            filterPeriodoFin.Enabled = True
            filterPeriodoIni.Enabled = True
        End If
    End Sub

    Private Sub ChkRelativo_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles ChkRelativo.CheckedChanged
        If ChkRelativo.Checked = True And Me.REPORTE = 1 Then
            Me.SP = 1
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 2 Then
            Me.SP = 2
            Me.chkAprAnual.Checked = True
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 3 Then
            Me.SP = 3
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 4 Then
            Me.SP = 4
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 5 Then
            Me.SP = 5
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 6 Then
            Me.SP = 6
            Me.chkAprAnual.Checked = True
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 7 Then
            Me.SP = 7
            Me.chkAprAnual.Checked = True
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 8 Then
            Me.SP = 8
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 9 Then
            Me.SP = 9
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 10 Then
            Me.SP = 10
        ElseIf ChkRelativo.Checked = True And Me.REPORTE = 11 Then
            Me.SP = 22

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
        ElseIf ChkRelativo.Checked = False And Me.REPORTE = 11 Then
            Me.SP = 23

        End If
    End Sub
End Class