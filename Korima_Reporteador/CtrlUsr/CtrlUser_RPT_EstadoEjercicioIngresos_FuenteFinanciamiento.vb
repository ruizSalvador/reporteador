Imports DevExpress.XtraReports.UI
Imports DevExpress.XtraEditors.Controls
Imports System.Data.SqlClient

Public Class CtrlUser_RPT_EstadoEjercicioIngresos_FuenteFinanciamiento

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


    Function fuenteFinan() As String
        If filterUnidadResponsable.Properties.KeyValue = Nothing Then
            Return "Todos"
        Else
            Return filterUnidadResponsable.Properties.KeyValue
        End If
    End Function



    Private Sub SimpleButton1_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton1.Click
        'ErrorProvider1.Clear()
        'If filterUnidadResponsable.Text.Trim = "" Then
        '    ErrorProvider1.SetError(filterUnidadResponsable, "Ingrese una fuente de financiamiento.")
        '    Exit Sub
        'End If

        Me.Cursor = Cursors.WaitCursor
        SplitContainerControl1.Collapsed = True
        ErrorProvider1.Clear()
        Dim reporte As New RPT_EstadoEjercicioIngresos_FuenteFinanciamientoV2
        Dim printTool As New ReportPrintTool(reporte)


        '-------------------------------------------------------------------------
        Dim str As String = ""
        If chkListFF.CheckedItems.Count <> 0 Then

            Dim x As Integer

            For x = 0 To chkListFF.CheckedItems.Count - 1
                'ControlChars.CrLf
                str = str & "," & "'" & chkListFF.CheckedItems(x).ToString & "'"
            Next x
        End If

        Dim cadena As String = ""
        If str <> "" Then
            cadena = str.Remove(0, 1)
        Else : cadena = "'false'"
        End If


        Dim SQLConexion As SqlConnection
        Dim SQLmConnStr As String = ""
        SQLmConnStr = cnnString



        '--Codgio para Llenar Reporte con SP
        SQLConexion = New SqlConnection(SQLmConnStr)
        SQLConexion.Open()
        Dim SQLComando As New SqlCommand("SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2", SQLConexion)
        SQLComando.CommandType = CommandType.StoredProcedure
        '--- Parametros 
        If ChkAnual.Checked = True Then
            SQLComando.Parameters.Add(New SqlParameter("@MesInicio", 0))
            SQLComando.Parameters.Add(New SqlParameter("@MesFin", 0))
        Else
            SQLComando.Parameters.Add(New SqlParameter("@MesInicio", filterPeriodoIni.Time.Month))
            SQLComando.Parameters.Add(New SqlParameter("@MesFin", filterPeriodoFin.Time.Month))
        End If
        SQLComando.Parameters.Add(New SqlParameter("@MostrarVacios", ChkMuestraNulos.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@Ejercicio", filterEjercicio.Time.Year))
        'If filterUnidadResponsable.Text <> "" Then
        '    SQLComando.Parameters.Add(New SqlParameter("@IdFuenteFinanciamiento", filterUnidadResponsable.EditValue))
        'Else
        '    SQLComando.Parameters.Add(New SqlParameter("@IdFuenteFinanciamiento", ""))
        'End If
        SQLComando.Parameters.Add(New SqlParameter("@CadenaFF", cadena))
        SQLComando.Parameters.Add(New SqlParameter("@AprAnual", chkAprAnual.Checked))
        SQLComando.Parameters.Add(New SqlParameter("@AmpRedAnual", chkAmpRed.Checked))


        Dim adapter As New SqlDataAdapter(SQLComando)
        Dim ds As New DataSet()
        ds.EnforceConstraints = False
        adapter.Fill(ds, "SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2")
        reporte.DataSource = ds
        reporte.DataAdapter = adapter
        reporte.DataMember = "SP_EstadoEjercicioIngresos_FuenteFinanciamientoV2"

        SQLComando.Dispose()
        SQLConexion.Close()
        '---Fin de llenado de reporte

        'Firmas 
        Dim adapterC As SqlClient.SqlDataAdapter
        adapterC = New SqlClient.SqlDataAdapter("SELECT * FROM VW_RPT_K2_Firmas2 where Formato = 'Estado Analitico De Ingresos por fuente de financiamiento' and (Nombre1 <>'' or Puesto1 <> '' or Nombre2 <>'' or Puesto2<>'') Order by Orden ", cnnString)
        Dim dsC As New DataSet()
        dsC.EnforceConstraints = False
        adapterC.Fill(dsC, "VW_RPT_K2_Firmas2")
        reporte.XrSubreport1.ReportSource.DataSource = dsC
        reporte.XrSubreport1.ReportSource.DataAdapter = adapterC
        reporte.XrSubreport1.ReportSource.DataMember = "VW_RPT_K2_Firmas2"


        Dim ctrlRPTCFGDatosEntes As New clsRPT_CFG_DatosEntesCtrl
        Dim pRPTCFGDatosEntes As New clsRPT_CFG_DatosEntes

        pRPTCFGDatosEntes = ctrlRPTCFGDatosEntes.GetOne

        '--- Llenar datos del ente
        With reporte
            .lblRptNombreEnte.Text = pRPTCFGDatosEntes.Nombre
            .lblTitulo.Text = filterUnidadResponsable.Text '"Fuente de Financiamiento"
            .lblRptNombreReporte.Text = "Estado Analítico de Ingresos"
            .lblSubtitulo.Text = "Por: " + fuenteFinan()
            .lblRptEnteDomicilio.Text = pRPTCFGDatosEntes.Domicilio
            .lblRptEnteCiudad.Text = pRPTCFGDatosEntes.Ciudad + ", " + pRPTCFGDatosEntes.EntidadFederativa
            .lblRptEnteRFC.Text = pRPTCFGDatosEntes.RFC
            .lblRptEnteTelefono.Text = pRPTCFGDatosEntes.Telefonos
            .PICEnteLogo.Image = pRPTCFGDatosEntes.LogoEnte
            .PICEnteLogoSecundario.Image = pRPTCFGDatosEntes.LogoEnteSecundario
            If ChkAnual.Checked = True Then
                .lblRptDescripcionFiltrado.Text = "DEL 1/1/" & filterEjercicio.Time.Year.ToString & " Al " & "31/12/" & filterEjercicio.Time.Year.ToString
            Else
                .lblRptDescripcionFiltrado.Text = "DEL 1/" & filterPeriodoIni.Time.Month.ToString & "/" & filterEjercicio.Time.Year.ToString & " Al " & DateTime.DaysInMonth(filterEjercicio.Time.Year, filterPeriodoFin.Time.Month).ToString & "/" & filterPeriodoFin.Time.Month.ToString & "/" & filterEjercicio.Time.Year.ToString
            End If
            .XrLblUsr.Text = "Generado por: " + MDI_Principal.strUsuario
            Dim cmd As New SqlCommand("SELECT TOP(1) T_Firmas.CodigoISO FROM C_Formatos JOIN T_Firmas ON C_Formatos.IdFormato = T_Firmas.IdFormato  Where Formato='Estado Analitico De Ingresos por fuente de financiamiento' ", New SqlConnection(cnnString))
            cmd.Connection.Open()
            Dim reader = cmd.ExecuteScalar()
            cmd.Connection.Close()
            .XrLblIso.Text = reader
        End With

        PrintControl1.PrintingSystem = reporte.PrintingSystem
        reporte.CreateDocument()
        Me.Cursor = Cursors.Default

    End Sub

    Private Sub CtrlUser_RPT_EstadoEjercicioIngresos_FuenteFinanciamiento_Load(ByVal sender As Object, ByVal e As System.EventArgs) Handles Me.Load
        fuenteFinan()
        filterPeriodoFin.Time = Now
        filterEjercicio.Time = Now
        filterPeriodoIni.Time = Now

        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl

        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by DESCRIPCION ")
            '.DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento UNION Select '' as FUENTEFINANCIAMIENTO, '(Ingreso sin Clasificar)' as DESCRIPCION, '' as CLAVE, '' as TIPOORIGENRECURSO, '' as IDCUENTABANCARIA", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True

            '--------------------------------------------
            Dim SQLConexion As SqlConnection
            SQLConexion = New SqlConnection(cnnString)
            SQLConexion.Open()
            Dim iProv As Int16 = 0
            'iProv = filterProv.EditValue
            Dim sql As String = "Select Clave, Descripcion From C_FuenteFinanciamiento Order by IDFUENTEFINANCIAMIENTO "
            Dim command As New SqlCommand(sql, SQLConexion)
            Dim reader As SqlDataReader = command.ExecuteReader()

            chkListFF.Items.Clear()
            While reader.Read
                chkListFF.BeginUpdate()
                chkListFF.Items.Add(reader.Item("Clave"))
                chkListFF.EndUpdate()
            End While
        End With
    End Sub

    Private Sub FuenteFinanciamiento(ByVal sender As Object, ByVal e As System.EventArgs) Handles filterUnidadResponsable.GotFocus
        Dim ObjTempSQL As New clsRPT_CFG_DatosEntesCtrl
        With filterUnidadResponsable.Properties
            .DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento", " Order by DESCRIPCION ")
            '.DataSource = ObjTempSQL.List("", 0, "C_FuenteFinanciamiento UNION Select '' as FUENTEFINANCIAMIENTO, '(Ingreso sin Clasificar)' as DESCRIPCION, '' as CLAVE, '' as TIPOORIGENRECURSO, '' as IDCUENTABANCARIA", " Order by DESCRIPCION ")
            .DisplayMember = "DESCRIPCION"
            .ValueMember = "IDFUENTEFINANCIAMIENTO"
            .SearchMode = DevExpress.XtraEditors.Controls.SearchMode.AutoFilter
            .NullText = ""
            .ShowHeader = True
        End With
    End Sub

    Private Sub SimpleButton2_Click(ByVal sender As System.Object, ByVal e As System.EventArgs) Handles SimpleButton2.Click
        filterUnidadResponsable.Properties.KeyValue = Nothing
    End Sub

    Private Sub ChkAnual_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles ChkAnual.CheckedChanged
        If ChkAnual.Checked = True Then
            filterPeriodoFin.Enabled = False
            filterPeriodoIni.Enabled = False
        Else
            filterPeriodoFin.Enabled = True
            filterPeriodoIni.Enabled = True
        End If
    End Sub

    Private Sub chkAll_CheckedChanged(sender As System.Object, e As System.EventArgs) Handles chkAll.CheckedChanged
        For x As Integer = 0 To chkListFF.Items.Count - 1
            chkListFF.SetItemChecked(x, chkAll.Checked)
        Next
    End Sub
End Class