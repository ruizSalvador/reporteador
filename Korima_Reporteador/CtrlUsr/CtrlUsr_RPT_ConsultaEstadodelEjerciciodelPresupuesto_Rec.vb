Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUsr_RPT_ConsultaEstadodelEjerciciodelPresupuesto_Rec

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
                Me.nomREPORTE = "Consulta Estado del Ejercicio del Presupuesto de Egresos"
                'Me.TITULO = "Partida Genérica y Fuente de Financiamiento"
                Me.nomTipoReporte = "Consulta Estado del Ejercicio  "
                Me.nomTipoClaves = "Id"
                'Me.FIRMAS = "Por Partida/Fuente de Financiamiento"
                rpt = New RPT_ConsultaEstadodelEjerciciodelPresupuesto()
                Me.filterFuenteFinanciamiento.Enabled = True
                Me.SimpleButton2.Enabled = True
                Me.LabelControl3.Enabled = True
                Me.filterFuenteFinanciamiento.Visible = True
                Me.SimpleButton2.Visible = True
                Me.LabelControl3.Visible = True

                Me.filterUnidadResponsable.Enabled = True
                Me.SimpleButton4.Enabled = True
                Me.LabelControl7.Enabled = True
                Me.filterUnidadResponsable.Visible = True
                Me.SimpleButton4.Visible = True
                Me.LabelControl7.Visible = True

                Me.filterPartida.Enabled = True
                Me.SimpleButton3.Enabled = True
                Me.LabelControl6.Enabled = True
                Me.filterPartida.Visible = True
                Me.SimpleButton3.Visible = True
                Me.LabelControl6.Visible = True
                Me.lblProgramaOperativo.Visible = True
                Me.filterProgramaOperativo.Visible = True
                Me.CleanProgramaOperativo.Visible = True


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

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto_Rec", SQLConexion)
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

        If filterUnidadResponsable.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", filterUnidadResponsable.Properties.KeyValue))
        End If

        If filterUnidadResponsable.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", ""))

        End If


        If filterPartida.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveP", filterPartida.Properties.KeyValue))
        End If

        If filterPartida.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveP", ""))

        End If

        If filterProgramaOperativo.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveProg", Convert.ToInt32(filterProgramaOperativo.EditValue)))
        End If

        If filterProgramaOperativo.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveProg", ""))

        End If

        If chkAprAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@AprAnual", 1))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@AprAnual", 0))
        End If
        SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", ChkAmpRed.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@TransfAnual", chkTransAnual.Checked))

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto_Rec")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_ConsultaEstadodelEjerciciodelPresupuesto_Rec"
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
            If ChkAnual.Checked = False Then
                .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString()    '"Del " & Primer & " al " & Ultimo
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
                    .lblRptDescripcionFiltrado.Text = "Del 01 de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " " & filterPeriodoAl.EditValue.Year.ToString & " al " + ultimo.Day.ToString + " de " & MesLetra(filterPeriodoFinal.EditValue.Month) & " " & filterPeriodoAl.EditValue.Year.ToString
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
            .lblRptnomClaves.Text = nomTipoClaves
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


        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
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

    'filterUnidadResponsable
    Private Sub filterUnidadResponsable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "Clave"
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
        filterFuenteFinanciamiento.Properties.DataSource = Nothing
        filterFuenteFinanciamiento.Properties.NullText = ""
    End Sub


    Private Sub SimpleButton4_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton4.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
    End Sub


    Private Sub SimpleButton3_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton3.Click
        filterPartida.Properties.DataSource = Nothing
        filterPartida.Properties.NullText = ""
    End Sub


    Private Sub CleanProgramaOperativo_Click(sender As System.Object, e As System.EventArgs) Handles CleanProgramaOperativo.Click
        filterProgramaOperativo.Properties.DataSource = Nothing
        filterProgramaOperativo.Properties.NullText = ""
    End Sub
End Class