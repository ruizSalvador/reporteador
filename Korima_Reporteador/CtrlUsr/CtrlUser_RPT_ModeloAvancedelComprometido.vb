Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_ModeloAvancedelComprometido

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
        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True

        Dim reporte = New RPT_ModeloAvancedelComprometido
        'Dim reporte = New RPT_EstadoEjercicioPresupuestal4Niveles()

        Dim printTool As New ReportPrintTool(reporte)

        '--Agregado para SP
        Dim SQLConexion As SqlConnection

        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(cnnString)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_RPT_ModeloAvanceDelComprometido", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure

        '--- Parametros IN

        SQLComando.Parameters.Add(New SqlParameter("@Mes", IIf(ChkAnual.Checked = True, 1, Month(filterPeriodoInicio.EditValue))))
        SQLComando.Parameters.Add(New SqlParameter("@Mes2", IIf(ChkAnual.Checked = True, 12, Month(filterPeriodoFinal.EditValue))))
        'SQLComando.Parameters.Add(New SqlParameter("@Tipo", IIf(ChkRelativo.Checked = True, 1, 2)))
        'SQLComando.Parameters.Add(New SqlParameter("@Tipo", cmbPresupuesto.SelectedIndex))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", Year(filterPeriodoAl.EditValue)))

        If filterPartida.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveP", filterPartida.Properties.KeyValue))
        End If

        If filterPartida.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveP", ""))
        End If

        If filterFuenteFinanciamiento.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", filterFuenteFinanciamiento.EditValue))
        End If

        If filterFuenteFinanciamiento.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF", 1))

        End If

        If filterFuenteFinanciamiento.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF2", filterFuenteFinanciamiento2.EditValue))
        End If

        If filterFuenteFinanciamiento.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveFF2", 100000))

        End If

        If filterUnidadResponsable.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", filterUnidadResponsable.EditValue))
        End If

        If filterUnidadResponsable.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR", 1))

        End If

        If filterUnidadResponsable2.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR2", filterUnidadResponsable2.EditValue))
        End If

        If filterUnidadResponsable2.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@ClaveUR2", 10000))

        End If

        If filterEstructuraProgramatica.Text <> "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdEP", filterEstructuraProgramatica.Properties.KeyValue))

        End If

        If filterEstructuraProgramatica.Text = "" Then
            SQLComando.Parameters.Add(New SqlParameter("@IdEP", ""))

        End If

        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_RPT_ModeloAvanceDelComprometido")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_RPT_ModeloAvanceDelComprometido"
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
            .lblRptNombreReporte.Text = "Modelo de Avance del Comprometido"
            '.XrLabel1.Text = "" '"Fuente de Financiamiento: " + filterFuenteFinanciamiento.Text
            '.lblFechaRango.Text = ""
            .lblTitulo.Text = "Comprometido"
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            '.XrPictureBox1.Image = pRPTCFGDatosEntes.LogoEnte
            '.lblFechaRango.Text = "Del " & filterPeriodoDe.Text & " al " & filterPeriodoAl.Text
            'If ChkAnual.Checked = False Then
            '    .lblRptDescripcionFiltrado.Text = "Periodo de " & MesLetra(filterPeriodoInicio.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString & " a " & MesLetra(filterPeriodoFinal.EditValue.Month) & " del " & filterPeriodoAl.EditValue.Year.ToString()    '"Del " & Primer & " al " & Ultimo
            'ElseIf ChkAnual.Checked = True Then
            '    .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            'End If

            If ChkAnual.Checked = False Then
                .lblRptDescripcionFiltrado.Text = "DEL " + primero.Day.ToString + " " + MesLetra(primero.Month) + " AL " + ultimo.Day.ToString + " " + MesLetra(ultimo.Month) + " de " + Year(filterPeriodoAl.EditValue).ToString
                '.lblRptDescripcionFiltrado.Text = "Del " + primero.ToString("dd/MM/yyyy") + " Al " + ultimo.ToString("dd/MM/yyyy")
            ElseIf ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "Anual" & "-" & Year(filterPeriodoAl.EditValue)
            End If

            '.lblRptTituloTipo.Text = "Concepto"
            '.lblRptnomClaves.Text = "Capítulo"
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato= '" & "Analítico del ejercicio de Egresos" & "'", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader

        End With

        '******* Firmas ******
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas where Formato = " & "'" & "Modelo Avance del Comprometido" & "' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden", cnnString)
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
        cmbPresupuesto.SelectedIndex = 0

        '---Llenar listas

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by IDFUENTEFINANCIAMIENTO ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With filterFuenteFinanciamiento2.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by IDFUENTEFINANCIAMIENTO ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With

        With filterUnidadResponsable2.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by Clave ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
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

        With filterEstructuraProgramatica.Properties
            .DataSource = ObjTempSQL.List(" Ejercicio =" & Year(filterPeriodoAl.EditValue), 0, "VW_RPT_K2_FiltroInfAdmtvoEdoEjerPresupuestoEGR", " Order by Id ")
            .DisplayMember = "Proyecto"
            .ValueMember = "Id"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub



    'Private Sub ChkAnual_CheckedChanged(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles ChkAnual.CheckedChanged

    '    If ChkAnual.Checked = True Then
    '        filterPeriodoInicio.Enabled = False
    '        filterPeriodoFinal.Enabled = False

    '    ElseIf ChkAnual.Checked = False Then 'Or filterPeriodoInicioAnt.EditValue = "" Or filterPeriodoFinalAnt.EditValue = "" Then
    '        filterPeriodoInicio.Enabled = True
    '        filterPeriodoFinal.Enabled = True
    '    End If


    'End Sub

    Private Sub filterRamoDependencia_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterFuenteFinanciamiento.GotFocus
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

    Private Sub filterFuenteFinanciamiento2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterFuenteFinanciamiento2.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterFuenteFinanciamiento2.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by CLAVE ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub
    Private Sub filterUnidadResponsable_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by IdAreaResp ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterUnidadResponsable2_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable2.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable2.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_AreaResponsabilidad", " Order by IdAreaResp ")
            .DisplayMember = "Nombre"
            .ValueMember = "IdAreaResp"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub filterPartida_GotFocus(ByVal sender As Object, ByVal e As System.EventArgs)
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterPartida.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_PartidasPres", " Order by ClavePartida ")
            .DisplayMember = "DescripcionPartida"
            .ValueMember = "ClavePartida"
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
        filterFuenteFinanciamiento.Properties.DataSource = Nothing
        filterFuenteFinanciamiento.Properties.NullText = ""
    End Sub


    Private Sub SimpleButton3_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton3.Click
        filterUnidadResponsable.Properties.DataSource = Nothing
        filterUnidadResponsable.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton4_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton4.Click
        filterPartida.Properties.DataSource = Nothing
        filterPartida.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton5_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton5.Click
        filterFuenteFinanciamiento2.Properties.DataSource = Nothing
        filterFuenteFinanciamiento2.Properties.NullText = ""
    End Sub
    Private Sub SimpleButton6_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton6.Click
        filterUnidadResponsable2.Properties.DataSource = Nothing
        filterUnidadResponsable2.Properties.NullText = ""
    End Sub

    Private Sub SimpleButton7_Click(sender As System.Object, e As System.EventArgs) Handles SimpleButton7.Click
        filterEstructuraProgramatica.Properties.DataSource = Nothing
        filterEstructuraProgramatica.Properties.NullText = ""
    End Sub
End Class
